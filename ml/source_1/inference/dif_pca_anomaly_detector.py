"""
DIF (Dynamic Inner Floor) + PCA + Hotelling's T² Anomaly Detector

This combines three complementary techniques:
1. DIF: Establishes dynamic baseline for normal operation
2. PCA: Reduces dimensionality while preserving variance
3. Hotelling's T²: Multivariate statistical test for anomalies

Usage:
    python -m ml.source_1.inference.dif_pca_anomaly_detector --context source1_productA_stepHeating --interval 2
"""

import sys
from pathlib import Path

# Add ml/shared to Python path
sys.path.insert(0, str(Path(__file__).parent.parent.parent / 'shared'))

import numpy as np
import redis
import json
import argparse
import time
from datetime import datetime
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from typing import Dict, List, Tuple, Optional

from redis_publisher import get_redis_client, publish_anomaly_result


class DIFPCAAnomalyDetector:
    """
    Anomaly detector combining DIF, PCA, and Hotelling's T² statistics.
    """
    
    def __init__(self, n_components: int = None, alpha: float = 0.01, window_size: int = 100):
        """
        Initialize the detector.
        
        Args:
            n_components: Number of PCA components (None = auto-select for 95% variance)
            alpha: Significance level for T² control limit (default: 0.01 = 99% confidence)
            window_size: Size of rolling window for DIF baseline
        """
        self.n_components = n_components
        self.alpha = alpha
        self.window_size = window_size
        
        self.scaler = StandardScaler()
        self.pca = None
        self.dif_baseline = None
        self.t2_limit = None
        self.is_trained = False
        
        # Historical data for rolling baseline
        self.history = []
        
    def fit(self, X: np.ndarray):
        """
        Train the model on normal operation data.
        
        Args:
            X: Training data (n_samples, n_features)
        """
        if len(X.shape) == 1:
            X = X.reshape(-1, 1)
            
        # Standardize data
        X_scaled = self.scaler.fit_transform(X)
        
        # Fit PCA
        if self.n_components is None:
            # Auto-select components for 95% variance
            pca_temp = PCA()
            pca_temp.fit(X_scaled)
            cumsum = np.cumsum(pca_temp.explained_variance_ratio_)
            n_comp = np.argmax(cumsum >= 0.95) + 1
            self.n_components = max(1, n_comp)
        
        self.pca = PCA(n_components=self.n_components)
        X_pca = self.pca.fit_transform(X_scaled)
        
        # Calculate Hotelling's T² control limit
        n_samples, p = X_pca.shape
        self.t2_limit = self._calculate_t2_limit(n_samples, p)
        
        # Establish DIF baseline (mean and std of normal operation)
        self.dif_baseline = {
            'mean': np.mean(X_scaled, axis=0),
            'std': np.std(X_scaled, axis=0),
            'lower': np.mean(X_scaled, axis=0) - 3 * np.std(X_scaled, axis=0),
            'upper': np.mean(X_scaled, axis=0) + 3 * np.std(X_scaled, axis=0)
        }
        
        self.is_trained = True
        print(f"Model trained: {self.n_components} PCA components, T² limit: {self.t2_limit:.2f}")
        
    def _calculate_t2_limit(self, n: int, p: int) -> float:
        """
        Calculate Hotelling's T² control limit.
        
        For large samples: T² ~ χ²(p)
        For small samples: T² ~ ((n-1)*p/(n-p)) * F(p, n-p, α)
        """
        from scipy.stats import chi2, f
        
        if n > 30:
            # Large sample approximation
            return chi2.ppf(1 - self.alpha, p)
        else:
            # Small sample (F-distribution)
            f_val = f.ppf(1 - self.alpha, p, n - p)
            return ((n - 1) * p / (n - p)) * f_val
    
    def predict(self, x: np.ndarray) -> Dict:
        """
        Detect anomaly and compute scores.
        
        Args:
            x: Input sample (n_features,)
            
        Returns:
            Dict with anomaly score, T² statistic, contributions, and flags
        """
        if not self.is_trained:
            raise ValueError("Model must be trained before prediction")
        
        if len(x.shape) == 1:
            x = x.reshape(1, -1)
        
        # Standardize
        x_scaled = self.scaler.transform(x)
        
        # PCA transform
        x_pca = self.pca.transform(x_scaled)
        
        # Calculate Hotelling's T²
        t2_stat = self._hotellings_t2(x_pca)
        
        # Normalize T² to [0, 1] anomaly score
        anomaly_score = min(1.0, t2_stat / (self.t2_limit * 2))
        
        # Check DIF violations (out of baseline bounds)
        dif_violations = self._check_dif_violations(x_scaled[0])
        
        # Calculate channel contributions (squared loadings weighted by distance from mean)
        contributions = self._calculate_contributions(x_scaled[0], x_pca[0])
        
        return {
            'anomaly_score': float(anomaly_score),
            't2_statistic': float(t2_stat),
            't2_limit': float(self.t2_limit),
            'is_anomaly': t2_stat > self.t2_limit,
            'dif_violations': dif_violations,
            'contributions': contributions,
            'timestamp': datetime.now().isoformat()
        }
    
    def _hotellings_t2(self, x_pca: np.ndarray) -> float:
        """Calculate Hotelling's T² statistic."""
        # T² = x^T * Σ^(-1) * x
        # For PCA: T² = sum((score_i / std_i)²)
        scores_std = np.std(x_pca, axis=0)
        if len(scores_std) == 0 or np.any(scores_std == 0):
            scores_std = np.ones_like(scores_std)
        t2 = np.sum((x_pca / scores_std) ** 2)
        return t2
    
    def _check_dif_violations(self, x_scaled: np.ndarray) -> List[int]:
        """Check which channels violate DIF baseline."""
        violations = []
        for i, val in enumerate(x_scaled):
            if val < self.dif_baseline['lower'][i] or val > self.dif_baseline['upper'][i]:
                violations.append(i)
        return violations
    
    def _calculate_contributions(self, x_scaled: np.ndarray, x_pca: np.ndarray) -> Dict[str, float]:
        """
        Calculate contribution of each original variable to the anomaly.
        Based on squared loadings weighted by PCA scores.
        """
        contributions = {}
        loadings = self.pca.components_  # Shape: (n_components, n_features)
        
        for i in range(x_scaled.shape[0]):
            # Contribution = sum over components of (loading * score)²
            contrib = np.sum((loadings[:, i] * x_pca) ** 2)
            contributions[f"channel_{i+1}"] = float(contrib)
        
        # Normalize to sum to 100 (percentage)
        total = sum(contributions.values())
        if total > 0:
            contributions = {k: (v/total) * 100 for k, v in contributions.items()}
        
        return contributions


def generate_training_data(n_samples: int, n_features: int) -> np.ndarray:
    """Generate synthetic normal operation data."""
    # Normal multivariate data with some correlation
    mean = np.random.randn(n_features) * 2
    cov = np.random.rand(n_features, n_features)
    cov = np.dot(cov, cov.T)  # Make positive semi-definite
    return np.random.multivariate_normal(mean, cov, n_samples)


def generate_test_sample(n_features: int, anomaly_prob: float = 0.2) -> np.ndarray:
    """Generate a test sample (normal or anomalous)."""
    if np.random.rand() < anomaly_prob:
        # Anomalous: inject outliers
        sample = np.random.randn(n_features) * 5 + np.random.randn(n_features) * 10
    else:
        # Normal
        sample = np.random.randn(n_features) * 2
    return sample


def publish_to_redis_deprecated(source_name: str, result: Dict):
    """
    DEPRECATED: Old source-based publishing. Use context-based publishing instead.
    Kept for backward compatibility.
    """
    r = redis.Redis(host='localhost', port=6379)
    
    # Publish score
    r.publish(f'sources:{source_name}:anomaly:score', json.dumps({
        'score': result['anomaly_score'],
        't2_statistic': result['t2_statistic'],
        't2_limit': result['t2_limit'],
        'is_anomaly': bool(result['is_anomaly']),
        'timestamp': result['timestamp']
    }, default=str))
    
    # Publish contributions
    r.publish(f'sources:{source_name}:anomaly:contributions', json.dumps({
        'contributions': result['contributions'],
        'dif_violations': [int(v) for v in result['dif_violations']],
        'timestamp': result['timestamp']
    }, default=str))
    
    # Log to console
    status = "🔴 ANOMALY" if result['is_anomaly'] else "🟢 Normal"
    print(f"{status} | Score: {result['anomaly_score']:.3f} | T²: {result['t2_statistic']:.2f}/{result['t2_limit']:.2f}")


def publish_to_redis_context(context_name: str, result: Dict, redis_client: redis.Redis):
    """
    Publish anomaly detection results to Redis using context-based channel naming.
    Uses shared redis_publisher utilities for consistent channel names.
    """
    # Publish both score and contributions using shared utility
    publish_anomaly_result(
        redis_client=redis_client,
        context_name=context_name,
        timestamp=result['timestamp'],
        is_anomaly=bool(result['is_anomaly']),
        anomaly_score=result['anomaly_score'],
        t2_statistic=result['t2_statistic'],
        control_limit=result['t2_limit'],
        contributions=result['contributions']
    )
    
    # Log to console
    status = "🔴 ANOMALY" if result['is_anomaly'] else "🟢 Normal"
    print(f"{status} | Context: {context_name} | Score: {result['anomaly_score']:.3f} | T²: {result['t2_statistic']:.2f}/{result['t2_limit']:.2f}")


def main():
    parser = argparse.ArgumentParser(description='DIF + PCA + Hotelling T² Anomaly Detector')
    parser.add_argument('--context', type=str, default='source1:stepHeating',
                        help='Context name in hierarchical format: source:step (default: source1:stepHeating)')
    parser.add_argument('--source', type=str, default=None,
                        help='[DEPRECATED] Use --context instead. Source name for backward compatibility.')
    parser.add_argument('--interval', type=float, default=2.0,
                        help='Interval between updates in seconds (default: 2.0)')
    parser.add_argument('--channels', type=int, default=5,
                        help='Number of channels/features (default: 5)')
    parser.add_argument('--train-samples', type=int, default=200,
                        help='Number of training samples (default: 200)')
    parser.add_argument('--pca-components', type=int, default=None,
                        help='Number of PCA components (default: auto)')
    parser.add_argument('--anomaly-prob', type=float, default=0.2,
                        help='Probability of injecting anomaly (default: 0.2)')
    parser.add_argument('--count', type=int, default=None,
                        help='Number of iterations (default: infinite)')
    
    args = parser.parse_args()
    
    # Handle backward compatibility
    if args.source is not None:
        print("⚠️  Warning: --source is deprecated. Use --context instead.")
        context_name = args.source
        use_legacy_channels = True
    else:
        context_name = args.context
        use_legacy_channels = False
    
    print(f"🚀 Starting DIF + PCA + Hotelling's T² Anomaly Detector")
    print(f"   Context: {context_name}")
    print(f"   Channel naming: {'LEGACY (sources:X)' if use_legacy_channels else 'CONTEXT-BASED (contextname:anomaly:X)'}")
    print(f"   Channels: {args.channels}")
    print(f"   Interval: {args.interval}s")
    print(f"   PCA components: {args.pca_components or 'auto'}")
    print()
    
    # Get Redis client
    redis_client = get_redis_client()
    
    # Train the model
    print("📊 Training model on normal operation data...")
    X_train = generate_training_data(args.train_samples, args.channels)
    detector = DIFPCAAnomalyDetector(n_components=args.pca_components)
    detector.fit(X_train)
    print()
    
    print("🔍 Starting real-time anomaly detection...")
    print("Press Ctrl+C to stop\n")
    
    iteration = 0
    try:
        while True:
            if args.count is not None and iteration >= args.count:
                break
            
            # Generate test sample
            x = generate_test_sample(args.channels, args.anomaly_prob)
            
            # Predict
            result = detector.predict(x)
            
            # Publish to Redis
            if use_legacy_channels:
                publish_to_redis_deprecated(context_name, result)
            else:
                publish_to_redis_context(context_name, result, redis_client)
            
            iteration += 1
            time.sleep(args.interval)
            
    except KeyboardInterrupt:
        print("\n\n✋ Stopped by user")
    except Exception as e:
        print(f"\n❌ Error: {e}")


if __name__ == "__main__":
    main()

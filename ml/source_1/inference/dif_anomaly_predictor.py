
import redis
import json
import argparse
import time
import random
from datetime import datetime

"""
Inference predictor for OOS hard check.

Example usage:
    from ml.source_1.inference.oos_hard_check_predictor import predict
    result = predict(data)
    
Command line usage:
    python -m ml.source_1.inference.oos_hard_check_predictor --source source_1 --interval 2
"""

def predict(data):
    """
    Run inference for OOS hard check.
    
    Args:
        data: Input data for prediction
        
    Returns:
        Prediction result
    """
    # Load model and run inference
    pass


def publish_anomaly_data(source_name: str, score: float = None, contributions: dict = None):
    """
    Publish anomaly data to Redis channels.
    
    Args:
        source_name: Name of the source
        score: Anomaly score (0.0 to 1.0)
        contributions: Dictionary of channel contributions
    """
    r = redis.Redis(host='localhost', port=6379)
    timestamp = datetime.now().isoformat()
    
    if score is not None:
        r.publish(f'sources:{source_name}:anomaly:score', json.dumps({
            "score": score,
            "timestamp": timestamp
        }))
        print(f"Published score: {score} for {source_name}")
    
    if contributions is not None:
        r.publish(f'sources:{source_name}:anomaly:contributions', json.dumps({
            "contributions": contributions,
            "timestamp": timestamp
        }))
        print(f"Published contributions for {source_name}")


def generate_random_anomaly_data(num_channels: int = 5):
    """Generate random anomaly data for testing."""
    score = random.uniform(0.0, 1.0)
    contributions = {
        f"channel_{i}": random.uniform(0.0, 1.0) 
        for i in range(1, num_channels + 1)
    }
    # Normalize contributions to sum to 100 (percentage)
    total = sum(contributions.values())
    contributions = {k: (v/total) * 100 for k, v in contributions.items()}
    
    return score, contributions


def main():
    parser = argparse.ArgumentParser(description='OOS Hard Check Anomaly Detector')
    parser.add_argument('--source', type=str, default='source_1',
                        help='Source name (default: source_1)')
    parser.add_argument('--interval', type=float, default=2.0,
                        help='Interval between updates in seconds (default: 2.0)')
    parser.add_argument('--score', type=float, default=None,
                        help='Fixed anomaly score (default: random)')
    parser.add_argument('--channels', type=int, default=5,
                        help='Number of channels for contributions (default: 5)')
    parser.add_argument('--count', type=int, default=None,
                        help='Number of iterations (default: infinite)')
    
    args = parser.parse_args()
    
    print(f"Starting anomaly detector for source: {args.source}")
    print(f"Publishing every {args.interval} seconds")
    print("Press Ctrl+C to stop\n")
    
    iteration = 0
    try:
        while True:
            if args.count is not None and iteration >= args.count:
                break
            
            # Generate or use fixed score
            if args.score is not None:
                score = args.score
                _, contributions = generate_random_anomaly_data(args.channels)
            else:
                score, contributions = generate_random_anomaly_data(args.channels)
            
            # Publish to Redis
            publish_anomaly_data(args.source, score, contributions)
            
            iteration += 1
            time.sleep(args.interval)
            
    except KeyboardInterrupt:
        print("\n\nStopped by user")
    except Exception as e:
        print(f"\nError: {e}")


if __name__ == "__main__":
    main()

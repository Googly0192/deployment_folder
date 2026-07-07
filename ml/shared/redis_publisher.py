"""
Shared utilities for publishing anomaly detection results to Redis.
Provides standardized channel naming and message formatting.
"""
import json
from typing import Dict, Any, Optional
import redis


def get_redis_client(host: str = 'localhost', port: int = 6379, db: int = 0) -> redis.Redis:
    """
    Get a Redis client connection.
    
    Args:
        host: Redis server host
        port: Redis server port
        db: Redis database number
        
    Returns:
        Redis client instance
    """
    return redis.Redis(host=host, port=port, db=db, decode_responses=True)


def publish_anomaly_score(
    redis_client: redis.Redis,
    context_name: str,
    timestamp: str,
    is_anomaly: bool,
    anomaly_score: float,
    dif_score: float,
    threshold: float,
    channel_values: Optional[Dict[str, float]] = None
) -> bool:
    """
    Publish DIF anomaly score to Redis using context-based channel naming.
    
    Args:
        redis_client: Redis client instance
        context_name: Name of the context (e.g., 'source1_productA_stepHeating')
        timestamp: ISO format timestamp
        is_anomaly: Boolean indicating if this is an anomaly
        anomaly_score: Normalized anomaly score (distance/threshold)
        dif_score: Deep Isolation Forest distance score
        threshold: Anomaly threshold
        channel_values: Optional dictionary of channel values that produced this score
        
    Returns:
        True if publish succeeded, False otherwise
        
    Example:
        >>> publish_anomaly_score(
        ...     redis_client,
        ...     'source1_productA_stepHeating',
        ...     '2026-01-26T10:00:00Z',
        ...     True,
        ...     1.25,
        ...     25.5,
        ...     20.0,
        ...     {'temp': 100.5, 'pressure': 50.2}
        ... )
    """
    channel = f"{context_name}:anomaly:score"
    
    message = {
        'timestamp': timestamp,
        'is_anomaly': bool(is_anomaly),
        'anomaly_score': float(anomaly_score),
        'dif_score': float(dif_score),
        'threshold': float(threshold)
    }
    
    if channel_values:
        message['channel_values'] = {k: float(v) for k, v in channel_values.items()}
    
    try:
        redis_client.publish(channel, json.dumps(message))
        return True
    except Exception as e:
        print(f"Failed to publish anomaly score to {channel}: {e}")
        return False


def publish_anomaly_contributions(
    redis_client: redis.Redis,
    context_name: str,
    timestamp: str,
    contributions: Dict[str, float],
    is_anomaly: bool
) -> bool:
    """
    Publish SHAP feature contributions to Redis using context-based channel naming.
    
    Args:
        redis_client: Redis client instance
        context_name: Name of the context
        timestamp: ISO format timestamp
        contributions: Dictionary mapping feature names to SHAP contribution values
        is_anomaly: Boolean indicating if this is an anomaly
        
    Returns:
        True if publish succeeded, False otherwise
        
    Example:
        >>> publish_anomaly_contributions(
        ...     redis_client,
        ...     'source1_productA_stepHeating',
        ...     '2026-01-26T10:00:00Z',
        ...     {'temp': 0.45, 'pressure': -0.32, 'flow': 0.24},
        ...     True
        ... )
        ... )
    """
    channel = f"{context_name}:anomaly:contributions"
    
    # Ensure contributions are floats and percentages (0-100)
    normalized_contributions = {k: float(v) for k, v in contributions.items()}
    
    message = {
        'timestamp': timestamp,
        'contributions': normalized_contributions,
        'is_anomaly': bool(is_anomaly)
    }
    
    try:
        redis_client.publish(channel, json.dumps(message))
        return True
    except Exception as e:
        print(f"Failed to publish contributions to {channel}: {e}")
        return False


def publish_anomaly_result(
    redis_client: redis.Redis,
    source_name: str,
    timestamp: str,
    is_anomaly: bool,
    anomaly_score: float,
    dif_score: float,
    threshold: float,
    contributions: Dict[str, float],
    channel_values: Optional[Dict[str, float]] = None,
    context_name: Optional[str] = None,
    recipe_name: Optional[str] = None,
) -> bool:
    """
    Publish DIF anomaly results with SHAP contributions to source-based channels.
    
    Publishes to three separate channels:
    - {source}:anomaly:dif_score
    - {source}:anomaly:anomaly_score  
    - {source}:anomaly:shap_contributions
    
    Args:
        redis_client: Redis client instance
        source_name: Name of the source
        timestamp: ISO format timestamp
        is_anomaly: Boolean indicating if this is an anomaly
        anomaly_score: Normalized anomaly score (distance/threshold)
        dif_score: Deep Isolation Forest distance score
        threshold: Anomaly threshold
        contributions: Dictionary mapping feature names to SHAP contribution values
        channel_values: Optional dictionary of channel values
        
    Returns:
        True if all publishes succeeded, False otherwise
    """
    # Publish DIF score
    dif_channel = f"{source_name}:anomaly:dif_score"
    dif_message = {
        'timestamp': timestamp,
        'is_anomaly': bool(is_anomaly),
        'dif_score': float(dif_score),
        'threshold': float(threshold),
        'context_name': context_name,
        'recipe_name': recipe_name,
    }
    if channel_values:
        dif_message['channel_values'] = {k: float(v) for k, v in channel_values.items()}
    
    # Publish anomaly score
    score_channel = f"{source_name}:anomaly:anomaly_score"
    score_message = {
        'timestamp': timestamp,
        'is_anomaly': bool(is_anomaly),
        'anomaly_score': float(anomaly_score),
        'threshold': float(threshold),
        'context_name': context_name,
        'recipe_name': recipe_name,
    }
    
    # Publish SHAP contributions
    contrib_channel = f"{source_name}:anomaly:shap_contributions"
    contrib_message = {
        'timestamp': timestamp,
        'is_anomaly': bool(is_anomaly),
        'contributions': {k: float(v) for k, v in contributions.items()},
        'context_name': context_name,
        'recipe_name': recipe_name,
    }
    
    try:
        redis_client.publish(dif_channel, json.dumps(dif_message))
        redis_client.publish(score_channel, json.dumps(score_message))
        redis_client.publish(contrib_channel, json.dumps(contrib_message))
        return True
    except Exception as e:
        print(f"Failed to publish anomaly results: {e}")
        return False


def publish_svm_result(
    redis_client: redis.Redis,
    source_name: str,
    timestamp: str,
    context_name: str,
    recipe_name: str,
    predicted_class: str,
    raw_predicted_class: str,
    is_fault: bool,
    is_unknown: bool,
    z_score: float,
    decision_score: float,
    decision_scores_full: list[float] | None = None,
    pca_x: float = 0.0,
    pca_y: float = 0.0,
    confidence: float = 1.0,
    confidence_threshold: float = 0.6,
    unknown_label: str = "UNKNOWN",
    class_confidences: dict[str, float] | None = None,
    classes: list[str] | None = None,
    normal_class: str = "normal",
    measurement_count: int = 0,
) -> bool:
    """
    Publish SVM inference output to a source-based Redis channel.

    Channel format mirrors existing source-prefixed worker outputs:
    - {source}:svm:prediction
    """
    channel = f"{source_name}:svm:prediction"
    message = {
        "timestamp": timestamp,
        "source_name": source_name,
        "context_name": context_name,
        "recipe_name": recipe_name,
        "predicted_class": str(predicted_class),
        "raw_predicted_class": str(raw_predicted_class),
        "is_fault": bool(is_fault),
        "is_unknown": bool(is_unknown),
        "fault_class": str(predicted_class) if is_fault else None,
        "z_score": float(z_score),
        "decision_score": float(decision_score),
        "decision_scores_full": [float(v) for v in (decision_scores_full or [])],
        "pca_x": float(pca_x),
        "pca_y": float(pca_y),
        "confidence": float(confidence),
        "confidence_threshold": float(confidence_threshold),
        "unknown_label": str(unknown_label),
        "class_confidences": {str(k): float(v) for k, v in (class_confidences or {}).items()},
        "classes": [str(item) for item in (classes or [])],
        "normal_class": str(normal_class),
        "measurement_count": int(measurement_count),
    }

    try:
        redis_client.publish(channel, json.dumps(message))
        return True
    except Exception as e:
        print(f"Failed to publish SVM result to {channel}: {e}")
        return False


def publish_lstm_result(
    redis_client: redis.Redis,
    source_name: str,
    timestamp: str,
    context_name: str,
    recipe_name: str,
    global_reconstruction_error: float,
    global_threshold_95: float,
    global_threshold_99: float,
    is_anomaly: bool,
    exceeded_sensors: list[dict],
    sensor_errors: dict[str, float],
    sensor_reconstructions: dict[str, float],
    future_prediction: dict[str, list[float]],
    future_prediction_error_95: dict[str, list[float]],
    measurement_count: int,
) -> bool:
    """
    Publish LSTM inference output to a source-based Redis channel.

    Channel format mirrors other source-prefixed worker outputs:
    - {source}:lstm:prediction
    """
    channel = f"{source_name}:lstm:prediction"
    message = {
        "timestamp": timestamp,
        "source_name": source_name,
        "context_name": context_name,
        "recipe_name": recipe_name,
        "global_reconstruction_error": float(global_reconstruction_error),
        "global_threshold_95": float(global_threshold_95),
        "global_threshold_99": float(global_threshold_99),
        "is_anomaly": bool(is_anomaly),
        "exceeded_sensors": [
            {
                "sensor": str(item.get("sensor", "unknown")),
                "error": float(item.get("error", 0.0)),
                "threshold": float(item.get("threshold", 0.0)),
            }
            for item in exceeded_sensors
        ],
        "sensor_errors": {str(k): float(v) for k, v in sensor_errors.items()},
        "sensor_reconstructions": {str(k): float(v) for k, v in sensor_reconstructions.items()},
        "future_prediction": {
            str(k): list(v) if isinstance(v, (list, tuple)) else v
            for k, v in future_prediction.items()
        },
        "future_prediction_error_95": {
            str(k): list(v) if isinstance(v, (list, tuple)) else v
            for k, v in future_prediction_error_95.items()
        },
        "measurement_count": int(measurement_count),
    }

    try:
        redis_client.publish(channel, json.dumps(message))
        return True
    except Exception as e:
        print(f"Failed to publish LSTM result to {channel}: {e}")
        return False

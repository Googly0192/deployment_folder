"""
Model evaluation utilities.
"""

import numpy as np
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score


def evaluate_model(y_true, y_pred):
    """
    Evaluate model performance.
    
    Args:
        y_true: True labels
        y_pred: Predicted labels
        
    Returns:
        Dictionary of evaluation metrics
    """
    return {
        'accuracy': accuracy_score(y_true, y_pred),
        'precision': precision_score(y_true, y_pred, average='weighted'),
        'recall': recall_score(y_true, y_pred, average='weighted'),
        'f1': f1_score(y_true, y_pred, average='weighted')
    }

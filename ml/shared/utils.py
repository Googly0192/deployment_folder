"""
General utility functions for ML workflows.
"""

import os
import pickle
import torch


def save_model(model, filepath):
    """
    Save a trained model.
    
    Args:
        model: The model to save
        filepath: Path to save the model
    """
    if filepath.endswith('.pt'):
        torch.save(model.state_dict(), filepath)
    elif filepath.endswith('.pkl'):
        with open(filepath, 'wb') as f:
            pickle.dump(model, f)
    else:
        raise ValueError("Unsupported file format. Use .pt or .pkl")


def load_model(filepath, model_class=None):
    """
    Load a trained model.
    
    Args:
        filepath: Path to the saved model
        model_class: Model class (required for .pt files)
        
    Returns:
        Loaded model
    """
    if filepath.endswith('.pt'):
        if model_class is None:
            raise ValueError("model_class required for .pt files")
        model = model_class()
        model.load_state_dict(torch.load(filepath))
        return model
    elif filepath.endswith('.pkl'):
        with open(filepath, 'rb') as f:
            return pickle.load(f)
    else:
        raise ValueError("Unsupported file format. Use .pt or .pkl")

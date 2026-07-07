"""
Shared utilities for loading ML models by context.
Provides database-driven model path resolution and model loading.

Model loading (DIF, SVM) and inference wrappers are re-exported from the
workspace-level ``ml_inference`` package so that ml_desktop_enterprise and
Production_Code share the identical implementation.
"""
import json
import os
import sys
import logging
from pathlib import Path
from typing import Dict, Optional, Tuple
from functools import lru_cache
from collections import OrderedDict

# Re-export shared inference classes so existing callers need no import changes.
from ml_inference.model_loader import (  # noqa: F401  (public re-export)
    DIFModelWrapper,
    load_dif_model,
    SVMModelWrapper,
    load_svm_model,
)

# Add project root to path for imports
project_root = Path(__file__).parent.parent.parent
if str(project_root) not in sys.path:
    sys.path.insert(0, str(project_root))

from sqlalchemy import text
from apiserver.database.core import SessionLocal

logger = logging.getLogger(__name__)


def get_model_info_from_db(source_name: str, recipe_name: str, model_type: str) -> Optional[Dict]:
    """
    Get active model information from database.
    
    Args:
        source_name: Source name (e.g., 'source_1')
        recipe_name: Recipe name (e.g., 'Recipe_1')
        model_type: Model type (e.g., 'deep_isolation_forest')
        
    Returns:
        Dictionary containing model info (file_path, model_type, framework, etc.)
        or None if no active model found
    """
    db = SessionLocal()
    try:
        result = db.execute(
            text("SELECT * FROM get_active_model(:source_name, :recipe_name, :model_type)"),
            {"source_name": source_name, "recipe_name": recipe_name, "model_type": model_type}
        )
        row = result.fetchone()
        
        if row:
            return {
                'model_id': row[0],
                'version': row[1],
                'file_path': row[2],
                'model_type': row[3],
                'framework': row[4],
                'metrics': row[5]
            }
        return None
    except Exception as e:
        logger.error(f"Error querying database for model: {e}")
        return None
    finally:
        db.close()


_CONTEXT_CACHE_MAXSIZE = 128
_context_cache: "OrderedDict[str, Tuple[str, str]]" = OrderedDict()


def _cache_context(context_name: str, source_name: str, recipe_name: str) -> None:
    _context_cache[context_name] = (source_name, recipe_name)
    _context_cache.move_to_end(context_name)
    if len(_context_cache) > _CONTEXT_CACHE_MAXSIZE:
        _context_cache.popitem(last=False)


def _clear_context_cache() -> None:
    _context_cache.clear()


def get_source_and_recipe_from_context(context_name: str) -> Tuple[Optional[str], Optional[str]]:
    """
    Get source and recipe for a context by querying the database.
    
    Uses LRU cache to minimize database calls for repeated lookups.
    Cache can be cleared with: get_source_and_recipe_from_context.cache_clear()
    
    Args:
        context_name: Name of the context (e.g., 'example_source_2vids_context')
        
    Returns:
        Tuple of (source_name, recipe_name) or (None, None) if not found
    """
    cached = _context_cache.get(context_name)
    if cached:
        return cached

    db = SessionLocal()
    try:
        # Use database function for encapsulated logic
        result = db.execute(
            text("SELECT * FROM get_source_recipe_by_context(:context_name)"),
            {"context_name": context_name}
        )
        row = result.fetchone()

        if not row:
            logger.warning(f"Context not found or recipe not configured: {context_name}")
            return None, None

        source_name = row[0]
        recipe_name = row[1]

        if not source_name or not recipe_name:
            logger.warning(f"Source/recipe attribute not set for context: {context_name}")
            return source_name, None

        _cache_context(context_name, source_name, recipe_name)
        return source_name, recipe_name

    except Exception as e:
        logger.error(f"Error querying database for context info: {e}")
        return None, None
    finally:
        db.close()


get_source_and_recipe_from_context.cache_clear = _clear_context_cache


def get_model_path_by_context(context_name: str, model_type: str) -> Optional[Path]:
    """
    Get the path to the active model for a given context from database.

    Recipe is retrieved from product attributes, not from context name.

    Args:
        context_name: Name of the context (e.g., 'example_source_2vids_context')
        model_type: Model type (e.g., 'deep_isolation_forest')

    Returns:
        Path to the model directory, or None if not found

    Example:
        >>> model_path = get_model_path_by_context('example_source_2vids_context', 'deep_isolation_forest')
        >>> print(model_path)
        /path/to/ml/example_source_2vids/recipe_2/models/dif_anomaly/
    """
    # Get source and recipe from database
    source_name, recipe_name = get_source_and_recipe_from_context(context_name)
    if not source_name or not recipe_name:
        logger.warning(f"Could not resolve source and recipe for context: {context_name}")
        return None

    # Query database for active model
    model_info = get_model_info_from_db(source_name, recipe_name, model_type)
    if not model_info:
        logger.warning(f"No active model found for source='{source_name}', recipe='{recipe_name}'")
        return None

    # Get file path from database
    file_path = model_info['file_path']

    # Resolve to absolute path
    if Path(file_path).is_absolute():
        model_dir = Path(file_path)
    else:
        # Relative to project root
        model_dir = project_root / file_path

    if not model_dir.exists():
        logger.warning(f"Model directory does not exist: {model_dir}")
        return None

    return model_dir


def get_context_metadata(context_name: str) -> Dict:
    """
    Get metadata about a context (source, recipe).
    
    Recipe is retrieved from product attributes in the database.
    
    Args:
        context_name: Name of the context (e.g., 'example_source_2vids_context')
        
    Returns:
        Dictionary with context metadata
        
    Example:
        >>> metadata = get_context_metadata('example_source_2vids_context')
        >>> print(metadata['source'])  # 'example_source_2vids'
        >>> print(metadata['recipe'])  # 'recipe_2'
    """
    source_name, recipe_name = get_source_and_recipe_from_context(context_name)
    
    return {
        'context_name': context_name,
        'source': source_name,
        'recipe': recipe_name,
    }


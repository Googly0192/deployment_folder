# ML Context-Based Architecture

## Overview

This project uses a **context-based architecture** for machine learning model management. Each context represents a unique combination of:

- **Source** (manufacturing equipment/tool)
- **Product** (what is being manufactured)
- **Collection Plan** (which sensors/parameters are monitored)
- **Process Step** (specific step in the manufacturing process)

## Folder Structure

```
ml/
├── source_1/
│   ├── process_step_A/
│   │   ├── models/
│   │   │   ├── dif_v1.skops
│   │   │   ├── dif_v2.skops
│   │   │   └── active_model.txt (points to active version)
│   │   └── training_data/
│   │       ├── train_2024_01.csv
│   │       └── train_2024_02.csv
│   ├── process_step_B/
│   │   ├── models/
│   │   └── training_data/
│   └── inference/
│       ├── dif_pca_anomaly_detector.py
│       └── oos_hard_check_predictor.py
├── source_2/
│   └── process_step_X/
│       ├── models/
│       └── training_data/
└── shared/
    ├── model_loader.py (context-based model loading utilities)
    └── redis_publisher.py (standardized Redis publishing)
```

## Key Concepts

### Context-Based Model Organization

Each **source** (e.g., CNC machine, oven, press) can run multiple **process steps** (e.g., heating, cooling, pressing). Each process step has its own unique sensor signatures and therefore requires its own independently trained model.

**Example:**

- `source_1` (CNC Machine) produces `productA` (Widget)
  - `process_step_A`: Drilling operation
  - `process_step_B`: Milling operation
- Each step has different sensor readings (spindle speed, feed rate, temperature, etc.)
- Each step needs its own DIF (Dynamic Inner Floor) model

### Context Naming

Context names encode the manufacturing scenario:

```
{source}_{product}_{process_step}
```

Examples:

- `source1_productA_stepHeating`
- `source2_productB_stepCooling`
- `cnc_widget_drilling`

### Redis Channel Naming

**New Context-Based Channels:**

```
{context_name}:anomaly:score
{context_name}:anomaly:contributions
```

Examples:

- `source1_productA_stepHeating:anomaly:score`
- `source1_productA_stepHeating:anomaly:contributions`

**Legacy Source-Based Channels (deprecated):**

```
sources:{source_name}:anomaly:score
sources:{source_name}:anomaly:contributions
```

The system supports **both** channel formats for backward compatibility.

## Usage

### Running Inference Script with Context

**New context-based mode:**

```bash
python -m ml.source_1.inference.dif_pca_anomaly_detector --context source1_productA_stepHeating --interval 2
```

**Legacy source-based mode (deprecated):**

```bash
python -m ml.source_1.inference.dif_pca_anomaly_detector --source source_1 --interval 2
```

### Frontend Component

**New context-based mode:**

```tsx
<AnomalyDetectorCard contextName="source1_productA_stepHeating" />
```

**Legacy source-based mode (shows warning):**

```tsx
<AnomalyDetectorCard sourceName="source_1" />
```

### Backend WebSocket Endpoint

The endpoint accepts either context names or legacy source names:

```
ws://localhost:8000/Measurements/ws/DIF_anomaly_dispatcher/source1_productA_stepHeating
```

The backend subscribes to **both** channel formats:

- `{context_name}:anomaly:*` (new)
- `sources:{context_name}:anomaly:*` (legacy)

## Database Schema

### ml_models Table

Key columns:

- `source_id`: Reference to sources table
- `recipe_name`: Recipe/product being manufactured
- `process_step`: Specific process step (e.g., 'process_step_A', 'heating', 'cooling')
- `version`: Model version (e.g., 'v1', 'v2')
- `file_path`: Path to .skops model file
- `status`: 'development', 'staging', 'production', 'archived'

### Functions

**Get active model by context:**

```sql
SELECT * FROM get_active_model_by_context('source1_productA_stepHeating', 'process_step_A');
```

**Get active model by source/recipe/step:**

```sql
SELECT * FROM get_active_model(1, 'productA', 'process_step_A');
```

## Model Loading Flow

1. Inference script starts with `--context source1_productA_stepHeating`
2. Parse context name to extract process step (or query database)
3. Call `get_active_model_by_context()` to get:
   - Model file path (e.g., `ml/source_1/process_step_A/models/dif_v1.skops`)
   - Source ID, recipe name, process step
4. Load model using `skops.io.load()`
5. Run inference on incoming measurements
6. Publish results to Redis channel `{context_name}:anomaly:*`
7. Frontend subscribes to same channel and displays results

## Shared Utilities

### model_loader.py

Functions:

- `get_model_path_by_context(context_name)`: Get path to active model
- `load_dif_model(model_path)`: Load .skops model file
- `get_context_metadata(context_name)`: Get source, recipe, process_step info
- `get_training_data_path(source, process_step)`: Get training data directory

### redis_publisher.py

Functions:

- `publish_anomaly_score(redis_client, context_name, ...)`: Publish score
- `publish_anomaly_contributions(redis_client, context_name, ...)`: Publish contributions
- `publish_anomaly_result(...)`: Publish both score and contributions

## Migration from Source-Based to Context-Based

### Backward Compatibility

The system maintains **full backward compatibility**:

1. **Inference Scripts**: Accept both `--context` (new) and `--source` (legacy)
2. **Backend**: Subscribe to both channel formats
3. **Frontend**: Accept both `contextName` (new) and `sourceName` (legacy) props
4. **Redis Channels**: Publish to new format, subscribe to both

### Migration Steps

1. **Update inference scripts** to use `--context` parameter
2. **Update frontend components** to pass `contextName` instead of `sourceName`
3. **Phase out legacy channels** after confirming all clients migrated
4. **Remove backward compatibility code** in future release

## Model Versioning

Each process step can have multiple model versions:

```
ml/source_1/process_step_A/models/
├── dif_v1.skops (initial training)
├── dif_v2.skops (retrained with more data)
├── dif_v3.skops (tuned hyperparameters)
└── active_model.txt (contains: "dif_v2.skops")
```

The `ml_model_deployments` table tracks which version is active in each environment:

- `development`: Latest experimental version
- `staging`: Candidate for production
- `production`: Currently deployed version

## Best Practices

1. **One model per process step**: Each process step has unique sensor signatures
2. **Version control**: Track model versions in database, use semantic versioning
3. **Metadata files**: Keep `metadata.json` in each process_step directory
4. **Training data isolation**: Keep training data separate per process step
5. **Context naming consistency**: Use consistent naming convention for contexts
6. **Channel naming**: Always use context-based channels for new deployments
7. **Backward compatibility**: Support legacy channels during migration period

## Example: Adding New Process Step

1. **Create directory structure:**

   ```bash
   mkdir -p ml/source_1/process_step_C/models
   mkdir -p ml/source_1/process_step_C/training_data
   ```

2. **Create metadata.json:**

   ```json
   {
     "model_type": "DIF_PCA_Hotellings_T2",
     "source": "source_1",
     "process_step": "process_step_C",
     "active_model": null
   }
   ```

3. **Train model:**

   ```python
   from ml.source_1.inference.dif_pca_anomaly_detector import DIFPCAAnomalyDetector

   detector = DIFPCAAnomalyDetector()
   detector.fit(X_train)

   import skops.io as sio
   sio.dump(detector, "ml/source_1/process_step_C/models/dif_v1.skops")
   ```

4. **Register in database:**

   ```sql
   CALL add_ml_model(
     p_source_id := 1,
     p_recipe_name := 'productA',
     p_process_step := 'process_step_C',
     p_version := 'v1',
     p_file_path := 'ml/source_1/process_step_C/models/dif_v1.skops',
     p_model_type := 'anomaly_detection',
     p_framework := 'sklearn',
     p_created_by := 'data_scientist'
   );
   ```

5. **Deploy model:**

   ```sql
   CALL deploy_model(
     p_model_id := <returned_model_id>,
     p_environment := 'production',
     p_deployed_by := 'admin'
   );
   ```

6. **Run inference:**
   ```bash
   python -m ml.source_1.inference.dif_pca_anomaly_detector \
     --context source1_productA_stepC \
     --interval 2
   ```

## Troubleshooting

### Issue: Model not found

**Check:**

1. Does `metadata.json` exist?
2. Is `active_model` set in metadata?
3. Does the model file exist at the specified path?
4. Is there an active deployment in `ml_model_deployments` table?

### Issue: No data in frontend

**Check:**

1. Is inference script publishing to correct channel?
2. Is frontend connecting to correct WebSocket endpoint?
3. Check browser console for WebSocket connection errors
4. Check backend logs for Redis subscription confirmations

### Issue: Legacy mode warning

**Solution:**
Update frontend component to use `contextName` instead of `sourceName`:

```tsx
// Before
<AnomalyDetectorCard sourceName="source_1" />

// After
<AnomalyDetectorCard contextName="source1_productA_stepHeating" />
```

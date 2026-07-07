-- Delete all rows from all tables and reset primary key back to 1.

TRUNCATE TABLE measurements_1 RESTART IDENTITY CASCADE;
TRUNCATE TABLE measurements_2 RESTART IDENTITY CASCADE;
TRUNCATE TABLE measurements_4 RESTART IDENTITY CASCADE;
TRUNCATE TABLE measurements_8 RESTART IDENTITY CASCADE;
TRUNCATE TABLE collection_plans RESTART IDENTITY CASCADE;
TRUNCATE TABLE contexts RESTART IDENTITY CASCADE;
TRUNCATE TABLE products RESTART IDENTITY CASCADE;
TRUNCATE TABLE sources RESTART IDENTITY CASCADE;
TRUNCATE TABLE ml_models RESTART IDENTITY CASCADE;

-- INSERT sources Table
INSERT INTO sources (name, attributes, description)
values ('source_1', '{"Fab": "Fab_1", "Area": "F1.A1", "Tool": "F1.A1.T1", "Chamber": "F1.A1.T1.C1"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_2', '{"Fab": "Fab_1", "Area": "F1.A1", "Tool": "F1.A1.T1", "Chamber": "F1.A1.T1.C2"}'::jsonb, 'sources: F1.A1.T1.C2 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_3', '{"Fab": "Fab_1", "Area": "F1.A1", "Tool": "F1.A1.T2", "Chamber": "F1.A1.T2.C2"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_4', '{"Fab": "Fab_1", "Area": "F1.A2", "Tool": "F1.A2.T1", "Chamber": "F1.A2.T1.C1"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_5', '{"Fab": "Fab_2", "Area": "F2.A1", "Tool": "F2.A1.T1", "Chamber": "F2.A1.T1.C1"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_6', '{"Fab": "Fab_2", "Area": "F2.A2", "Tool": "F2.A2.T1", "Chamber": "F2.A2.T1.C1"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_7', '{"Fab": "Fab_2", "Area": "F2.A2", "Tool": "F2.A2.T2", "Chamber": "F2.A2.T2.C1"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');

INSERT INTO sources (name, attributes, description)
values ('source_8', '{"Fab": "Fab_2", "Area": "F2.A2", "Tool": "F2.A2.T2", "Chamber": "F2.A2.T2.C2"}'::jsonb, 'sources: F1.A1.T1.C1 Description....');
-- SELECT * FROM sources;

-- INSERT PRODUCTS TABLE
INSERT INTO products (name, attributes, description)
values ('product_1', '{"Recipe": "Recipe_1", "Lot": "Lot_1", "Slot": "L1.S1", "Wafer": "L1.S1.W1"}'::jsonb,    'products: L1.S1.W1 Description....');

INSERT INTO products (name, attributes, description)
values ('product_2', '{"Recipe": "Recipe_2", "Lot": "Lot_1", "Slot": "L1.S1", "Wafer": "L1.S1.W2"}'::jsonb,    'products: L1.S1.W2 Description....');

INSERT INTO products (name, attributes, description)
values ('product_3', '{"Recipe": "Recipe_3", "Lot": "Lot_1", "Slot": "L1.S2", "Wafer": "L1.S2.W1"}'::jsonb,    'products: L1.S2.W1 Description....');

INSERT INTO products (name, attributes, description)
values ('product_4', '{"Recipe": "Recipe_4", "Lot": "Lot_1", "Slot": "L1.S2", "Wafer": "L1.S2.W2"}'::jsonb,    'products: L1.S2.W2 Description....');   

INSERT INTO products (name, attributes, description)
values ('product_5', '{"Recipe": "Recipe_5", "Lot": "Lot_2", "Slot": "L2.S1", "Wafer": "L2.S1.W1"}'::jsonb,    'products: L2.S1.W1 Description....');

INSERT INTO products (name, attributes, description)
values ('product_6', '{"Recipe": "Recipe_6", "Lot": "Lot_2", "Slot": "L2.S2", "Wafer": "L2.S2.W2"}'::jsonb,    'products: L2.S2.W2 Description....');


-- SELECT * FROM products;

-- INSERT COLLECTION_PLANS TABLE
INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_1": {"col_1": "var_1"}
        }', 'Collection_Plan_1', ARRAY['var_1'], 'Collection_Plans: Collection_Plan_1');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_2": {"col_1": "var_1", "col_2": "var_2"}
        }', 'Collection_Plan_2', ARRAY['var_1', 'var_2'], 'Collection_Plans: Collection_Plan_2');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_1": {"col_1": "var_1"},
         "measurements_2": {"col_1": "var_2", "col_2": "var_3"}
        }', 'Collection_Plan_3', ARRAY['var_1', 'var_2', 'var_3'], 'Collection_Plans: Collection_Plan_3');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_4": {"col_1": "CP4T4C1", "col_2": "CP4T4C2", "col_3": "CP4T4C3", "col_4": "CP4T4C4"}
        }', 'Collection_Plan_4', ARRAY['CP4T4C1', 'CP4T4C2', 'CP4T4C3', 'CP4T4C4'], 'Collection_Plans: CP4.T4 Description');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_1": {"col_1": "CP5T1C1"},
         "measurements_4": {"col_1": "CP5T4C1", "col_2": "CP5T4C2", "col_3": "CP5T4C3", "col_4": "CP5T4C4"}
        }', 'Collection_Plan_5', ARRAY['CP5T1C1', 'CP5T4C1', 'CP5T4C2', 'CP5T4C3', 'CP5T4C4'],  'Collection_Plans: CP5.T1.T4 Description');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_2": {"col_1": "CP6T2C1", "col_2": "CP6T2C2"},
         "measurements_4": {"col_1": "CP6T4C1", "col_2": "CP6T4C2", "col_3": "CP6T4C3", "col_4": "CP6T4C4"}
        }', 'Collection_Plan_6', ARRAY['CP6T2C1', 'CP6T2C2', 'CP6T4C1', 'CP6T4C2', 'CP6T4C3', 'CP6T4C4'], 'Collection_Plans: CP6.T2.T4 Description');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_1": {"col_1": "CP7T1C1"},
         "measurements_2": {"col_1": "CP7T2C1", "col_2": "CP7T2C2"},
         "measurements_4": {"col_1": "CP7T4C1", "col_2": "CP7T4C2", "col_3": "CP7T4C3", "col_4": "CP7T4C4"}
        }', 'Collection_Plan_7', ARRAY['CP7T1C1', 'CP7T2C1', 'CP7T2C2', 'CP7T4C1', 'CP7T4C2', 'CP7T4C3', 'CP7T4C4'], 'Collection_Plans: CP7.T1.T2.T4 Description');

INSERT INTO collection_plans (svids_map, cp_name, svids, description)
VALUES('{
         "measurements_8": {"col_1": "CP8T8C1", "col_2": "CP8T8C2", "col_3": "CP8T8C3", "col_4": "CP8T8C4",
                     "col_5": "CP8T8C5", "col_2": "CP8T8C6", "col_3": "CP8T8C7", "col_4": "CP8T8C8"}
        }', 'Collection_Plan_8', ARRAY['CP8T8C1', 'CP8T8C2', 'CP8T8C3', 'CP8T8C4', 'CP8T8C5', 'CP8T8C6', 'CP8T8C7', 'CP8T8C8'], 'Collection_Plans: CP8.T8 Description');

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_1', 1, 2, 1);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_2', 3, 3, 2);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_3', 3, 3, 3);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_4', 3, 3, 4);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_5', 3, 3, 5);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_6', 3, 3, 6);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_7', 3, 3, 7);

INSERT INTO public.contexts (name, source_id, product_id, collection_plan_id)
VALUES('context_8', 3, 3, 8);

INSERT INTO public.measurements_1 (context_id, measurement_time, col_1)
VALUES(5, Now(), 1.51);

INSERT INTO public.measurements_2 (context_id, measurement_time, col_1, col_2)
VALUES(5, Now(), 2.51, 2.52);

INSERT INTO public.measurements_4 (context_id, measurement_time, col_1, col_2, col_3, col_4)
VALUES(5, Now(), 4.51, 4.52, 4.53, 4.54);

INSERT INTO public.measurements_8 (context_id, measurement_time, col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8)
VALUES(5, Now(), 8.51, 8.52, 8.53, 8.54, 8.55, 8.56, 8.57, 8.58);


-- Insert standard 2026 SPC initial data
INSERT INTO public.violation_types (rule_key, display_name, severity, marker_color, marker_symbol, requires_action, description)
VALUES 
('OOS_HARD', 'Out of Specification', 3, '#D90429', 'circle', TRUE, 'Value exceeded absolute engineering tolerances.'),
('OOS_WARNING', 'Out of Control', 3, '#FB8500', 'circle', TRUE, 'Value exceeded control limits.'),
('NELSON_1', 'One Point Beyond 3σ', 2, '#D90429', 'diamond', FALSE, 'One point is more than three standard deviations from the mean.'),
('NELSON_2_up', 'Mean Up Shift', 2, '#EF233C', 'triangle-up', TRUE, 'Nine (or more) points in a row on the same side of the mean.'),
('NELSON_2_down', 'Mean Down Shift', 2, '#EF233C', 'triangle-down', TRUE, 'Nine (or more) points in a row on the same side of the mean.'),
('NELSON_3_up', 'Up Trend Detected', 2, '#FB8500', 'triangle-up', FALSE, 'Six (or more) points in a row are continually increasing.'),
('NELSON_3_down', 'Down Trend Detected', 2, '#FB8500', 'triangle-down', FALSE, 'Six (or more) points in a row are continually decreasing.');

-- INSERT ML_MODELS TABLE
-- Source 1 models
INSERT INTO public.ml_models (source_name, recipe_name, version, file_path, model_type, framework, status, metrics, created_by, description)
VALUES ('source_1', 'Recipe_1', 'v1.0', 'ml/source_1/recipe_1/models/dif_anomaly_v1.0/', 'deep_isolation_forest', 'pytorch', 'production', '{"accuracy": 0.95, "precision": 0.92, "recall": 0.93}'::jsonb, 'system', 'DIF anomaly detection model for source_1 Recipe_1');

INSERT INTO public.ml_models (source_name, recipe_name, version, file_path, model_type, framework, status, metrics, created_by, description)
VALUES ('source_1', 'Recipe_2', 'v1.0', 'ml/source_1/recipe_2/models/dif_anomaly_v1.0/', 'deep_isolation_forest', 'pytorch', 'production', '{"accuracy": 0.94, "precision": 0.91, "recall": 0.92}'::jsonb, 'system', 'DIF anomaly detection model for source_1 Recipe_2');

-- Source 2 models
INSERT INTO public.ml_models (source_name, recipe_name, version, file_path, model_type, framework, status, metrics, created_by, description)
VALUES ('source_2', 'Recipe_1', 'v1.0', 'ml/source_2/recipe_1/models/dif_anomaly_v1.0/', 'deep_isolation_forest', 'pytorch', 'production', '{"accuracy": 0.93, "precision": 0.90, "recall": 0.91}'::jsonb, 'system', 'DIF anomaly detection model for source_2 Recipe_1');

INSERT INTO public.ml_models (source_name, recipe_name, version, file_path, model_type, framework, status, metrics, created_by, description)
VALUES ('source_2', 'Recipe_3', 'v1.0', 'ml/source_2/recipe_3/models/dif_anomaly_v1.0/', 'deep_isolation_forest', 'pytorch', 'production', '{"accuracy": 0.96, "precision": 0.94, "recall": 0.95}'::jsonb, 'system', 'DIF anomaly detection model for source_2 Recipe_3');

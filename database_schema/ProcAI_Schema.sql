--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET default_tablespace = '';
SET default_table_access_method = heap;

DROP TYPE IF EXISTS public.key_value_pair CASCADE;
DROP PROCEDURE IF EXISTS public."GetAll"(OUT sources refcursor);
DROP PROCEDURE IF EXISTS public."GetMeasurements"();
DROP FUNCTION IF EXISTS public.get_all(sourceid     INT);
DROP FUNCTION IF EXISTS public.get_active_model(p_source_name VARCHAR(100), p_recipe_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_model_by_id(p_model_id INT);
DROP FUNCTION IF EXISTS public.get_models_by_source_recipe(p_source_name VARCHAR(100), p_recipe_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_training_runs_by_model(p_model_id INT);
DROP FUNCTION IF EXISTS public.get_active_model_by_context(p_context_name VARCHAR(100));
DROP PROCEDURE IF EXISTS public.add_ml_model(IN p_source_name VARCHAR(100), IN p_recipe_name VARCHAR(100), 
                                              IN p_version VARCHAR(50), IN p_file_path TEXT, IN p_model_type VARCHAR(50),
                                              IN p_framework VARCHAR(50), IN p_metrics JSONB, IN p_created_by VARCHAR(100), 
                                              IN p_description TEXT, OUT p_model_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_training_run(IN p_model_id INT, IN p_hyperparameters JSONB, IN p_dataset_path TEXT,
                                                  IN p_duration_seconds INT, IN p_metrics JSONB, IN p_status VARCHAR(50),
                                                  IN p_created_by VARCHAR(100), OUT p_run_id INTEGER);
DROP PROCEDURE IF EXISTS public.deploy_model(IN p_model_id INT, IN p_environment VARCHAR(50), IN p_deployed_by VARCHAR(100), 
                                              OUT p_deployment_id INTEGER);
DROP PROCEDURE IF EXISTS public.activate_model(IN p_model_id INT, IN p_deployed_by VARCHAR(100));
DROP PROCEDURE IF EXISTS public.setx(IN in_param VARCHAR(100), OUT out_param INTEGER);
DROP FUNCTION IF EXISTS public.get_all_sources();
DROP FUNCTION IF EXISTS public.all_source_attributes();
DROP FUNCTION IF EXISTS public.get_source_by_id(source_id INT);
DROP FUNCTION IF EXISTS public.get_source_by_name(source_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_source_by_context(context_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_source_recipe_by_context(context_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_all_products();
DROP FUNCTION IF EXISTS public.all_product_attributes();
DROP FUNCTION IF EXISTS public.get_product_by_id(product_id INT);
DROP FUNCTION IF EXISTS public.get_all_contexts();
DROP FUNCTION IF EXISTS public.get_all_contexts_detail();
DROP FUNCTION IF EXISTS public.get_context_by_id(context_id INT);
DROP FUNCTION IF EXISTS public.get_context_detail_by_id(cntxt_id INT);
DROP FUNCTION IF EXISTS public.get_context_detail_by_name(context_name VARCHAR(100));
DROP PROCEDURE IF EXISTS public.add_source(IN s_name VARCHAR(100), IN s_attributes jsonb, IN s_description VARCHAR(1000), OUT s_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_product(In product_name VARCHAR(100), IN attributes jsonb, IN descrip VARCHAR(1000), OUT product_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_collection_plan(IN svids_map jsonb, IN cpname VARCHAR(100),
                                                    IN descrip VARCHAR(1000), OUT collection_plan_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_collection_planV2(IN svids TEXT[], IN cpname VARCHAR(100),
                                                    IN descrip VARCHAR(1000), OUT collection_plan_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_context(IN context_name VARCHAR(100), IN sourceId INTEGER,
                                            IN productId INTEGER, IN collection_planId INTEGER, OUT context_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_context(IN context_name VARCHAR(100), IN sourceId VARCHAR(100),
                                            IN productId VARCHAR(100), IN collection_planId VARCHAR(100), OUT context_id INTEGER);
DROP PROCEDURE IF EXISTS public.add_measurements(IN context_name VARCHAR(100), IN measurements public.key_value_pair[], OUT success BOOLEAN);
DROP PROCEDURE IF EXISTS public.add_measurements(IN context_name VARCHAR(100), IN measurements public.key_value_pair[], IN measurement_time TIMESTAMP WITH TIME ZONE, OUT success BOOLEAN);
DROP PROCEDURE IF EXISTS public.add_limit_settings(IN source_name VARCHAR(100), IN recipe_name VARCHAR(100), IN vids JSONB, OUT limit_settings_id INTEGER);
DROP PROCEDURE IF EXISTS public.update_limit_settings(IN source_name VARCHAR(100), IN recipe_name VARCHAR(100), IN vids JSONB);
DROP FUNCTION IF EXISTS public.get_limit_settings(p_source_name VARCHAR(100), p_recipe_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_violation_type(p_rule_key VARCHAR(50));
DROP PROCEDURE IF EXISTS public.add_event(IN context_name VARCHAR(100), IN svids JSON, IN rule_key VARCHAR(50), IN ack BOOLEAN, IN comments VARCHAR(1000), OUT event_id INTEGER);
DROP FUNCTION IF EXISTS public.get_all_collection_plans();
DROP FUNCTION IF EXISTS public.get_collection_plan_by_name(cp_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_collection_plan_by_id(collection_plan_id INTEGER);
-- fget_collection_plan_by_id as functions is more appropriate to return a value. 
-- already have a procedure which does the same thing. will remove procedure ASAP
DROP FUNCTION IF EXISTS public.fget_collection_plan_id(collection_plan_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_reports_by_tags(TEXT[]);
DROP FUNCTION IF EXISTS public.add_tag_to_report(TEXT, TEXT);
DROP PROCEDURE IF EXISTS public.get_collection_plan_id(IN  collection_plan_name VARCHAR(100), OUT collection_plan_id INTEGER);
DROP FUNCTION IF EXISTS public.get_measurement(svid_name   VARCHAR(100), collection_plan_name VARCHAR(100), cnxt jsonb);
DROP FUNCTION IF EXISTS public.get_measurementv2(svid_name   VARCHAR(100), context_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_measurement_adv(svid_name   VARCHAR(100), searchFields jsonb);
DROP FUNCTION IF EXISTS public.get_measurement_adv(svid_name   VARCHAR(100), searchFields jsonb, start_datetime TIMESTAMP WITH TIME ZONE, end_datetime TIMESTAMP WITH TIME ZONE);
DROP FUNCTION IF EXISTS public.get_svid_column(svid_name VARCHAR(100), collection_plan_name VARCHAR(100));
DROP FUNCTION IF EXISTS public.get_where_clause(attributeType VARCHAR(100), cntxt   JSONB);
DROP FUNCTION IF EXISTS lower_array(input_array text[]);
DROP PROCEDURE IF EXISTS public.add_report(
    INTEGER,
    TEXT,
    JSONB,
    TEXT[],
    TEXT
);
DROP FUNCTION IF EXISTS public.get_reports_by_tag(tag_name TEXT);
DROP PROCEDURE IF EXISTS public.remove_report_by_name(TEXT);

DROP TABLE IF EXISTS public.ml_model_deployments;
DROP TABLE IF EXISTS public.ml_training_runs;
DROP TABLE IF EXISTS public.ml_models;
DROP TABLE IF EXISTS public.measurements_1;
DROP TABLE IF EXISTS public.measurements_2;
DROP TABLE IF EXISTS public.measurements_4;
DROP TABLE IF EXISTS public.measurements_8;
DROP TABLE IF EXISTS public.measurements_16;
DROP TABLE IF EXISTS public.measurements_32;
DROP TABLE IF EXISTS public.measurements_64;
DROP TABLE IF EXISTS public.measurements_128;
DROP TABLE IF EXISTS public.alarm_contributions;
DROP TABLE IF EXISTS public.limit_alarm_detail;
DROP TABLE IF EXISTS public.iforest_alarm_detail;
DROP TABLE IF EXISTS public.pca_alarm_detail;
DROP TABLE IF EXISTS public.alarms;
DROP TABLE IF EXISTS public.limit_settings;
DROP TABLE IF EXISTS public.contexts;
DROP TABLE IF EXISTS public.products;
DROP TABLE IF EXISTS public.sources;
DROP TABLE IF EXISTS public.collection_plans;
DROP TABLE IF EXISTS public.reports;
DROP TABLE IF EXISTS public.violation_types;
DROP TABLE IF EXISTS public.events;

DROP INDEX IF EXISTS idx_unique_reports_name_ci;
DROP INDEX IF EXISTS idx_ml_models_source_recipe_step;
DROP INDEX IF EXISTS idx_ml_models_status;
DROP INDEX IF EXISTS idx_ml_deployments_active;

DROP INDEX IF EXISTS unique_sources_name_lower_idx;
DROP INDEX IF EXISTS unique_products_name_lower_idx;
DROP INDEX IF EXISTS unique_violation_rule_key_lower_idx;
DROP INDEX IF EXISTS idx_violation_rule_key;

CREATE OR REPLACE FUNCTION public.lower_array(input_array text[]) RETURNS text[] AS $$
    SELECT ARRAY_AGG(LOWER(x) ORDER BY LOWER(x)) 
    FROM UNNEST(input_array) AS x;
$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE TABLE public.products (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    attributes jsonb,
    description character varying(100),
    CONSTRAINT unique_product_name UNIQUE (name),
    CONSTRAINT unique_products_attributes UNIQUE (attributes)
);
CREATE UNIQUE INDEX unique_products_name_lower_idx ON public.products (LOWER(name));
ALTER TABLE public.products OWNER TO postgres;

CREATE TABLE public.sources (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    attributes jsonb NOT NULL,
    description character varying(1000) NOT NULL,
    CONSTRAINT unique_sources_name UNIQUE (name),
    CONSTRAINT unique_sources_attributes UNIQUE (attributes)
);
CREATE UNIQUE INDEX unique_sources_name_lower_idx ON public.sources (LOWER(name));
ALTER TABLE public.sources OWNER TO postgres;

CREATE TABLE public.collection_plans (
    id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cp_name character varying(100) NOT NULL,
    svids   VARCHAR(100)[] NOT NULL,
    svids_map jsonb NOT NULL,
    description character varying(1000) NOT NULL,
    CONSTRAINT unique_collection_plans_svids UNIQUE (svids),
    CONSTRAINT unique_collection_plans_cp_name UNIQUE (cp_name)
);
ALTER TABLE public.collection_plans OWNER TO postgres;

CREATE TABLE public.contexts (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    source_id           INT REFERENCES public.sources(id),
    product_id          INT REFERENCES public.products(id),
    collection_plan_id  INT REFERENCES public.collection_plans(id),
    CONSTRAINT unique_contexts_source_product_collection_plan UNIQUE (source_id, product_id, collection_plan_id),
    CONSTRAINT unique_context_name UNIQUE (name)
);
ALTER TABLE public.contexts OWNER TO postgres;

CREATE TABLE public.measurements_1 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real
);
ALTER TABLE public.measurements_1 OWNER TO postgres;

CREATE TABLE public.measurements_2 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real
);
ALTER TABLE public.measurements_2 OWNER TO postgres;

CREATE TABLE public.measurements_4 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real,
    col_3 real,
    col_4 real
);
ALTER TABLE public.measurements_4 OWNER TO postgres;

CREATE TABLE public.measurements_8 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real,
    col_3 real,
    col_4 real,
    col_5 real,
    col_6 real,
    col_7 real,
    col_8 real
);
ALTER TABLE public.measurements_8 OWNER TO postgres;

CREATE TABLE public.measurements_16 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real,
    col_3 real,
    col_4 real,
    col_5 real,
    col_6 real,
    col_7 real,
    col_8 real,
    col_9 real,
    col_10 real,
    col_11 real,
    col_12 real,
    col_13 real,
    col_14 real,
    col_15 real,
    col_16 real
);
ALTER TABLE public.measurements_16 OWNER TO postgres;

CREATE TABLE public.measurements_32 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real,
    col_3 real,
    col_4 real,
    col_5 real,
    col_6 real,
    col_7 real,
    col_8 real,
    col_9 real,
    col_10 real,
    col_11 real,
    col_12 real,
    col_13 real,
    col_14 real,
    col_15 real,
    col_16 real,
    col_17 real,
    col_18 real,
    col_19 real,
    col_20 real,
    col_21 real,
    col_22 real,
    col_23 real,
    col_24 real,
    col_25 real,
    col_26 real,
    col_27 real,
    col_28 real,
    col_29 real,
    col_30 real,
    col_31 real,
    col_32 real
);
ALTER TABLE public.measurements_32 OWNER TO postgres;

CREATE TABLE public.measurements_64 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real,
    col_3 real,
    col_4 real,
    col_5 real,
    col_6 real,
    col_7 real,
    col_8 real,
    col_9 real,
    col_10 real,
    col_11 real,
    col_12 real,
    col_13 real,
    col_14 real,
    col_15 real,
    col_16 real,
    col_17 real,
    col_18 real,
    col_19 real,
    col_20 real,
    col_21 real,
    col_22 real,
    col_23 real,
    col_24 real,
    col_25 real,
    col_26 real,
    col_27 real,
    col_28 real,
    col_29 real,
    col_30 real,
    col_31 real,
    col_32 real,
    col_33 real,
    col_34 real,
    col_35 real,
    col_36 real,
    col_37 real,
    col_38 real,
    col_39 real,
    col_40 real,
    col_41 real,
    col_42 real,
    col_43 real,
    col_44 real,
    col_45 real,
    col_46 real,
    col_47 real,
    col_48 real,
    col_49 real,
    col_50 real,
    col_51 real,
    col_52 real,
    col_53 real,
    col_54 real,
    col_55 real,
    col_56 real,
    col_57 real,
    col_58 real,
    col_59 real,
    col_60 real,
    col_61 real,
    col_62 real,
    col_63 real,
    col_64 real
);
ALTER TABLE public.measurements_64 OWNER TO postgres;

CREATE TABLE public.measurements_128 (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id     INT REFERENCES public.contexts(id),
    measurement_time timestamp with time zone,
    col_1 real,
    col_2 real,
    col_3 real,
    col_4 real,
    col_5 real,
    col_6 real,
    col_7 real,
    col_8 real,
    col_9 real,
    col_10 real,
    col_11 real,
    col_12 real,
    col_13 real,
    col_14 real,
    col_15 real,
    col_16 real,
    col_17 real,
    col_18 real,
    col_19 real,
    col_20 real,
    col_21 real,
    col_22 real,
    col_23 real,
    col_24 real,
    col_25 real,
    col_26 real,
    col_27 real,
    col_28 real,
    col_29 real,
    col_30 real,
    col_31 real,
    col_32 real,
    col_33 real,
    col_34 real,
    col_35 real,
    col_36 real,
    col_37 real,
    col_38 real,
    col_39 real,
    col_40 real,
    col_41 real,
    col_42 real,
    col_43 real,
    col_44 real,
    col_45 real,
    col_46 real,
    col_47 real,
    col_48 real,
    col_49 real,
    col_50 real,
    col_51 real,
    col_52 real,
    col_53 real,
    col_54 real,
    col_55 real,
    col_56 real,
    col_57 real,
    col_58 real,
    col_59 real,
    col_60 real,
    col_61 real,
    col_62 real,
    col_63 real,
    col_64 real,
    col_65 real,
    col_66 real,
    col_67 real,
    col_68 real,
    col_69 real,
    col_70 real,
    col_71 real,
    col_72 real,
    col_73 real,
    col_74 real,
    col_75 real,
    col_76 real,
    col_77 real,
    col_78 real,
    col_79 real,
    col_80 real,
    col_81 real,
    col_82 real,
    col_83 real,
    col_84 real,
    col_85 real,
    col_86 real,
    col_87 real,
    col_88 real,
    col_89 real,
    col_90 real,
    col_91 real,
    col_92 real,
    col_93 real,
    col_94 real,
    col_95 real,
    col_96 real,
    col_97 real,
    col_98 real,
    col_99 real,
    col_100 real,
    col_101 real,
    col_102 real,
    col_103 real,
    col_104 real,
    col_105 real,
    col_106 real,
    col_107 real,
    col_108 real,
    col_109 real,
    col_110 real,
    col_111 real,
    col_112 real,
    col_113 real,
    col_114 real,
    col_115 real,
    col_116 real,
    col_117 real,
    col_118 real,
    col_119 real,
    col_120 real,
    col_121 real,
    col_122 real,
    col_123 real,
    col_124 real,
    col_125 real,
    col_126 real,
    col_127 real,
    col_128 real
);
ALTER TABLE public.measurements_128 OWNER TO postgres;

CREATE TABLE public.reports (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    attributes JSONB NOT NULL,
    tags TEXT[],
    description TEXT
);
-- 1. Global Case-Insensitive Unique Index for 'name'
CREATE UNIQUE INDEX idx_unique_reports_name_ci 
ON public.reports (LOWER(name));

CREATE TABLE public.limit_settings (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL,
    recipe_name VARCHAR(100) NOT NULL,
    vids JSONB NOT NULL
);
CREATE UNIQUE INDEX idx_limit_settings_source_recipe_ci
ON public.limit_settings (LOWER(source_name), LOWER(recipe_name));
ALTER TABLE public.limit_settings OWNER TO postgres;

CREATE TABLE public.events (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_name VARCHAR(100),
    svids JSON,
    rule_key VARCHAR(50),
    ack BOOLEAN,
    comments VARCHAR(1000)
);
ALTER TABLE public.events OWNER TO postgres;

-- ML MODEL TRACKING TABLES

CREATE TABLE public.ml_models (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL,
    recipe_name VARCHAR(100) NOT NULL,
    version VARCHAR(50) NOT NULL,
    file_path TEXT NOT NULL,
    model_type VARCHAR(50) NOT NULL, -- 'classification', 'regression', 'anomaly_detection', etc.
    framework VARCHAR(50) NOT NULL, -- 'pytorch', 'sklearn', 'tensorflow', etc.
    status VARCHAR(20) NOT NULL DEFAULT 'development', -- 'development', 'staging', 'production', 'archived'
    metrics JSONB, -- accuracy, precision, recall, f1, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NOT NULL,
    description TEXT,
    CONSTRAINT unique_model_version UNIQUE (source_name, recipe_name, version, model_type)
);
ALTER TABLE public.ml_models OWNER TO postgres;

CREATE INDEX idx_ml_models_source_recipe ON public.ml_models (source_name, recipe_name);
CREATE INDEX idx_ml_models_status ON public.ml_models (status);

CREATE TABLE public.ml_training_runs (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_id INT REFERENCES public.ml_models(id) ON DELETE CASCADE,
    hyperparameters JSONB, -- learning_rate, batch_size, epochs, etc.
    dataset_path TEXT,
    duration_seconds INT,
    metrics JSONB, -- training metrics per epoch/iteration
    status VARCHAR(50) NOT NULL DEFAULT 'running', -- 'running', 'completed', 'failed'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100) NOT NULL
);
ALTER TABLE public.ml_training_runs OWNER TO postgres;

CREATE TABLE public.ml_model_deployments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_id INT REFERENCES public.ml_models(id) ON DELETE CASCADE,
    environment VARCHAR(50) NOT NULL, -- 'development', 'staging', 'production'
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    deployed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deployed_by VARCHAR(100) NOT NULL,
    deactivated_at TIMESTAMP WITH TIME ZONE,
    deactivated_by VARCHAR(100)
);
ALTER TABLE public.ml_model_deployments OWNER TO postgres;

CREATE INDEX idx_ml_deployments_active ON public.ml_model_deployments (model_id, is_active) WHERE is_active = TRUE;

-- FUNCTIONS AND PROCEDURES.

CREATE OR REPLACE PROCEDURE public."GetAll"(OUT sources refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
    OPEN sources FOR
    select * from source;
END;
$$;
ALTER PROCEDURE public."GetAll"(OUT sources refcursor) OWNER TO postgres;

CREATE OR REPLACE PROCEDURE public."GetMeasurements"()
    LANGUAGE plpgsql
    AS $$
BEGIN
    select * from table_1;
END;
$$;
ALTER PROCEDURE public."GetMeasurements"() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_all(sourceid     INT) RETURNS SETOF public.sources
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM sources where sources.id > sourceId ;
END;
$$;
ALTER FUNCTION public.get_all(sourceid     INT) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_measurements(col_name character varying, table_name character varying, cnxt_id     INT) RETURNS TABLE(id     INT, context_id     INT, measurement_time timestamp with time zone, svid real)
    LANGUAGE plpgsql
    AS $$
DECLARE
    dynamic_query TEXT;
BEGIN
    --RETURN QUERY SELECT context_id,  FROM sources where sources.id > context_id ;
    dynamic_query := format('SELECT id, context_id, measurement_time, %s AS svid FROM %s WHERE context_id = %s',
                            col_name, table_name, cnxt_id);
    RAISE NOTICE 'Formatted: %', dynamic_query;
    RETURN QUERY EXECUTE dynamic_query;
END;
$$;
ALTER FUNCTION public.get_measurements(col_name character varying, table_name character varying, cnxt_id     INT) OWNER TO postgres;


CREATE OR REPLACE PROCEDURE public.setx(
    IN  in_param VARCHAR(100),
    OUT out_param INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    out_param := 1234;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_all_sources()
RETURNS SETOF public.sources
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM sources;
END;
$$;
ALTER FUNCTION public.get_all_sources() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.all_source_attributes()
RETURNS TABLE(
    attributes TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT k.key AS attributes
    FROM public.sources s
    CROSS JOIN LATERAL jsonb_object_keys(COALESCE(s.attributes, '{}'::jsonb)) AS k(key)
    ORDER BY k.key;
END;
$$;
ALTER FUNCTION public.all_source_attributes() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_all_collection_plans()
RETURNS SETOF public.collection_plans
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM collection_plans;
END;
$$;
ALTER FUNCTION public.get_all_collection_plans() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_collection_plan_by_name(collection_plan_name VARCHAR(100))
RETURNS SETOF public.collection_plans
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * 
        FROM collection_plans
        WHERE UPPER(cp_name) = UPPER(collection_plan_name);
END;
$$;
ALTER FUNCTION public.get_collection_plan_by_name(cp_name VARCHAR(100)) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_collection_plan_by_id(collection_plan_id INT)
RETURNS SETOF public.collection_plans
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * 
        FROM collection_plans
        WHERE collection_plan_id = id;
END;
$$;
ALTER FUNCTION public.get_collection_plan_by_id(collection_plan_id INT) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fget_collection_plan_id(collection_plan_name VARCHAR(100))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    collection_plan_id INTEGER;
BEGIN
    collection_plan_id := -1;

    SELECT id INTO collection_plan_id
        FROM collection_plans
        WHERE LOWER(collection_plans.cp_name) = LOWER(collection_plan_name);

        RETURN collection_plan_id;
END;
$$;
ALTER FUNCTION public.fget_collection_plan_id(collection_plan_name VARCHAR(100)) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_source_by_id(source_id INT)
RETURNS SETOF public.sources
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM sources WHERE id = source_id;
END;
$$;
ALTER FUNCTION public.get_source_by_id(source_id INT) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_product_by_id(product_id INT)
RETURNS SETOF public.products
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM products WHERE id = product_id;
END;
$$;
ALTER FUNCTION public.get_product_by_id(product_id INT) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_source_by_name(source_name VARCHAR(100))
RETURNS SETOF public.sources
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM sources;
END;
$$;
ALTER FUNCTION public.get_source_by_name(source_name VARCHAR(100)) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_source_by_context(context_name VARCHAR(100))
RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS $$
DECLARE
    source_name VARCHAR(100);
BEGIN
    SELECT s.name INTO source_name
    FROM public.sources s
    INNER JOIN public.contexts c ON c.source_id = s.id
    WHERE LOWER(c.name) = LOWER(context_name);
    
    RETURN source_name;
END;
$$;
ALTER FUNCTION public.get_source_by_context(context_name VARCHAR(100)) OWNER TO postgres;

-- Get source and recipe names from context
-- Returns (source_name, recipe_name) for a given context
CREATE OR REPLACE FUNCTION public.get_source_recipe_by_context(
    p_context_name VARCHAR(100)
)
RETURNS TABLE (
    source_name VARCHAR(100),
    recipe_name VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.name as source_name,
        COALESCE(
            (p.attributes->>'Recipe')::varchar,
            (p.attributes->>'recipe')::varchar
        ) as recipe_name
    FROM public.contexts c
    INNER JOIN public.sources s ON c.source_id = s.id
    INNER JOIN public.products p ON c.product_id = p.id
    WHERE LOWER(c.name) = LOWER(p_context_name);
END;
$$;
ALTER FUNCTION public.get_source_recipe_by_context(VARCHAR(100)) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_all_products()
RETURNS SETOF public.products
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM products;
END;
$$;
ALTER FUNCTION public.get_all_products() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.all_product_attributes()
RETURNS TABLE(
    attributes TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT k.key AS attributes
    FROM public.products p
    CROSS JOIN LATERAL jsonb_object_keys(COALESCE(p.attributes, '{}'::jsonb)) AS k(key)
    ORDER BY k.key;
END;
$$;
ALTER FUNCTION public.all_product_attributes() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_all_contexts()
RETURNS SETOF public.contexts
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM contexts;
END;
$$;
ALTER FUNCTION public.get_all_contexts() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_all_contexts_detail()
RETURNS TABLE(
    context_id              INT,
    name                    VARCHAR(100),
    collection_plan_name    VARCHAR(100),
    svids_map                   JSONB,
    product_attributes      JSONB,
    source_attributes       JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.id context_id, c.name name, cp.cp_name collection_plan_name, cp.svids_map svids_map, p.attributes product_attributes, s.attributes source_attributes 
        FROM contexts AS c
        INNER JOIN products         AS p  ON p.id                 = c.product_id
        INNER JOIN sources          AS s  ON c.source_id          = s.id
        INNER JOIN collection_plans AS cp ON c.collection_plan_id = cp.id;
END;
$$;
ALTER FUNCTION public.get_all_contexts_detail() OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_context_detail_by_id(cntxt_id INT)
RETURNS TABLE(
    context_id              INT,
    name                    VARCHAR(100),
    collection_plan_name    VARCHAR(100),
    svids_map                   JSONB,
    product_attributes      JSONB,
    source_attributes       JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.id context_id, c.name name, cp.cp_name collection_plan_name, cp.svids_map svids_map, p.attributes product_attributes, s.attributes source_attributes 
        FROM contexts AS c
        INNER JOIN products         AS p  ON p.id                 = c.product_id
        INNER JOIN sources          AS s  ON c.source_id          = s.id
        INNER JOIN collection_plans AS cp ON c.collection_plan_id = cp.id
        WHERE c.id = cntxt_id;
END;
$$;
ALTER FUNCTION public.get_context_detail_by_id(ntxt_id INT) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_context_detail_by_name(context_name VARCHAR(100))
RETURNS TABLE(
    context_id              INT,
    name                    VARCHAR(100),
    collection_plan_name    VARCHAR(100),
    svids_map                   JSONB,
    product_attributes      JSONB,
    source_attributes       JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.id context_id, c.name name, cp.cp_name collection_plan_name, cp.svids_map svids_map, p.attributes product_attributes, s.attributes source_attributes 
        FROM contexts AS c
        INNER JOIN products         AS p  ON p.id                 = c.product_id
        INNER JOIN sources          AS s  ON c.source_id          = s.id
        INNER JOIN collection_plans AS cp ON c.collection_plan_id = cp.id
        WHERE c.name = context_name;
END;
$$;
ALTER FUNCTION public.get_context_detail_by_name(context_name VARCHAR(100)) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_context_by_id(context_id INT)
RETURNS SETOF public.contexts
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM contexts
        WHERE id = context_id;
END;
$$;
ALTER FUNCTION public.get_context_by_id(context_id INT) OWNER TO postgres;

-- INSERT PROCEDURES
CREATE OR REPLACE PROCEDURE public.add_source(
    IN s_name VARCHAR(100),
    IN s_attributes jsonb,
    IN s_description VARCHAR(1000),
    OUT s_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
temp_name VARCHAR(100);
normalized_attributes jsonb;
BEGIN

    normalized_attributes := COALESCE(
        (
            SELECT jsonb_object_agg(LOWER(key), value)
            FROM jsonb_each(COALESCE(s_attributes, '{}'::jsonb))
        ),
        '{}'::jsonb
    );

    -- Throw an exception if the source attributes already exists but with different name
    SELECT s.id, s.name INTO s_id, temp_name FROM sources AS s
    WHERE
        attributes = normalized_attributes
        AND LOWER(name) <> LOWER(s_name);

    IF s_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same source attributes with a different source name ''%'' already exists.', temp_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Same source with more than one name is not allowed.Provide a different source name.';
    END IF;

    INSERT INTO sources(name, attributes, description)
    VALUES(s_name, normalized_attributes, s_description)
    ON CONFLICT ON CONSTRAINT unique_sources_attributes
    DO UPDATE SET
        description = sources.description -- source already exist. Do nothing but still get the id.
    RETURNING id INTO s_id;
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_product(
    IN  p_name          VARCHAR(100),
    IN  p_attributes    jsonb,
    IN  p_descrip       VARCHAR(1000),
    OUT p_id            INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
temp_name VARCHAR(100);
normalized_attributes jsonb;
BEGIN
    normalized_attributes := COALESCE(
        (
            SELECT jsonb_object_agg(LOWER(key), value)
            FROM jsonb_each(COALESCE(p_attributes, '{}'::jsonb))
        ),
        '{}'::jsonb
    );

    -- Throw an exception if the same attributes already exist under a different name.
    SELECT p.id, p.name INTO p_id, temp_name FROM products AS p
    WHERE
        attributes = normalized_attributes
        AND LOWER(name) <> LOWER(p_name);

    IF p_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same product attributes with a different product name ''%'' already exists.', temp_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Same product with more than one name is not allowed.Provide a different product name.';
    END IF;

    -- Throw an exception if the same name already exists with different attributes.
    -- This check is explicit so that concurrent inserts (same name, same attrs) are
    -- handled safely by ON CONFLICT DO NOTHING + the final SELECT below.
    SELECT p.id INTO p_id FROM products AS p
    WHERE
        LOWER(p.name) = LOWER(p_name)
        AND attributes <> normalized_attributes;

    IF p_id IS NOT NULL THEN
        RAISE EXCEPTION 'Product with name ''%'' already exists with different attributes.', p_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Use the existing product or choose a different name.';
    END IF;

    -- ON CONFLICT DO NOTHING handles both unique_product_name and
    -- unique_products_attributes constraints, making concurrent inserts with
    -- the same name+attributes idempotent (exactly one row is created).
    INSERT INTO products(name, attributes, description)
    VALUES(p_name, normalized_attributes, p_descrip)
    ON CONFLICT DO NOTHING;

    -- Retrieve the id whether this call created the row or a concurrent call did.
    SELECT id INTO p_id FROM products WHERE LOWER(name) = LOWER(p_name);

END;
$$;


CREATE OR REPLACE PROCEDURE public.add_collection_plan(
    IN svids_map jsonb,
    IN cpname VARCHAR(100),
    IN descrip VARCHAR(1000),
    OUT collection_plan_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    collection_plan_id := -1;

    INSERT INTO collection_plans(svids_map, cp_name, description)
    VALUES(svids_map, cpname, descrip)
    ON CONFLICT ON CONSTRAINT unique_collection_plans_svids
    DO UPDATE SET
        description = descrip,
        cp_name     = cpname
    RETURNING id INTO collection_plan_id;

END;
$$;

CREATE OR REPLACE PROCEDURE public.add_collection_planV2(
    IN svids TEXT[],
    IN cpname VARCHAR(100),
    IN descrip VARCHAR(1000),
    OUT collection_plan_id INTEGER
)
LANGUAGE plpgsql
AS $$

DECLARE
    currentIndex INTEGER DEFAULT 0;
    svids_json JSONB := '{}'::jsonb;

    sorted_svids TEXT[];
    temp_colPlnName TEXT;
    temp_svids TEXT[];
    chunk_size INTEGER;
    chunk_start INTEGER;
    col_idx INTEGER;
    col_map JSONB;
BEGIN
    collection_plan_id := -1;
    currentIndex := array_length(svids, 1);

    -- If the collection plan already exists then return the collection plan id.
    -- First sort and change to lower case of incomming svids
    SELECT ARRAY_AGG(LOWER(v) ORDER BY LOWER(v) ASC) INTO sorted_svids
    FROM UNNEST(svids) as v;

    SELECT cp.id, cp.svids INTO collection_plan_id, temp_svids FROM collection_plans AS cp 
    WHERE cp.cp_name = cpname
    AND lower_array(cp.svids) = sorted_svids;

    IF collection_plan_id IS NOT NULL THEN
        RETURN; -- Already have the collection Plan.
    END IF;

    -- If collection plan with a different name already exists then throw an exception.
    SELECT cp.id, cp.cp_name INTO collection_plan_id, temp_colPlnName FROM collection_plans AS cp 
    WHERE LOWER(cp.cp_name) = LOWER(cpname)
    AND lower_array(cp.svids) <> sorted_svids;

    IF collection_plan_id IS NOT NULL THEN
        RAISE EXCEPTION 'Collection Plan Name ''%'' Already Exists', cpname
        USING
            ERRCODE = 'P0001',
            HINT = 'Use A Different Collection Plan Name';
    END IF;

    -- If svids with a different collection plan name already exists then throw an exception.
    SELECT cp.id, cp.cp_name INTO collection_plan_id, temp_colPlnName FROM collection_plans AS cp 
    WHERE LOWER(cp.cp_name) <> LOWER(cpname)
    AND lower_array(cp.svids) = sorted_svids;

    IF collection_plan_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same Collection Plan with a different name ''%'' Exists', temp_colPlnName
        USING
            ERRCODE = 'P0001',
            HINT = '''' || temp_colPlnName || '''can be used instead';
    END IF;

    FOREACH chunk_size IN ARRAY ARRAY[128, 64, 32, 16, 8, 4, 2, 1]
    LOOP
        IF currentIndex >= chunk_size THEN
            chunk_start := currentIndex - chunk_size + 1;
            col_map := '{}'::jsonb;

            FOR col_idx IN 1..chunk_size
            LOOP
                col_map := col_map || jsonb_build_object(
                    format('Col_%s', col_idx),
                    sorted_svids[chunk_start + col_idx - 1]
                );
            END LOOP;

            svids_json := svids_json || jsonb_build_object(
                format('measurements_%s', chunk_size),
                col_map
            );

            currentIndex := currentIndex - chunk_size;
        END IF;
    END LOOP;

    RAISE INFO '%', svids_json::TEXT;

    INSERT INTO collection_plans(svids, svids_map, cp_name, description)
    VALUES(svids, svids_json, cpname, descrip)
    ON CONFLICT DO NOTHING;

    SELECT id INTO collection_plan_id
    FROM collection_plans cp
    WHERE 
        cp.cp_name = cpname OR cp.svids_map = svids_json;

END;
$$;

CREATE OR REPLACE PROCEDURE public.add_context(
    IN context_name VARCHAR(100),
    IN sourceId INTEGER,
    IN productId INTEGER,
    IN collection_planId INTEGER,
    OUT context_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
temp_name VARCHAR(100);
BEGIN
    context_id := -1;
    --Throw an exception if the (source_id, product_id, collection_plan_id) already exists but with different name
    SELECT c.id, c.name INTO context_id, temp_name FROM contexts AS c
    WHERE
        c.source_id = sourceId
        AND c.product_id = productId
        AND c.collection_plan_id = collection_planId
        AND LOWER(name) <> LOWER(context_name);

    IF context_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same context (source_id=%, product_id=%, collection_plan_id=%) with a different name ''%'' already exists.',
                        sourceId, productId, collection_planId, temp_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Same context with more than one name is not allowed.Provide a different context name.';
    END IF;

    --Throw an exception if the same context name exist for a different context (source_id, product_id, collection_plan_id) 
    SELECT c.id, c.name INTO context_id, temp_name FROM contexts AS c
    WHERE
        LOWER(name) = LOWER(context_name)
        AND (
                c.product_id <> productId
                OR c.collection_plan_id <> collection_planId
                OR c.source_id <> sourceId
                );

    IF context_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same context name ''%'' exists for a different context (source_id=%, product_id=%, collection_plan_id=%).',
                            temp_name, sourceId, productId, collection_planId
        USING
            ERRCODE = 'P0001',
            HINT = 'Context name is required to be unique.';
    END IF;

    INSERT INTO contexts(name, source_id, product_id, collection_plan_id)
    VALUES(context_name, sourceId, productId, collection_planId)
    ON CONFLICT ON CONSTRAINT unique_contexts_source_product_collection_plan
    DO UPDATE SET
        name      = contexts.name -- its updating to itself.
    RETURNING id INTO context_id;

END;
$$;

CREATE OR REPLACE PROCEDURE public.add_context(
    IN  context_name        VARCHAR(100),
    IN  sourceName          VARCHAR(100),
    IN  productName         VARCHAR(100),
    IN  collection_planName VARCHAR(100),
    OUT context_id          INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    temp_sourceId           INTEGER;
    temp_productId          INTEGER;
    temp_collection_planId  INTEGER;
    temp_name               VARCHAR(100);
BEGIN
    SELECT id INTO temp_sourceId FROM sources WHERE name = sourceName;
    IF temp_sourceId IS NULL THEN
        RAISE EXCEPTION 'Source with name ''%'' does not exist', sourceName
        USING
            ERRCODE = 'P0001',
            HINT = 'Please provide a source name which exists in the db. TBD: provide a list of';
    END IF;

    SELECT id INTO temp_productId FROM products WHERE name = productName;
    IF temp_productId IS NULL THEN
        RAISE EXCEPTION 'Product with name ''%'' does not exist', productName
        USING
            ERRCODE = 'P0001',
            HINT = 'Please provide a Product name which exists in the db. TBD: provide a list of';
    END IF;

    SELECT id INTO temp_collection_planId FROM collection_plans WHERE cp_name = collection_planName;
    IF temp_collection_planId IS NULL THEN
        RAISE EXCEPTION 'Collection plan with name ''%'' does not exist', collection_planName
        USING
            ERRCODE = 'P0001',
            HINT = 'Please provide a collection plan name which exists in the db. TBD: provide a list of';
    END IF;

    --Throw an exception if the (source_id, product_id, collection_plan_id) already exists but with different name
    SELECT c.id, c.name INTO context_id, temp_name FROM contexts AS c
    WHERE
        c.source_id = temp_sourceId
        AND c.product_id = temp_productId
        AND c.collection_plan_id = temp_collection_planId
        AND LOWER(name) <> LOWER(context_name);

    IF context_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same context (source_id, product_id, collection_plan_id) with a different name ''%'' already exists.', temp_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Same context with more than one name is not allowed.Provide a different context name.';
    END IF;

    --Throw an exception if the same context name exist for a different context (source_id, product_id, collection_plan_id) 
    SELECT c.id, c.name INTO context_id, temp_name FROM contexts AS c
    WHERE
        LOWER(name) = LOWER(context_name)
        AND (
                c.product_id <> temp_productId
                OR c.collection_plan_id <> temp_collection_planId
                OR c.source_id <> temp_sourceId
                );

    IF context_id IS NOT NULL THEN
        RAISE EXCEPTION 'Same context name ''%'' exists for a different context.',temp_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Context name is required to be unique.';
    END IF;

    INSERT INTO contexts(name, source_id, product_id, collection_plan_id)
    VALUES(context_name, temp_sourceId, temp_productId, temp_collection_planId)
    ON CONFLICT ON CONSTRAINT unique_contexts_source_product_collection_plan
    DO UPDATE SET
        name      = contexts.name -- Update to its current value just to get the id that can be returend.
    RETURNING id INTO context_id;

END;
$$;

DROP TYPE IF EXISTS public.key_value_pair CASCADE;
CREATE TYPE public.key_value_pair AS (
    svid    text,
    val     float
);

CREATE OR REPLACE PROCEDURE public.add_measurements(
    IN context_name VARCHAR(100),
    IN measurements public.key_value_pair[],
    IN measurement_time timestamp with time zone,
    OUT success BOOLEAN
)
LANGUAGE plpgsql
AS $$

DECLARE
currentIndex INTEGER DEFAULT 0;
contextId INTEGER DEFAULT NULL;
available_context_names TEXT;
svids_for_context TEXT[];
in_svids_array TEXT[];
sorted_measurements public.key_value_pair[];
sorted_values REAL[];
chunk_size INTEGER;
chunk_start INTEGER;
chunk_idx INTEGER;
col_names TEXT;
value_exprs TEXT;
sql_insert TEXT;
BEGIN
    success := FALSE;

    currentIndex := array_length(measurements, 1);

    -- Check if the context_name provided exists. If not then throw an exception
    SELECT id INTO contextId FROM contexts WHERE name = context_name;
    IF contextId IS NULL THEN
        SELECT STRING_AGG(name, ', ') INTO available_context_names FROM contexts; -- context names in the db
        RAISE EXCEPTION 'Context Name: ''%'' does not exist', context_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Avalable Context Names: ' || COALESCE(available_context_names, '[none]');
    END IF;

    -- Get svids from collection plan for the provided context
    SELECT svids INTO svids_for_context FROM contexts AS c
        INNER JOIN collection_plans as cp ON c.collection_plan_id = cp.id
        WHERE c.name = context_name;

    -- Extract svids from the input measurements
    SELECT ARRAY_AGG(u.svid ORDER BY u.svid ASC)
        INTO in_svids_array
        FROM UNNEST(measurements) AS u;

    -- svids in the collection plan and provided with the measurements MUST MATCH EXACTLY.
    IF NOT ((in_svids_array @> svids_for_context) AND (in_svids_array <@ svids_for_context)) THEN
        RAISE EXCEPTION 'SVIDs Provided does not match the collection plan for the context: ''%''', context_name
        USING
            ERRCODE = 'P0001',
            HINT = 'SVIDS Provided: ' || in_svids_array::TEXT || ', SVIDS in the collection plan: ' || svids_for_context::TEXT;
    END IF;

    -- SORT THE INPUT MEASUREMENTS
    SELECT ARRAY_AGG(kp ORDER BY kp.svid)
    INTO sorted_measurements
    FROM UNNEST(measurements) AS kp;

    SELECT ARRAY_AGG(kp.val ORDER BY kp.svid)
    INTO sorted_values
    FROM UNNEST(measurements) AS kp;

    FOREACH chunk_size IN ARRAY ARRAY[128, 64, 32, 16, 8, 4, 2, 1]
    LOOP
        IF currentIndex >= chunk_size THEN
            chunk_start := currentIndex - chunk_size + 1;
            col_names := '';
            value_exprs := '';

            FOR chunk_idx IN 1..chunk_size
            LOOP
                IF chunk_idx > 1 THEN
                    col_names := col_names || ', ';
                    value_exprs := value_exprs || ', ';
                END IF;

                col_names := col_names || format('col_%s', chunk_idx);
                value_exprs := value_exprs || format('($3)[%s]', chunk_start + chunk_idx - 1);
            END LOOP;

            sql_insert := format(
                'INSERT INTO public.%I(context_id, measurement_time, %s) VALUES ($1, $2, %s)',
                format('measurements_%s', chunk_size),
                col_names,
                value_exprs
            );

            EXECUTE sql_insert USING contextId, measurement_time, sorted_values;
            currentIndex := currentIndex - chunk_size;
        END IF;
    END LOOP;

    success := TRUE;

END;
$$;

-- Validation function for limit_settings vids JSON schema
-- Validates that:
-- 1. Each vid has required fields: target, ucl, lcl, uwl, lwl (all DOUBLE PRECISION)
-- 2. Each field value is numeric

CREATE OR REPLACE FUNCTION public.validate_limit_settings_vids(
    p_source_name VARCHAR(100),
    p_recipe_name VARCHAR(100),
    p_vids JSONB
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_vid_key TEXT;
    v_vid_obj JSONB;
    v_required_fields TEXT[] := ARRAY['target', 'ucl', 'lcl', 'uwl', 'lwl'];
    v_field TEXT;
BEGIN
    -- vids must not be NULL
    IF p_vids IS NULL THEN
        RAISE EXCEPTION 'vids cannot be NULL for limit_settings.'
            USING ERRCODE = 'P0001';
    END IF;

    -- Validate each vid in the JSON object
    FOR v_vid_key, v_vid_obj IN SELECT * FROM jsonb_each(p_vids)
    LOOP
        -- Validate that the vid object contains all required fields
        FOREACH v_field IN ARRAY v_required_fields
        LOOP
            IF NOT (v_vid_obj ? v_field) THEN
                RAISE EXCEPTION 'VID "%" is missing required field "%". Required fields: target, ucl, lcl, uwl, lwl.', v_vid_key, v_field
                    USING ERRCODE = 'P0001';
            END IF;

            -- Validate that the field value is numeric (can be cast to DOUBLE PRECISION)
            IF NOT (v_vid_obj->>v_field ~ '^-?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?$') THEN
                RAISE EXCEPTION 'VID "%" field "%" must be a valid numeric value (DOUBLE PRECISION).', v_vid_key, v_field
                    USING ERRCODE = 'P0001';
            END IF;
        END LOOP;

    END LOOP;

    RETURN TRUE;
END;
$$;
ALTER FUNCTION public.validate_limit_settings_vids(VARCHAR(100), VARCHAR(100), JSONB) OWNER TO postgres;

-- Updated add_limit_settings with JSON schema validation
CREATE OR REPLACE PROCEDURE public.add_limit_settings(
    IN  p_source_name VARCHAR(100),
    IN  p_recipe_name VARCHAR(100),
    IN  p_vids JSONB,
    OUT p_limit_settings_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existing_limit_settings_id INTEGER;
BEGIN
    p_limit_settings_id := NULL;

    -- Check if source_name + recipe_name already exists in limit_settings table
    SELECT id INTO v_existing_limit_settings_id
    FROM public.limit_settings
    WHERE LOWER(source_name) = LOWER(p_source_name)
      AND LOWER(recipe_name) = LOWER(p_recipe_name);

    IF v_existing_limit_settings_id IS NOT NULL THEN
        RAISE EXCEPTION 'A limit_settings record for source "%" and recipe "%" already exists.', p_source_name, p_recipe_name
            USING ERRCODE = 'P0001',
                  HINT = 'Use update_limit_settings to modify an existing record or choose a different source/recipe.';
    END IF;

    -- Validate the JSON schema and vids against collection plan
    -- Function raises exception on validation failure, returns TRUE on success
    PERFORM validate_limit_settings_vids(p_source_name, p_recipe_name, p_vids);

    -- Insert into limit_settings table (validation passed if we reach here)
    INSERT INTO public.limit_settings (source_name, recipe_name, vids)
    VALUES (p_source_name, p_recipe_name, p_vids)
    RETURNING id INTO p_limit_settings_id;

END;
$$;
ALTER PROCEDURE public.add_limit_settings(VARCHAR(100), VARCHAR(100), JSONB, OUT INTEGER) OWNER TO postgres;

-- Updated update_limit_settings with JSON schema validation
CREATE OR REPLACE PROCEDURE public.update_limit_settings(
    IN  p_source_name VARCHAR(100),
    IN  p_recipe_name VARCHAR(100),
    IN  p_vids JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existing_limit_settings_id INTEGER;
BEGIN
        -- Check if source_name + recipe_name exists in limit_settings table
        SELECT id INTO v_existing_limit_settings_id
        FROM public.limit_settings
        WHERE LOWER(source_name) = LOWER(p_source_name)
            AND LOWER(recipe_name) = LOWER(p_recipe_name);

    IF v_existing_limit_settings_id IS NULL THEN
                RAISE EXCEPTION 'A limit_settings record for source "%" and recipe "%" does not exist.', p_source_name, p_recipe_name
            USING ERRCODE = 'P0002',
                                    HINT = 'Use add_limit_settings to create a new record or provide a valid source_name/recipe_name.';
    END IF;

    -- Validate the JSON schema and vids against collection plan
    -- Function raises exception on validation failure, returns TRUE on success
        PERFORM validate_limit_settings_vids(p_source_name, p_recipe_name, p_vids);

    -- Update the vids for the existing limit_settings record (validation passed if we reach here)
    UPDATE public.limit_settings
    SET vids = p_vids
        WHERE LOWER(source_name) = LOWER(p_source_name)
            AND LOWER(recipe_name) = LOWER(p_recipe_name);

END;
$$;
ALTER PROCEDURE public.update_limit_settings(VARCHAR(100), VARCHAR(100), JSONB) OWNER TO postgres;

-- Get limit_settings by source_name + recipe_name
CREATE OR REPLACE FUNCTION public.get_limit_settings(p_source_name VARCHAR(100), p_recipe_name VARCHAR(100))
RETURNS SETOF public.limit_settings
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM public.limit_settings
        WHERE LOWER(source_name) = LOWER(p_source_name)
            AND LOWER(recipe_name) = LOWER(p_recipe_name);
END;
$$;
ALTER FUNCTION public.get_limit_settings(p_source_name VARCHAR(100), p_recipe_name VARCHAR(100)) OWNER TO postgres;

-- Add event procedure with validation
CREATE OR REPLACE PROCEDURE public.add_event(
    IN  p_context_name VARCHAR(100),
    IN  p_svids JSON,
    IN  p_rule_key VARCHAR(50),
    IN  p_ack BOOLEAN,
    IN  p_comments VARCHAR(1000),
    OUT p_event_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_context_id INTEGER;
    v_collection_plan_svids VARCHAR(100)[];
    v_rule_key_exists BOOLEAN;
    v_vid_key TEXT;
    v_vid_value TEXT;
BEGIN
    p_event_id := NULL;

    -- Validate that context_name exists in contexts table
    SELECT id INTO v_context_id FROM public.contexts WHERE LOWER(name) = LOWER(p_context_name);

    IF v_context_id IS NULL THEN
        RAISE EXCEPTION 'Context with name "%" does not exist.', p_context_name
            USING ERRCODE = 'P0002',
                  HINT = 'Provide a valid context_name from the contexts table.';
    END IF;

    -- Validate that rule_key exists in violation_types table
    SELECT EXISTS(
        SELECT 1 FROM public.violation_types WHERE violation_types.rule_key = p_rule_key
    ) INTO v_rule_key_exists;

    IF NOT v_rule_key_exists THEN
        RAISE EXCEPTION 'Rule key "%" does not exist in violation_types table.', p_rule_key
            USING ERRCODE = 'P0002',
                  HINT = 'Provide a valid rule_key from the violation_types table.';
    END IF;

    -- Get the svids array from collection_plan for the context
    SELECT cp.svids INTO v_collection_plan_svids
    FROM public.collection_plans cp
    INNER JOIN public.contexts c ON c.collection_plan_id = cp.id
    WHERE LOWER(c.name) = LOWER(p_context_name);

    IF v_collection_plan_svids IS NULL THEN
        RAISE EXCEPTION 'Unable to find collection plan for context "%".', p_context_name
            USING ERRCODE = 'P0002';
    END IF;

    -- Validate svids JSON schema: each key must be in collection_plan and value must be numeric
    FOR v_vid_key, v_vid_value IN SELECT * FROM json_each_text(p_svids)
    LOOP
        -- Check if this vid exists in the collection plan svids (case-insensitive)
        IF NOT EXISTS (SELECT 1 FROM unnest(v_collection_plan_svids) s WHERE LOWER(s) = LOWER(v_vid_key)) THEN
            RAISE EXCEPTION 'VID "%" is not present in the collection plan for context "%".', v_vid_key, p_context_name
                USING ERRCODE = 'P0001',
                      HINT = 'Available VIDs: ' || array_to_string(v_collection_plan_svids, ', ');
        END IF;

        -- Validate that the value is numeric (can be cast to DOUBLE PRECISION)
        IF NOT (v_vid_value ~ '^-?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?$') THEN
            RAISE EXCEPTION 'VID "%" value must be a valid numeric value (float).', v_vid_key
                USING ERRCODE = 'P0001';
        END IF;
    END LOOP;

    -- Insert into events table (validation passed if we reach here)
    INSERT INTO public.events (context_name, svids, rule_key, ack, comments)
    VALUES (p_context_name, p_svids, p_rule_key, p_ack, p_comments)
    RETURNING id INTO p_event_id;

END;
$$;
ALTER PROCEDURE public.add_event(VARCHAR(100), JSON, VARCHAR(50), BOOLEAN, VARCHAR(1000), OUT INTEGER) OWNER TO postgres;

CREATE OR REPLACE PROCEDURE public.get_collection_plan_id(
    IN  collection_plan_name VARCHAR(100),
    OUT collection_plan_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    collection_plan_id := -1;
    SELECT id INTO collection_plan_id 
        FROM collection_plans
        WHERE UPPER(cp_name) = UPPER(collection_plan_name);
END;
$$;

CREATE OR REPLACE FUNCTION public.get_measurement(
    svid_name   VARCHAR(100),
    collection_plan_name VARCHAR(100),
    searchFields     jsonb
)
RETURNS TABLE(
    measure             real,
    measurement_id      INT,
    measurement_time    timestamp with time zone,
    context_id          INT
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    dynamic_query TEXT;
    col TEXT;
    measurment_table   VARCHAR(100);
    measurment_column  VARCHAR(100);
    sourceClause TEXT;
    productClause TEXT;
BEGIN
    RAISE INFO 'Executing: get_measurement(%, %, %)', svid_name, collection_plan_name, searchFields;

    -- Get measurement table and column name for the svid for a given collection plan.
    SELECT tableName, colName INTO measurment_table, measurment_column
    FROM public.get_svid_column(svid_name, collection_plan_name);

    --Get sources WHERE clause
    sourceClause := get_where_clause('sources', searchFields->'source');

    --Get products WHERE clause.
    productClause := get_where_clause('products', searchFields->'product');

    dynamic_query := 'SELECT ' || measurment_table || '.' || measurment_column || ' AS ' || svid_name || ', ' ||
                        measurment_table || '.id AS measurement_id, ' ||
                        measurment_table || '.measurement_time , conxt.id context_id' || ' FROM contexts AS conxt ' ||
                        ' INNER JOIN ' || measurment_table || ' ON ' || measurment_table || '.context_id = conxt.id ' ||
                        ' INNER JOIN products ON conxt.product_id = products.id' ||
                        ' INNER JOIN sources  ON conxt.source_id = sources.id ';

    dynamic_query := dynamic_query || 'WHERE ' || sourceClause || ' AND ' || productClause;
    RAISE INFO 'dynamic_query: %', dynamic_query;

    RETURN QUERY EXECUTE dynamic_query;
END;
$$;
ALTER FUNCTION public.get_measurement(svid_name VARCHAR(100), collection_plan_name VARCHAR(100), searchFields jsonb) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_measurementv2(
    svid_name       VARCHAR(100),
    context_name    VARCHAR(100)
)
RETURNS TABLE(
    measure             real,
    measurement_id      INT,
    measurement_time    timestamp with time zone,
    context_id          INT
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    dynamic_query           TEXT;
    measurment_table        VARCHAR(100);
    measurment_column       VARCHAR(100);
    collection_plan_name    VARCHAR(100);
BEGIN
    -- CHECK CONTEXT EXISTS
    IF NOT EXISTS (SELECT 1 FROM contexts WHERE name = context_name) THEN
        RAISE EXCEPTION 'context ''%'' DOES NOT EXIST', context_name
        USING
            ERRCODE = 'P0001',
            HINT = 'context ' || context_name || ' DOES NOT EXIST';
    END IF;

    -- GET COLLECTION PLAN FROM INPUT CONTEXT
    SELECT cp.cp_name INTO collection_plan_name
    FROM collection_plans cp
    INNER JOIN contexts c ON c.collection_plan_id = cp.id
    WHERE c.name = context_name;

    -- CHECK SVID EXISTS IN THE COLLECTION PLAN FOR THIS CONTEXT
    IF NOT EXISTS (
        SELECT 1
        FROM collection_plans cp
        INNER JOIN contexts c ON c.collection_plan_id = cp.id
        WHERE c.name = context_name
          AND svid_name = ANY(cp.svids)
    ) THEN
        RAISE EXCEPTION 'Requested svid % is not in collection plan % of context %', svid_name, collection_plan_name, context_name
        USING
            ERRCODE = 'P0001',
            HINT = 'Requested svid ' || svid_name || ' not in collection plan ' ||
                    collection_plan_name || ' for context ' || context_name;
    END IF;

    -- GET MEASUREMENT TABLE AND COLUMN NAME FOR THE SVID FOR A GIVEN COLLECTION PLAN
    SELECT tableName, colName INTO measurment_table, measurment_column
    FROM public.get_svid_column(svid_name, collection_plan_name);

    -- Build query that explicitly filters by context_name to avoid cross-context leakage
    dynamic_query := format(
        'SELECT m.%I AS measure, m.id AS measurement_id, m.measurement_time, m.context_id '
        'FROM %I m '
        'INNER JOIN contexts c ON c.id = m.context_id '
        'WHERE c.name = $1 '
        'ORDER BY m.measurement_time, m.id',
        measurment_column,
        measurment_table
    );
    RAISE INFO 'dynamic_query: %', dynamic_query;

    RETURN QUERY EXECUTE dynamic_query USING context_name;
END;
$$;
ALTER FUNCTION public.get_measurementv2(svid_name VARCHAR(100), context_name VARCHAR(100)) OWNER TO postgres;

-- Time-range variant: same as get_measurementv2 but filters between p_start and p_end.
-- Pass NULL for either bound to leave it open.
CREATE OR REPLACE FUNCTION public.get_measurementv2_range(
    svid_name       VARCHAR(100),
    context_name    VARCHAR(100),
    p_start_time    TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_end_time      TIMESTAMP WITH TIME ZONE DEFAULT NULL
)
RETURNS TABLE(
    measure             real,
    measurement_id      INT,
    measurement_time    timestamp with time zone,
    context_id          INT
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    dynamic_query           TEXT;
    measurment_table        VARCHAR(100);
    measurment_column       VARCHAR(100);
    collection_plan_name    VARCHAR(100);
BEGIN
    IF NOT EXISTS (SELECT 1 FROM contexts WHERE name = context_name) THEN
        RAISE EXCEPTION 'context ''%'' DOES NOT EXIST', context_name
        USING ERRCODE = 'P0001';
    END IF;

    SELECT cp.cp_name INTO collection_plan_name
    FROM collection_plans cp
    INNER JOIN contexts c ON c.collection_plan_id = cp.id
    WHERE c.name = context_name;

    IF NOT EXISTS (
        SELECT 1
        FROM collection_plans cp
        INNER JOIN contexts c ON c.collection_plan_id = cp.id
        WHERE c.name = context_name
          AND svid_name = ANY(cp.svids)
    ) THEN
        RAISE EXCEPTION 'Requested svid % is not in collection plan % of context %',
            svid_name, collection_plan_name, context_name
        USING ERRCODE = 'P0001';
    END IF;

    SELECT tableName, colName INTO measurment_table, measurment_column
    FROM public.get_svid_column(svid_name, collection_plan_name);

    dynamic_query := format(
        'SELECT m.%I AS measure, m.id AS measurement_id, m.measurement_time, m.context_id '
        'FROM %I m '
        'INNER JOIN contexts c ON c.id = m.context_id '
        'WHERE c.name = $1 '
        'AND ($2 IS NULL OR m.measurement_time >= $2) '
        'AND ($3 IS NULL OR m.measurement_time <= $3) '
        'ORDER BY m.measurement_time, m.id',
        measurment_column,
        measurment_table
    );

    RETURN QUERY EXECUTE dynamic_query USING context_name, p_start_time, p_end_time;
END;
$$;
ALTER FUNCTION public.get_measurementv2_range(svid_name VARCHAR(100), context_name VARCHAR(100), p_start_time TIMESTAMP WITH TIME ZONE, p_end_time TIMESTAMP WITH TIME ZONE) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_measurement_adv(
    svid_name   VARCHAR(100),
    searchFields     jsonb,
    start_datetime   TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    end_datetime     TIMESTAMP WITH TIME ZONE DEFAULT NULL
)
RETURNS TABLE(
    measure             real,
    measurement_id      INT,
    measurement_time    timestamp with time zone,
    context_id          INT
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    ctx RECORD;
    kv RECORD;
    dynamic_query TEXT;
    context_query TEXT;
    measurment_table VARCHAR(100);
    measurment_column VARCHAR(100);
    source_filters JSONB;
    product_filters JSONB;
    sourceClause TEXT;
    productClause TEXT;
    attribute_name TEXT;
    comparator_raw TEXT;
    comparator_sql TEXT;
    attribute_value TEXT;
BEGIN
    RAISE INFO 'Executing: get_measurement_adv(%, %, %, %)', svid_name, searchFields, start_datetime, end_datetime;

    IF searchFields IS NULL THEN
        searchFields := '{}'::jsonb;
    END IF;

    SELECT e.value
    INTO source_filters
    FROM jsonb_each(searchFields) AS e
    WHERE LOWER(e.key) IN ('source', 'sources')
    LIMIT 1;

    SELECT e.value
    INTO product_filters
    FROM jsonb_each(searchFields) AS e
    WHERE LOWER(e.key) IN ('product', 'products')
    LIMIT 1;

    -- Build source filter
    sourceClause := 'TRUE';
    IF source_filters IS NOT NULL AND source_filters <> '{}'::jsonb THEN
        FOR kv IN SELECT * FROM jsonb_each(source_filters)
        LOOP
            attribute_name := LOWER(kv.key);
            comparator_raw := UPPER(COALESCE(kv.value->>'comparator', '='));
            attribute_value := kv.value->>'val';

            IF attribute_value IS NULL THEN
                CONTINUE;
            END IF;

            IF comparator_raw IN ('=', '!=', '<>', '>', '<', '>=', '<=') THEN
                comparator_sql := comparator_raw;
                sourceClause := sourceClause || format(
                    ' AND LOWER(COALESCE(sources.attributes->>%L, '''')) %s LOWER(%L)',
                    attribute_name,
                    comparator_sql,
                    attribute_value
                );
            ELSIF comparator_raw IN ('LIKE', 'ILIKE') THEN
                sourceClause := sourceClause || format(
                    ' AND LOWER(COALESCE(sources.attributes->>%L, '''')) LIKE LOWER(%L)',
                    attribute_name,
                    attribute_value
                );
            ELSE
                RAISE EXCEPTION 'Unsupported comparator "%" in source filters.', comparator_raw
                    USING ERRCODE = 'P0001',
                          HINT = 'Supported comparators: =, !=, <>, >, <, >=, <=, LIKE, ILIKE';
            END IF;
        END LOOP;
    END IF;

    -- Build product filter
    productClause := 'TRUE';
    IF product_filters IS NOT NULL AND product_filters <> '{}'::jsonb THEN
        FOR kv IN SELECT * FROM jsonb_each(product_filters)
        LOOP
            attribute_name := LOWER(kv.key);
            comparator_raw := UPPER(COALESCE(kv.value->>'comparator', '='));
            attribute_value := kv.value->>'val';

            IF attribute_value IS NULL THEN
                CONTINUE;
            END IF;

            IF comparator_raw IN ('=', '!=', '<>', '>', '<', '>=', '<=') THEN
                comparator_sql := comparator_raw;
                productClause := productClause || format(
                    ' AND LOWER(COALESCE(products.attributes->>%L, '''')) %s LOWER(%L)',
                    attribute_name,
                    comparator_sql,
                    attribute_value
                );
            ELSIF comparator_raw IN ('LIKE', 'ILIKE') THEN
                productClause := productClause || format(
                    ' AND LOWER(COALESCE(products.attributes->>%L, '''')) LIKE LOWER(%L)',
                    attribute_name,
                    attribute_value
                );
            ELSE
                RAISE EXCEPTION 'Unsupported comparator "%" in product filters.', comparator_raw
                    USING ERRCODE = 'P0001',
                          HINT = 'Supported comparators: =, !=, <>, >, <, >=, <=, LIKE, ILIKE';
            END IF;
        END LOOP;
    END IF;

    context_query :=
        'SELECT c.id AS context_id, cp.cp_name AS collection_plan_name ' ||
        'FROM contexts c ' ||
        'INNER JOIN products ON c.product_id = products.id ' ||
        'INNER JOIN sources ON c.source_id = sources.id ' ||
        'INNER JOIN collection_plans cp ON c.collection_plan_id = cp.id ' ||
        'WHERE (' || quote_literal(svid_name) || ' = ANY(cp.svids)) ' ||
        'AND ' || sourceClause || ' AND ' || productClause;

    FOR ctx IN EXECUTE context_query
    LOOP
        -- Resolve measurement table/column for this context's collection plan
        SELECT tableName, colName
        INTO measurment_table, measurment_column
        FROM public.get_svid_column(svid_name, ctx.collection_plan_name)
        LIMIT 1;

        IF measurment_table IS NULL OR measurment_column IS NULL THEN
            CONTINUE;
        END IF;

        dynamic_query :=
            'SELECT m.' || quote_ident(measurment_column) || ' AS measure, ' ||
            'm.id AS measurement_id, m.measurement_time, m.context_id ' ||
            'FROM ' || quote_ident(measurment_table) || ' m ' ||
            'INNER JOIN contexts conxt ON conxt.id = m.context_id ' ||
            'INNER JOIN products ON conxt.product_id = products.id ' ||
            'INNER JOIN sources ON conxt.source_id = sources.id ' ||
            'WHERE conxt.id = $1 AND ' || sourceClause || ' AND ' || productClause || ' ' ||
            'AND ($2 IS NULL OR m.measurement_time >= $2) ' ||
            'AND ($3 IS NULL OR m.measurement_time <= $3) ' ||
            'ORDER BY m.measurement_time, m.id';

        RETURN QUERY EXECUTE dynamic_query USING ctx.context_id, start_datetime, end_datetime;
    END LOOP;

    RETURN;
END;
$$;
ALTER FUNCTION public.get_measurement_adv(svid_name VARCHAR(100), searchFields jsonb, start_datetime TIMESTAMP WITH TIME ZONE, end_datetime TIMESTAMP WITH TIME ZONE) OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_svid_column(
    svid_name               VARCHAR(100),
    collection_plan_name    VARCHAR(100)
)
RETURNS TABLE(
    svidName   VARCHAR(100),
    tableName  VARCHAR(100),
    colName    VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
DECLARE
    svid_names      JSONB;
    col_svids_map   JSONB;
    measmntTable    VARCHAR(100);
    colName         VARCHAR(100);
    svid            VARCHAR(100);
    colFound        BOOLEAN DEFAULT FALSE;
BEGIN
    RAISE INFO 'svid_name: %', svid_name;
    RAISE INFO 'collection_plan_name: %', collection_plan_name;

    SELECT svids_map INTO svid_names::jsonb FROM collection_plans WHERE cp_name = collection_plan_name;
    RAISE INFO 'svid_names: %', svid_names;

    FOR measmntTable, col_svids_map IN SELECT * FROM jsonb_each_text(svid_names) LOOP
        FOR colName, svid IN SELECT * FROM jsonb_each_text(col_svids_map::JSONB) LOOP
            IF svid = svid_name THEN
                colFound := TRUE;
                EXIT;
            END IF;
        END LOOP;
        EXIT WHEN colFound = TRUE;
    END LOOP;

    IF colFound = TRUE THEN
        RETURN QUERY SELECT svid, measmntTable, LOWER(colName)::VARCHAR(100);
    ELSE
        RETURN QUERY SELECT svid_name, NULL::VARCHAR(100), NULL::VARCHAR(100);
    END IF;

END;
$$;
ALTER FUNCTION public.get_svid_column(svid_name VARCHAR(100), collection_plan_name VARCHAR(100)) OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.get_where_clause(
    attributeType VARCHAR(100), -- source or product.
    cntxt   JSONB
) RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    whereClause TEXT := '';
    attributeName TEXT;
    attributeValAndComp TEXT;
    attributComparator TEXT;
    attributeVal TEXT;
BEGIN
    RAISE INFO 'Executing: get_where_clause(attributeType: %, cntxt: %)', attributeType, cntxt;

    FOR attributeName, attributeValAndComp IN SELECT * FROM jsonb_each_text(cntxt::JSONB) LOOP
            attributComparator := attributeValAndComp::jsonb ->>'comparator';
            attributeVal := attributeValAndComp::jsonb ->>'val';

            IF whereClause <> '' THEN
                whereClause := whereClause || ' AND ';
            END IF;

            whereClause := whereClause || attributeType || '.attributes->>''' || attributeName || ''' ' || attributComparator || ' ''' || attributeVal || ''' ';
    END LOOP;

    RAISE INFO 'Exiting get_where_clause(): Return Value: %', ' (' || whereClause || ') ';
    RETURN ' (' || whereClause || ') ';
END;
$$;
ALTER FUNCTION public.get_where_clause(attributeType VARCHAR(100), cntxt   JSONB) OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.get_collection_plans(
    in_source_name     VARCHAR(100),
    in_product_name    VARCHAR(100)
)
RETURNS TABLE(
    context_name             VARCHAR(100),
    source_name             VARCHAR(100),
    product_name            VARCHAR(100),
    collection_plan_name    VARCHAR(100),
    svids                   VARCHAR(100)[]
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    dynamic_query           TEXT;
BEGIN
    dynamic_query := 'SELECT contexts.name as context_name, sources.name AS source_name, products.name AS product_name, collection_plans.cp_name AS collection_plan_name, collection_plans.svids AS svids ' ||
                    'FROM contexts ' ||
                    'INNER JOIN sources ON contexts.source_id = sources.id ' ||
                    'INNER JOIN products ON contexts.product_id = products.id ' ||
                    'INNER JOIN collection_plans ON contexts.collection_plan_id = collection_plans.id ' ||
                    'WHERE sources.name = ''' || in_source_name || ''' AND products.name = ''' || in_product_name || '''';
    RAISE INFO 'dynamic_query: %', dynamic_query;

    RETURN QUERY EXECUTE dynamic_query;
END;
$$;
ALTER FUNCTION public.get_collection_plans(in_source_name VARCHAR(100), in_product_name VARCHAR(100)) OWNER TO postgres;


CREATE OR REPLACE PROCEDURE public.add_report(
    OUT p_id INTEGER,
    IN  p_name TEXT,
    IN  p_attributes JSONB,
    IN  p_tags TEXT[] DEFAULT NULL,
    IN  p_description TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.reports (name, attributes, tags,description)
    VALUES (p_name, p_attributes, p_tags, p_description)
    RETURNING id INTO p_id;  -- Assigns the generated identity value to p_id
END;
$$;

CREATE OR REPLACE FUNCTION public.get_reports_by_tags(p_tags TEXT[] DEFAULT NULL)
RETURNS TABLE (
    id INT,
    name TEXT,
    attributes JSONB,
    tags TEXT[],
    description TEXT
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.name, t.attributes, t.tags, t.description
    FROM reports t
    WHERE 
        -- Condition 1: Return true if the input is NULL or empty
        p_tags IS NULL 
        OR cardinality(p_tags) = 0
        -- Condition 2: Otherwise, check if the row's tags contain any input tags
        OR lower_array(t.tags) && lower_array(p_tags);
END;
$$;

CREATE OR REPLACE FUNCTION public.add_tag_to_report(
    p_report_name TEXT,
    p_new_tag TEXT
)
RETURNS INTEGER 
LANGUAGE plpgsql
AS $$
DECLARE
    v_id INTEGER;
BEGIN
    -- 1. Update the report by name
    UPDATE public.reports
    SET tags = array_append(tags, p_new_tag)
    WHERE LOWER(name) = LOWER(p_report_name)  -- Case-insensitive lookup
      AND (tags IS NULL OR NOT (tags @> ARRAY[p_new_tag]))
    RETURNING id INTO v_id;

    -- 2. If no ID was returned, determine if the name is missing or tag exists
    IF v_id IS NULL THEN
        -- Check if the name exists at all (ignoring case)
        SELECT id INTO v_id FROM public.reports WHERE LOWER(name) = LOWER(p_report_name);

        IF v_id IS NULL THEN
            RAISE EXCEPTION 'Report with name "%" not found.', p_report_name
                USING ERRCODE = 'P0002'; -- No data found
        END IF;

        -- If we found the ID here, it means the tag was already present
        -- We return the ID to confirm which row was targeted
        RETURN v_id;
    END IF;

    RETURN v_id;
END;
$$;


CREATE OR REPLACE PROCEDURE public.remove_report_by_name(
    IN  p_name TEXT,
    OUT p_id   INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    p_id := NULL;

    DELETE FROM public.reports
    WHERE LOWER(name) = LOWER(p_name)
    RETURNING id INTO p_id;

    IF p_id IS NULL THEN
        RAISE EXCEPTION 'Report with name "%" not found.', p_name
            USING ERRCODE = 'P0002';
    END IF;
END;
$$;
ALTER PROCEDURE public.remove_report_by_name(TEXT, OUT integer) OWNER TO postgres;


-- Create the violation_types reference table
CREATE TABLE public.violation_types (
    -- Unique identifier for the violation type
    violation_type_id SERIAL PRIMARY KEY,

    -- Unique slug for backend logic (e.g., 'NELSON_1', 'HARD_LIMIT_UCL')
    rule_key VARCHAR(50) UNIQUE NOT NULL,

    -- Human-readable name for Plotly legends and tooltips
    display_name VARCHAR(100) NOT NULL,

    -- Severity level: 1 (Info/Trend), 2 (Warning/Shift), 3 (Critical/Out of Spec)
    severity SMALLINT NOT NULL DEFAULT 1,

    -- Hex code for Plotly marker.color (e.g., '#FF0000')
    marker_color VARCHAR(7) NOT NULL DEFAULT '#1f77b4',

    -- Plotly symbol name (e.g., 'circle', 'diamond', 'triangle-up', 'x')
    marker_symbol VARCHAR(30) NOT NULL DEFAULT 'circle',

    -- Business logic: Does this breach require an operator to type a comment?
    requires_action BOOLEAN NOT NULL DEFAULT FALSE,

    -- Detailed explanation of the statistical rule for operator guidance
    description TEXT
);

ALTER TABLE public.violation_types OWNER TO postgres;
-- Case-insensitive unique index on rule_key to enforce uniqueness regardless of case
CREATE UNIQUE INDEX unique_violation_rule_key_lower_idx ON public.violation_types (LOWER(rule_key));

-- Get violation_type with case-insensitive matching
CREATE OR REPLACE FUNCTION public.get_violation_type(p_rule_key VARCHAR(50))
RETURNS SETOF public.violation_types
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM public.violation_types
    WHERE LOWER(rule_key) = LOWER(p_rule_key);
END;
$$;
ALTER FUNCTION public.get_violation_type(p_rule_key VARCHAR(50)) OWNER TO postgres;

-- ML MODEL MANAGEMENT FUNCTIONS AND PROCEDURES

-- Add a new ML model
CREATE OR REPLACE PROCEDURE public.add_ml_model(
    IN  p_source_name VARCHAR(100),
    IN  p_recipe_name VARCHAR(100),
    IN  p_version VARCHAR(50),
    IN  p_file_path TEXT,
    IN  p_model_type VARCHAR(50),
    IN  p_framework VARCHAR(50),
    IN  p_metrics JSONB,
    IN  p_created_by VARCHAR(100),
    IN  p_description TEXT,
    OUT p_model_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_source_exists BOOLEAN;
BEGIN
    -- Validate source exists
    SELECT EXISTS(SELECT 1 FROM public.sources WHERE name = p_source_name) INTO v_source_exists;
    
    IF NOT v_source_exists THEN
        RAISE EXCEPTION 'Source with name % does not exist', p_source_name
            USING ERRCODE = 'P0002';
    END IF;

    INSERT INTO public.ml_models (
        source_name, recipe_name, version, file_path,
        model_type, framework, metrics, created_by, description
    )
    VALUES (
        p_source_name, p_recipe_name, p_version, p_file_path,
        p_model_type, p_framework, p_metrics, p_created_by, p_description
    )
    RETURNING id INTO p_model_id;
END;
$$;
ALTER PROCEDURE public.add_ml_model(VARCHAR(100), VARCHAR(100), VARCHAR(50), TEXT, VARCHAR(50), VARCHAR(50), JSONB, VARCHAR(100), TEXT, OUT INTEGER) OWNER TO postgres;

-- Add a training run record
CREATE OR REPLACE PROCEDURE public.add_training_run(
    IN  p_model_id INT,
    IN  p_hyperparameters JSONB,
    IN  p_dataset_path TEXT,
    IN  p_duration_seconds INT,
    IN  p_metrics JSONB,
    IN  p_status VARCHAR(50),
    IN  p_created_by VARCHAR(100),
    OUT p_run_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_model_exists BOOLEAN;
BEGIN
    -- Validate model exists
    SELECT EXISTS(SELECT 1 FROM public.ml_models WHERE id = p_model_id) INTO v_model_exists;
    
    IF NOT v_model_exists THEN
        RAISE EXCEPTION 'Model with id % does not exist', p_model_id
            USING ERRCODE = 'P0002';
    END IF;

    INSERT INTO public.ml_training_runs (
        model_id, hyperparameters, dataset_path, duration_seconds,
        metrics, status, created_by
    )
    VALUES (
        p_model_id, p_hyperparameters, p_dataset_path, p_duration_seconds,
        p_metrics, p_status, p_created_by
    )
    RETURNING id INTO p_run_id;
END;
$$;
ALTER PROCEDURE public.add_training_run(INT, JSONB, TEXT, INT, JSONB, VARCHAR(50), VARCHAR(100), OUT INTEGER) OWNER TO postgres;

-- Deploy a model to an environment
CREATE OR REPLACE PROCEDURE public.deploy_model(
    IN  p_model_id INT,
    IN  p_environment VARCHAR(50),
    IN  p_deployed_by VARCHAR(100),
    OUT p_deployment_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_model_exists BOOLEAN;
BEGIN
    -- Validate model exists
    SELECT EXISTS(SELECT 1 FROM public.ml_models WHERE id = p_model_id) INTO v_model_exists;
    
    IF NOT v_model_exists THEN
        RAISE EXCEPTION 'Model with id % does not exist', p_model_id
            USING ERRCODE = 'P0002';
    END IF;

    INSERT INTO public.ml_model_deployments (
        model_id, environment, is_active, deployed_by
    )
    VALUES (
        p_model_id, p_environment, FALSE, p_deployed_by
    )
    RETURNING id INTO p_deployment_id;
END;
$$;
ALTER PROCEDURE public.deploy_model(INT, VARCHAR(50), VARCHAR(100), OUT INTEGER) OWNER TO postgres;

-- Activate a model (deactivates other models for the same source/recipe/step)
CREATE OR REPLACE PROCEDURE public.activate_model(
    IN  p_model_id INT,
    IN  p_deployed_by VARCHAR(100) DEFAULT 'system'
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_source_name VARCHAR(100);
    v_recipe_name VARCHAR(100);
    v_model_exists BOOLEAN;
BEGIN
    -- Get model details
    SELECT source_name, recipe_name
    INTO v_source_name, v_recipe_name
    FROM public.ml_models
    WHERE id = p_model_id;
    
    IF v_source_name IS NULL THEN
        RAISE EXCEPTION 'Model with id % does not exist', p_model_id
            USING ERRCODE = 'P0002';
    END IF;

    -- Deactivate all other models for this source/recipe
    UPDATE public.ml_model_deployments
    SET is_active = FALSE,
        deactivated_at = CURRENT_TIMESTAMP,
        deactivated_by = p_deployed_by
    WHERE model_id IN (
        SELECT id FROM public.ml_models
        WHERE source_name = v_source_name
          AND recipe_name = v_recipe_name
    )
    AND is_active = TRUE;

    -- Activate the specified model (or create deployment if it doesn't exist)
    INSERT INTO public.ml_model_deployments (
        model_id, environment, is_active, deployed_by
    )
    VALUES (
        p_model_id, 'production', TRUE, p_deployed_by
    )
    ON CONFLICT DO NOTHING;

    -- If deployment already exists, activate it
    UPDATE public.ml_model_deployments
    SET is_active = TRUE,
        deployed_at = CURRENT_TIMESTAMP,
        deployed_by = p_deployed_by
    WHERE model_id = p_model_id;

    -- Update model status to production
    UPDATE public.ml_models
    SET status = 'production'
    WHERE id = p_model_id;
END;
$$;
ALTER PROCEDURE public.activate_model(INT, VARCHAR(100)) OWNER TO postgres;

-- Get active model for a source/recipe
CREATE OR REPLACE FUNCTION public.get_active_model(
    p_source_name VARCHAR(100),
    p_recipe_name VARCHAR(100),
    p_model_type VARCHAR(50)
)
RETURNS TABLE (
    model_id INT,
    version VARCHAR(50),
    file_path TEXT,
    model_type VARCHAR(50),
    framework VARCHAR(50),
    metrics JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.id,
        m.version,
        m.file_path,
        m.model_type,
        m.framework,
        m.metrics
    FROM public.ml_models m
    WHERE m.source_name = p_source_name
      AND m.recipe_name = p_recipe_name
      AND m.model_type = p_model_type
    LIMIT 1;
END;
$$;
ALTER FUNCTION public.get_active_model(VARCHAR(100), VARCHAR(100), VARCHAR(50)) OWNER TO postgres;

-- Get model by ID
CREATE OR REPLACE FUNCTION public.get_model_by_id(p_model_id INT)
RETURNS SETOF public.ml_models
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM public.ml_models
    WHERE id = p_model_id;
END;
$$;
ALTER FUNCTION public.get_model_by_id(INT) OWNER TO postgres;

-- Get all models for a source and recipe
CREATE OR REPLACE FUNCTION public.get_models_by_source_recipe(
    p_source_name VARCHAR(100),
    p_recipe_name VARCHAR(100)
)
RETURNS TABLE (
    model_id INT,
    version VARCHAR(50),
    file_path TEXT,
    model_type VARCHAR(50),
    framework VARCHAR(50),
    status VARCHAR(20),
    metrics JSONB,
    created_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.id,
        m.version,
        m.file_path,
        m.model_type,
        m.framework,
        m.status,
        m.metrics,
        m.created_at,
        COALESCE(d.is_active, FALSE) as is_active
    FROM public.ml_models m
    LEFT JOIN public.ml_model_deployments d ON m.id = d.model_id AND d.is_active = TRUE
    WHERE m.source_name = p_source_name
      AND m.recipe_name = p_recipe_name
    ORDER BY m.created_at DESC;
END;
$$;
ALTER FUNCTION public.get_models_by_source_recipe(VARCHAR(100), VARCHAR(100)) OWNER TO postgres;

-- Get training runs for a model
CREATE OR REPLACE FUNCTION public.get_training_runs_by_model(p_model_id INT)
RETURNS SETOF public.ml_training_runs
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM public.ml_training_runs
    WHERE model_id = p_model_id
    ORDER BY created_at DESC;
END;
$$;
ALTER FUNCTION public.get_training_runs_by_model(INT) OWNER TO postgres;

-- Get active model by context name
-- Helper function for inference scripts that only know the context name
CREATE OR REPLACE FUNCTION public.get_active_model_by_context(
    p_context_name VARCHAR(100)
)
RETURNS TABLE (
    model_id INT,
    source_name VARCHAR(100),
    recipe_name VARCHAR(100),
    version VARCHAR(50),
    file_path TEXT,
    model_type VARCHAR(50),
    framework VARCHAR(50),
    metrics JSONB,
    deployed_at TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.id,
        m.source_name,
        m.recipe_name,
        m.version,
        m.file_path,
        m.model_type,
        m.framework,
        m.metrics,
        d.deployed_at
    FROM public.contexts c
    INNER JOIN public.sources s ON c.source_id = s.id
    INNER JOIN public.ml_models m ON m.source_name = s.name
    INNER JOIN public.ml_model_deployments d ON m.id = d.model_id
    WHERE c.name = p_context_name
      AND d.is_active = TRUE
    ORDER BY d.deployed_at DESC
    LIMIT 1;
END;
$$;
ALTER FUNCTION public.get_active_model_by_context(VARCHAR(100)) OWNER TO postgres;


-- ============================================================================
-- ALARMS / WARNINGS SCHEMA
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.alarms (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    context_id INT NOT NULL REFERENCES public.contexts(id) ON DELETE CASCADE,
    source_name VARCHAR(100) NOT NULL,
    measurement_time TIMESTAMP WITH TIME ZONE NOT NULL,
    measurement_refs JSONB NOT NULL DEFAULT '[]'::jsonb,
    alarm_type VARCHAR(50) NOT NULL CHECK (alarm_type IN ('LIMIT', 'ISO_FOREST', 'PCA')),
    severity SMALLINT NOT NULL DEFAULT 1,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'ACKED', 'CLEARED')),
    rule_key VARCHAR(50),
    message VARCHAR(1000),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    triggered_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

ALTER TABLE public.alarms ADD COLUMN IF NOT EXISTS measurement_refs JSONB NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE public.alarms DROP COLUMN IF EXISTS measurement_table;
ALTER TABLE public.alarms DROP COLUMN IF EXISTS measurement_id;
UPDATE public.alarms SET measurement_refs = '[]'::jsonb WHERE measurement_refs IS NULL;

CREATE INDEX IF NOT EXISTS idx_alarms_context_triggered_at ON public.alarms (context_id, triggered_at DESC);
CREATE INDEX IF NOT EXISTS idx_alarms_source_triggered_at ON public.alarms (source_name, triggered_at DESC);
CREATE INDEX IF NOT EXISTS idx_alarms_type_status ON public.alarms (alarm_type, status);


CREATE TABLE IF NOT EXISTS public.alarm_contributions (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alarm_id INT NOT NULL REFERENCES public.alarms(id) ON DELETE CASCADE,
    contribution_kind VARCHAR(50) NOT NULL CHECK (contribution_kind IN ('ISO_FOREST', 'PCA_T2', 'PCA_DMODX')),
    channel_name VARCHAR(100) NOT NULL,
    contribution_value DOUBLE PRECISION NOT NULL,
    rank SMALLINT,
    is_primary_driver BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT uq_alarm_contrib UNIQUE (alarm_id, contribution_kind, channel_name)
);

CREATE INDEX IF NOT EXISTS idx_alarm_contrib_alarm_kind ON public.alarm_contributions (alarm_id, contribution_kind);


CREATE TABLE IF NOT EXISTS public.limit_alarm_detail (
    alarm_id INT PRIMARY KEY REFERENCES public.alarms(id) ON DELETE CASCADE,
    channel_name VARCHAR(100) NOT NULL,
    measured_value DOUBLE PRECISION NOT NULL,
    lower_limit DOUBLE PRECISION,
    upper_limit DOUBLE PRECISION,
    breach_direction VARCHAR(10) NOT NULL CHECK (breach_direction IN ('LOW', 'HIGH', 'BOTH'))
);


CREATE TABLE IF NOT EXISTS public.iforest_alarm_detail (
    alarm_id INT PRIMARY KEY REFERENCES public.alarms(id) ON DELETE CASCADE,
    anomaly_score DOUBLE PRECISION NOT NULL,
    lower_threshold DOUBLE PRECISION,
    upper_threshold DOUBLE PRECISION,
    dif_score DOUBLE PRECISION,
    threshold DOUBLE PRECISION,
    is_anomaly BOOLEAN NOT NULL,
    model_name VARCHAR(200),
    model_version VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS public.pca_alarm_detail (
    alarm_id INT PRIMARY KEY REFERENCES public.alarms(id) ON DELETE CASCADE,
    pc1 DOUBLE PRECISION,
    pc2 DOUBLE PRECISION,
    t2 DOUBLE PRECISION,
    dmodx DOUBLE PRECISION,
    pc_outside_95 BOOLEAN NOT NULL DEFAULT FALSE,
    pc_outside_99 BOOLEAN NOT NULL DEFAULT FALSE,
    t2_limit_95 DOUBLE PRECISION,
    t2_limit_99 DOUBLE PRECISION,
    dmodx_limit_95 DOUBLE PRECISION,
    dmodx_limit_99 DOUBLE PRECISION,
    model_path TEXT
);


CREATE OR REPLACE FUNCTION public.resolve_measurement_ref(
    p_context_id INT,
    p_measurement_time TIMESTAMP WITH TIME ZONE
)
RETURNS TABLE(
    measurement_table VARCHAR(100),
    measurement_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_table VARCHAR(50);
    v_candidate_tables TEXT[] := ARRAY['measurements_128', 'measurements_64', 'measurements_32', 'measurements_16', 'measurements_8', 'measurements_4', 'measurements_2', 'measurements_1'];
    v_exists REGCLASS;
    v_match_id INT;
BEGIN
    FOREACH v_table IN ARRAY v_candidate_tables
    LOOP
        SELECT to_regclass('public.' || v_table) INTO v_exists;
        IF v_exists IS NULL THEN
            CONTINUE;
        END IF;

        BEGIN
            EXECUTE format(
                'SELECT id FROM public.%I WHERE context_id = $1 AND measurement_time = $2 ORDER BY id DESC LIMIT 1',
                v_table
            )
            INTO v_match_id
            USING p_context_id, p_measurement_time;

            IF v_match_id IS NOT NULL THEN
                measurement_table := v_table;
                measurement_id := v_match_id;
                RETURN NEXT;
            END IF;
        EXCEPTION WHEN undefined_table THEN
            CONTINUE;
        END;
    END LOOP;

    RETURN;
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_alarm(
    IN  p_context_name VARCHAR(100),
    IN  p_measurement_time TIMESTAMP WITH TIME ZONE,
    IN  p_alarm_type VARCHAR(50),
    IN  p_severity SMALLINT,
    IN  p_rule_key VARCHAR(50),
    IN  p_status VARCHAR(20),
    IN  p_message VARCHAR(1000),
    IN  p_metadata JSONB,
    OUT p_alarm_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_context_id INT;
    v_source_name VARCHAR(100);
    v_measurement_refs JSONB;
BEGIN
    p_alarm_id := NULL;

    SELECT c.id, s.name
    INTO v_context_id, v_source_name
    FROM public.contexts c
    JOIN public.sources s ON s.id = c.source_id
    WHERE LOWER(c.name) = LOWER(p_context_name);

    IF v_context_id IS NULL THEN
        RAISE EXCEPTION 'Context not found: %', p_context_name;
    END IF;

    SELECT
        COALESCE(
            jsonb_agg(
                jsonb_build_object(
                    'table', r.measurement_table,
                    'id', r.measurement_id
                )
                ORDER BY r.measurement_table, r.measurement_id
            ),
            '[]'::jsonb
        ) AS refs
    INTO v_measurement_refs
    FROM public.resolve_measurement_ref(v_context_id, p_measurement_time) r;

    INSERT INTO public.alarms (
        context_id,
        source_name,
        measurement_time,
        measurement_refs,
        alarm_type,
        severity,
        status,
        rule_key,
        message,
        metadata
    )
    VALUES (
        v_context_id,
        COALESCE(v_source_name, ''),
        p_measurement_time,
        COALESCE(v_measurement_refs, '[]'::jsonb),
        UPPER(p_alarm_type),
        COALESCE(p_severity, 1),
        COALESCE(UPPER(p_status), 'OPEN'),
        p_rule_key,
        p_message,
        COALESCE(p_metadata, '{}'::jsonb)
    )
    RETURNING id INTO p_alarm_id;
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_alarm_contribution(
    IN p_alarm_id INT,
    IN p_contribution_kind VARCHAR(50),
    IN p_channel_name VARCHAR(100),
    IN p_contribution_value DOUBLE PRECISION,
    IN p_rank SMALLINT,
    IN p_is_primary_driver BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.alarm_contributions (
        alarm_id,
        contribution_kind,
        channel_name,
        contribution_value,
        rank,
        is_primary_driver
    )
    VALUES (
        p_alarm_id,
        UPPER(p_contribution_kind),
        p_channel_name,
        p_contribution_value,
        p_rank,
        COALESCE(p_is_primary_driver, FALSE)
    )
    ON CONFLICT (alarm_id, contribution_kind, channel_name)
    DO UPDATE SET
        contribution_value = EXCLUDED.contribution_value,
        rank = EXCLUDED.rank,
        is_primary_driver = EXCLUDED.is_primary_driver;
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_limit_alarm_detail(
    IN p_alarm_id INT,
    IN p_channel_name VARCHAR(100),
    IN p_measured_value DOUBLE PRECISION,
    IN p_lower_limit DOUBLE PRECISION,
    IN p_upper_limit DOUBLE PRECISION,
    IN p_breach_direction VARCHAR(10)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.limit_alarm_detail (
        alarm_id,
        channel_name,
        measured_value,
        lower_limit,
        upper_limit,
        breach_direction
    )
    VALUES (
        p_alarm_id,
        p_channel_name,
        p_measured_value,
        p_lower_limit,
        p_upper_limit,
        UPPER(p_breach_direction)
    )
    ON CONFLICT (alarm_id)
    DO UPDATE SET
        channel_name = EXCLUDED.channel_name,
        measured_value = EXCLUDED.measured_value,
        lower_limit = EXCLUDED.lower_limit,
        upper_limit = EXCLUDED.upper_limit,
        breach_direction = EXCLUDED.breach_direction;
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_iforest_alarm_detail(
    IN p_alarm_id INT,
    IN p_anomaly_score DOUBLE PRECISION,
    IN p_lower_threshold DOUBLE PRECISION,
    IN p_upper_threshold DOUBLE PRECISION,
    IN p_dif_score DOUBLE PRECISION,
    IN p_threshold DOUBLE PRECISION,
    IN p_is_anomaly BOOLEAN,
    IN p_model_name VARCHAR(200),
    IN p_model_version VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.iforest_alarm_detail (
        alarm_id,
        anomaly_score,
        lower_threshold,
        upper_threshold,
        dif_score,
        threshold,
        is_anomaly,
        model_name,
        model_version
    )
    VALUES (
        p_alarm_id,
        p_anomaly_score,
        p_lower_threshold,
        p_upper_threshold,
        p_dif_score,
        p_threshold,
        COALESCE(p_is_anomaly, FALSE),
        p_model_name,
        p_model_version
    )
    ON CONFLICT (alarm_id)
    DO UPDATE SET
        anomaly_score = EXCLUDED.anomaly_score,
        lower_threshold = EXCLUDED.lower_threshold,
        upper_threshold = EXCLUDED.upper_threshold,
        dif_score = EXCLUDED.dif_score,
        threshold = EXCLUDED.threshold,
        is_anomaly = EXCLUDED.is_anomaly,
        model_name = EXCLUDED.model_name,
        model_version = EXCLUDED.model_version;
END;
$$;


CREATE OR REPLACE PROCEDURE public.add_pca_alarm_detail(
    IN p_alarm_id INT,
    IN p_pc1 DOUBLE PRECISION,
    IN p_pc2 DOUBLE PRECISION,
    IN p_t2 DOUBLE PRECISION,
    IN p_dmodx DOUBLE PRECISION,
    IN p_pc_outside_95 BOOLEAN,
    IN p_pc_outside_99 BOOLEAN,
    IN p_t2_limit_95 DOUBLE PRECISION,
    IN p_t2_limit_99 DOUBLE PRECISION,
    IN p_dmodx_limit_95 DOUBLE PRECISION,
    IN p_dmodx_limit_99 DOUBLE PRECISION,
    IN p_model_path TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.pca_alarm_detail (
        alarm_id,
        pc1,
        pc2,
        t2,
        dmodx,
        pc_outside_95,
        pc_outside_99,
        t2_limit_95,
        t2_limit_99,
        dmodx_limit_95,
        dmodx_limit_99,
        model_path
    )
    VALUES (
        p_alarm_id,
        p_pc1,
        p_pc2,
        p_t2,
        p_dmodx,
        COALESCE(p_pc_outside_95, FALSE),
        COALESCE(p_pc_outside_99, FALSE),
        p_t2_limit_95,
        p_t2_limit_99,
        p_dmodx_limit_95,
        p_dmodx_limit_99,
        p_model_path
    )
    ON CONFLICT (alarm_id)
    DO UPDATE SET
        pc1 = EXCLUDED.pc1,
        pc2 = EXCLUDED.pc2,
        t2 = EXCLUDED.t2,
        dmodx = EXCLUDED.dmodx,
        pc_outside_95 = EXCLUDED.pc_outside_95,
        pc_outside_99 = EXCLUDED.pc_outside_99,
        t2_limit_95 = EXCLUDED.t2_limit_95,
        t2_limit_99 = EXCLUDED.t2_limit_99,
        dmodx_limit_95 = EXCLUDED.dmodx_limit_95,
        dmodx_limit_99 = EXCLUDED.dmodx_limit_99,
        model_path = EXCLUDED.model_path;
END;
$$;


CREATE OR REPLACE FUNCTION public.get_alarms(
    p_context_name VARCHAR(100) DEFAULT NULL,
    p_source_name VARCHAR(100) DEFAULT NULL,
    p_alarm_type VARCHAR(50) DEFAULT NULL,
    p_limit INT DEFAULT 200
)
RETURNS TABLE(
    alarm_id INT,
    context_name VARCHAR(100),
    source_name VARCHAR(100),
    measurement_time TIMESTAMP WITH TIME ZONE,
    alarm_type VARCHAR(50),
    severity SMALLINT,
    status VARCHAR(20),
    rule_key VARCHAR(50),
    message VARCHAR(1000),
    metadata JSONB,
    measurement_refs JSONB,
    triggered_at TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.id AS alarm_id,
        c.name AS context_name,
        a.source_name,
        a.measurement_time,
        a.alarm_type,
        a.severity,
        a.status,
        a.rule_key,
        a.message,
        a.metadata,
        a.measurement_refs,
        a.triggered_at
    FROM public.alarms a
    JOIN public.contexts c ON c.id = a.context_id
    WHERE
        (p_context_name IS NULL OR LOWER(c.name) = LOWER(p_context_name))
        AND (p_source_name IS NULL OR LOWER(a.source_name) = LOWER(p_source_name))
        AND (p_alarm_type IS NULL OR UPPER(a.alarm_type) = UPPER(p_alarm_type))
    ORDER BY a.triggered_at DESC
    LIMIT COALESCE(NULLIF(p_limit, 0), 200);
END;
$$;


CREATE OR REPLACE FUNCTION public.get_alarm_contributions(
    p_alarm_id INT
)
RETURNS TABLE(
    contribution_kind VARCHAR(50),
    channel_name VARCHAR(100),
    contribution_value DOUBLE PRECISION,
    rank SMALLINT,
    is_primary_driver BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        ac.contribution_kind,
        ac.channel_name,
        ac.contribution_value,
        ac.rank,
        ac.is_primary_driver
    FROM public.alarm_contributions ac
    WHERE ac.alarm_id = p_alarm_id
    ORDER BY ac.contribution_kind, ac.rank NULLS LAST, ac.channel_name;
END;
$$;


-- =====================================================
-- Project: ALIGN E-Learning Data Engineering
-- File: 06_streams.sql
-- Description: Change Data Capture (CDC)
-- =====================================================

USE WAREHOUSE COMPUTE_WH;
USE DATABASE TECHINNOV_DB;
USE SCHEMA PUBLIC;

-- Create a staging table for incremental records

CREATE TABLE IF NOT EXISTS PUBLIC.NEW_ATTEMPTS
LIKE PUBLIC.FACT_LEARNINGATTEMPT;

-- Create a standard stream to capture data changes

CREATE STREAM IF NOT EXISTS PUBLIC.STREAM_NEW_ATTEMPTS
ON TABLE PUBLIC.NEW_ATTEMPTS;

-- Validate stream creation

SHOW STREAMS IN SCHEMA TECHINNOV_DB.PUBLIC;

-- Inspect captured changes

SELECT
    ATTEMPTID,
    FINALSCORE,
    METADATA$ACTION,
    METADATA$ISUPDATE,
    METADATA$ROW_ID
FROM PUBLIC.STREAM_NEW_ATTEMPTS;

-- Check whether incremental data is available

SELECT SYSTEM$STREAM_HAS_DATA(
    'TECHINNOV_DB.PUBLIC.STREAM_NEW_ATTEMPTS'
);


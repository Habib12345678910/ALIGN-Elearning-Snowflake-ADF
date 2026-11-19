
-- =====================================================
-- Project: ALIGN E-Learning Data Engineering
-- File: 07_merge_incremental.sql
-- Description: Incremental ELT using CDC and MERGE
-- =====================================================

USE WAREHOUSE COMPUTE_WH;
USE DATABASE TECHINNOV_DB;

-- Process new and updated learning attempts

MERGE INTO SILVER.FACT_LEARNINGATTEMPT T

USING (

    SELECT
        * EXCLUDE (
            METADATA$ACTION,
            METADATA$ISUPDATE,
            METADATA$ROW_ID
        ),

        FINALSCORE - INITIALSCORE AS SCORE_IMPROVEMENT

    FROM PUBLIC.STREAM_NEW_ATTEMPTS

    -- Apply data quality rules

    WHERE METADATA$ACTION = 'INSERT'
      AND INITIALSCORE BETWEEN 0 AND 100
      AND FINALSCORE BETWEEN 0 AND 100
      AND ATTEMPTNUMBER >= 1

) S

-- Match records using the business identifier

ON T.ATTEMPTID = S.ATTEMPTID

-- Update existing records

WHEN MATCHED THEN
    UPDATE ALL BY NAME

-- Insert new records

WHEN NOT MATCHED THEN
    INSERT ALL BY NAME;


-- =====================================================
-- POST-LOAD VALIDATION
-- =====================================================

-- Validate total records

SELECT COUNT(*) AS TOTAL_RECORDS
FROM SILVER.FACT_LEARNINGATTEMPT;

-- Detect duplicate records

SELECT ATTEMPTID, COUNT(*) AS DUPLICATE_COUNT
FROM SILVER.FACT_LEARNINGATTEMPT
GROUP BY ATTEMPTID
HAVING COUNT(*) > 1;

-- Check remaining stream records

SELECT *
FROM PUBLIC.STREAM_NEW_ATTEMPTS;

-- Validate analytical results

SELECT *
FROM GOLD.V_KPI_GLOBAL;


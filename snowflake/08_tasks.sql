
-- =====================================================
-- Project: ALIGN E-Learning Data Engineering
-- File: 08_tasks.sql
-- Description: Automated incremental data processing
-- =====================================================

USE WAREHOUSE COMPUTE_WH;
USE DATABASE TECHINNOV_DB;

-- Create a scheduled incremental processing task

CREATE TASK IF NOT EXISTS PUBLIC.TASK_LOAD_SILVER

    WAREHOUSE = COMPUTE_WH

    SCHEDULE = '5 MINUTE'

WHEN

    SYSTEM$STREAM_HAS_DATA(
        'TECHINNOV_DB.PUBLIC.STREAM_NEW_ATTEMPTS'
    )

AS

MERGE INTO TECHINNOV_DB.SILVER.FACT_LEARNINGATTEMPT T

USING (

    SELECT
        * EXCLUDE (
            METADATA$ACTION,
            METADATA$ISUPDATE,
            METADATA$ROW_ID
        ),

        FINALSCORE - INITIALSCORE AS SCORE_IMPROVEMENT

    FROM TECHINNOV_DB.PUBLIC.STREAM_NEW_ATTEMPTS

    WHERE METADATA$ACTION = 'INSERT'
      AND INITIALSCORE BETWEEN 0 AND 100
      AND FINALSCORE BETWEEN 0 AND 100
      AND ATTEMPTNUMBER >= 1

) S

ON T.ATTEMPTID = S.ATTEMPTID

WHEN MATCHED THEN
    UPDATE ALL BY NAME

WHEN NOT MATCHED THEN
    INSERT ALL BY NAME;


-- =====================================================
-- TASK ADMINISTRATION
-- =====================================================

-- Enable task execution when required

-- ALTER TASK PUBLIC.TASK_LOAD_SILVER RESUME;

-- Inspect task configuration

SHOW TASKS IN SCHEMA TECHINNOV_DB.PUBLIC;


-- Monitor execution history

SELECT
    NAME,
    STATE,
    SCHEDULED_TIME,
    COMPLETED_TIME,
    ERROR_MESSAGE

FROM TABLE(
    TECHINNOV_DB.INFORMATION_SCHEMA.TASK_HISTORY(
        TASK_NAME => 'TASK_LOAD_SILVER',
        RESULT_LIMIT => 10
    )
)

ORDER BY SCHEDULED_TIME DESC;


-- Suspend the task when using ADF orchestration

ALTER TASK PUBLIC.TASK_LOAD_SILVER SUSPEND;


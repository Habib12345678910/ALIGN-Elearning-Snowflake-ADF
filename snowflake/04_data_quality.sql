
-- =====================================================
-- Project: ALIGN E-Learning Data Engineering
-- File: 04_data_quality.sql
-- Description: Data quality and validation checks
-- =====================================================

USE WAREHOUSE COMPUTE_WH;
USE DATABASE TECHINNOV_DB;
USE SCHEMA SILVER;

-- =====================================================
-- 1. COMPLETENESS CHECK
-- Detect missing mandatory values
-- =====================================================

SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT_IF(ATTEMPTID IS NULL) AS NULL_ATTEMPT_ID,
    COUNT_IF(USERKEY IS NULL) AS NULL_USER_KEY,
    COUNT_IF(MODULEKEY IS NULL) AS NULL_MODULE_KEY,
    COUNT_IF(DATEKEY IS NULL) AS NULL_DATE_KEY,
    COUNT_IF(CONTENTTYPEKEY IS NULL) AS NULL_CONTENT_TYPE,
    COUNT_IF(INITIALSCORE IS NULL) AS NULL_INITIAL_SCORE,
    COUNT_IF(FINALSCORE IS NULL) AS NULL_FINAL_SCORE
FROM SILVER.FACT_LEARNINGATTEMPT;


-- =====================================================
-- 2. UNIQUENESS CHECK
-- Detect duplicate learning attempts
-- =====================================================

SELECT
    ATTEMPTID,
    COUNT(*) AS DUPLICATE_COUNT
FROM SILVER.FACT_LEARNINGATTEMPT
GROUP BY ATTEMPTID
HAVING COUNT(*) > 1;


-- =====================================================
-- 3. DATA VALIDITY CHECK
-- Validate learning scores and attempt numbers
-- =====================================================

SELECT *
FROM SILVER.FACT_LEARNINGATTEMPT
WHERE INITIALSCORE NOT BETWEEN 0 AND 100
   OR FINALSCORE NOT BETWEEN 0 AND 100
   OR ATTEMPTNUMBER < 1
   OR ATTEMPTNUMBER IS NULL;


-- Inspect minimum and maximum score values

SELECT
    MIN(INITIALSCORE) AS MIN_INITIAL_SCORE,
    MAX(INITIALSCORE) AS MAX_INITIAL_SCORE,
    MIN(FINALSCORE) AS MIN_FINAL_SCORE,
    MAX(FINALSCORE) AS MAX_FINAL_SCORE
FROM SILVER.FACT_LEARNINGATTEMPT;


-- =====================================================
-- 4. REFERENTIAL INTEGRITY CHECK
-- Detect invalid foreign keys
-- =====================================================

-- Validate UserKey

SELECT COUNT(*) AS INVALID_USER_KEYS
FROM SILVER.FACT_LEARNINGATTEMPT F
LEFT JOIN SILVER.DIM_USER U
    ON F.USERKEY = U.USERKEY
WHERE U.USERKEY IS NULL;


-- Validate ModuleKey

SELECT COUNT(*) AS INVALID_MODULE_KEYS
FROM SILVER.FACT_LEARNINGATTEMPT F
LEFT JOIN SILVER.DIM_MODULE M
    ON F.MODULEKEY = M.MODULEKEY
WHERE M.MODULEKEY IS NULL;


-- Validate DateKey

SELECT COUNT(*) AS INVALID_DATE_KEYS
FROM SILVER.FACT_LEARNINGATTEMPT F
LEFT JOIN SILVER.DIM_DATE D
    ON F.DATEKEY = D.DATEKEY
WHERE D.DATEKEY IS NULL;


-- Validate ContentTypeKey
-- Cast raw dimension values and ignore the CSV header row

SELECT COUNT(*) AS INVALID_CONTENT_TYPE_KEYS
FROM SILVER.FACT_LEARNINGATTEMPT F
LEFT JOIN (
    SELECT DISTINCT TRY_TO_NUMBER(C1) AS CONTENTTYPEKEY
    FROM SILVER.DIM_CONTENT_TYPE
    WHERE TRY_TO_NUMBER(C1) IS NOT NULL
) C
    ON F.CONTENTTYPEKEY = C.CONTENTTYPEKEY
WHERE C.CONTENTTYPEKEY IS NULL;


-- =====================================================
-- 5. BUSINESS CONSISTENCY CHECK
-- Validate score improvement calculation
-- =====================================================

SELECT
    ATTEMPTID,
    INITIALSCORE,
    FINALSCORE,
    SCORE_IMPROVEMENT
FROM SILVER.FACT_LEARNINGATTEMPT
WHERE SCORE_IMPROVEMENT IS NULL
   OR ABS(
       SCORE_IMPROVEMENT -
       (FINALSCORE - INITIALSCORE)
   ) > 0.000001;


-- =====================================================
-- 6. DATA RECONCILIATION
-- Compare source and target record counts
-- =====================================================

SELECT
    'BRONZE' AS DATA_LAYER,
    COUNT(*) AS TOTAL_RECORDS
FROM PUBLIC.FACT_LEARNINGATTEMPT

UNION ALL

SELECT
    'SILVER' AS DATA_LAYER,
    COUNT(*) AS TOTAL_RECORDS
FROM SILVER.FACT_LEARNINGATTEMPT;


-- =====================================================
-- 7. GLOBAL BUSINESS VALIDATION
-- Validate the main learning indicators
-- =====================================================

SELECT
    COUNT(*) AS TOTAL_ATTEMPTS,
    COUNT(DISTINCT USERKEY) AS TOTAL_USERS,
    COUNT(DISTINCT MODULEKEY) AS TOTAL_MODULES,
    ROUND(AVG(INITIALSCORE), 2) AS AVG_INITIAL_SCORE,
    ROUND(AVG(FINALSCORE), 2) AS AVG_FINAL_SCORE,
    ROUND(AVG(SCORE_IMPROVEMENT), 2) AS AVG_IMPROVEMENT
FROM SILVER.FACT_LEARNINGATTEMPT;


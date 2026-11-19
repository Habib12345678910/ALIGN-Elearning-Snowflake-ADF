
-- =====================================================
-- Project: ALIGN E-Learning Data Engineering
-- File: 05_gold_layer.sql
-- Description: Business KPIs and analytical views
-- =====================================================

USE WAREHOUSE COMPUTE_WH;
USE DATABASE TECHINNOV_DB;

CREATE SCHEMA IF NOT EXISTS TECHINNOV_DB.GOLD;


-- =====================================================
-- 1. GLOBAL LEARNING PERFORMANCE VIEW
-- Calculate overall learning performance indicators
-- =====================================================

CREATE OR REPLACE VIEW GOLD.V_KPI_GLOBAL AS

SELECT
    COUNT(*) AS TOTAL_ATTEMPTS,
    COUNT(DISTINCT USERKEY) AS TOTAL_USERS,
    COUNT(DISTINCT MODULEKEY) AS TOTAL_MODULES,

    ROUND(AVG(INITIALSCORE), 2) AS AVG_INITIAL_SCORE,

    ROUND(AVG(FINALSCORE), 2) AS AVG_FINAL_SCORE,

    ROUND(AVG(SCORE_IMPROVEMENT), 2) AS AVG_IMPROVEMENT

FROM SILVER.FACT_LEARNINGATTEMPT;


-- =====================================================
-- 2. MODULE PERFORMANCE VIEW
-- Calculate learning KPIs at module level
-- =====================================================

CREATE OR REPLACE VIEW GOLD.V_KPI_MODULE AS

SELECT
    M.MODULEKEY,
    M.MODULENAME,
    M.CATEGORY,
    M.DIFFICULTY,
    M.PASSINGSCORE,

    -- Total number of learning attempts

    COUNT(*) AS TOTAL_ATTEMPTS,

    -- Number of unique learners

    COUNT(DISTINCT F.USERKEY) AS TOTAL_USERS,

    -- Average learning scores

    ROUND(AVG(F.INITIALSCORE), 2) AS AVG_INITIAL_SCORE,

    ROUND(AVG(F.FINALSCORE), 2) AS AVG_FINAL_SCORE,

    -- Average learning improvement

    ROUND(AVG(F.SCORE_IMPROVEMENT), 2) AS AVG_IMPROVEMENT,

    -- Number of successful attempts

    SUM(CASE
        WHEN F.FINALSCORE >= M.PASSINGSCORE
        THEN 1 ELSE 0
    END) AS SUCCESSFUL_ATTEMPTS,

    -- Calculate pass rate as a percentage
    -- NULLIF prevents division by zero

    ROUND(
        100.0 * SUM(CASE
            WHEN F.FINALSCORE >= M.PASSINGSCORE
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0),
        2
    ) AS PASS_RATE

FROM SILVER.FACT_LEARNINGATTEMPT F

INNER JOIN SILVER.DIM_MODULE M
    ON F.MODULEKEY = M.MODULEKEY

GROUP BY
    M.MODULEKEY,
    M.MODULENAME,
    M.CATEGORY,
    M.DIFFICULTY,
    M.PASSINGSCORE;


-- =====================================================
-- 3. GOLD LAYER VALIDATION
-- =====================================================

SHOW VIEWS IN SCHEMA TECHINNOV_DB.GOLD;


-- Validate global KPIs

SELECT *
FROM GOLD.V_KPI_GLOBAL;


-- Rank modules by pass rate

SELECT *
FROM GOLD.V_KPI_MODULE
ORDER BY PASS_RATE DESC;


-- Identify modules with learning difficulties

SELECT
    MODULENAME,
    CATEGORY,
    PASS_RATE,
    AVG_IMPROVEMENT
FROM GOLD.V_KPI_MODULE
ORDER BY PASS_RATE ASC;


-- Rank modules by learning improvement

SELECT
    MODULENAME,
    AVG_INITIAL_SCORE,
    AVG_FINAL_SCORE,
    AVG_IMPROVEMENT
FROM GOLD.V_KPI_MODULE
ORDER BY AVG_IMPROVEMENT DESC;


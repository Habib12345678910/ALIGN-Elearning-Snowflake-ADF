
-- =====================================================
-- Project: ALIGN E-Learning Data Engineering
-- File: 01_create_database.sql
-- Description: Snowflake environment initialization
-- =====================================================

-- Select administrative role
USE ROLE ACCOUNTADMIN;

-- Create the virtual warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE COMPUTE_WH;

-- Create the project database
CREATE DATABASE IF NOT EXISTS TECHINNOV_DB;

USE DATABASE TECHINNOV_DB;

-- Bronze Layer: Raw data
CREATE SCHEMA IF NOT EXISTS PUBLIC;

-- Silver Layer: Cleaned and transformed data
CREATE SCHEMA IF NOT EXISTS SILVER;

-- Gold Layer: Business KPIs and reporting
CREATE SCHEMA IF NOT EXISTS GOLD;

-- Validate the environment
SHOW SCHEMAS IN DATABASE TECHINNOV_DB;

SELECT
    CURRENT_DATABASE(),
    CURRENT_WAREHOUSE(),
    CURRENT_ROLE();


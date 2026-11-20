
# Azure Data Factory - Pipeline Orchestration

## Overview

Azure Data Factory is used as an orchestration
component for the ALIGN E-Learning ELT solution.

The data transformation logic is implemented
directly in Snowflake using SQL.

## Architecture

- Azure Data Factory
- Snowflake Cloud Data Warehouse
- Snowflake Linked Service
- Snowflake Streams
- Incremental MERGE
- Gold analytical views
- Power BI

## Orchestration Design

1. Connect to Snowflake.
2. Detect incremental data changes.
3. Execute SQL transformation logic.
4. Merge new and updated records into Silver.
5. Validate data quality.
6. Monitor pipeline execution.
7. Make updated data available to Gold views.

## Monitoring

Pipeline monitoring includes:

- Execution status
- Start and end time
- Activity duration
- Error messages
- Data validation results

## Scheduling

Two orchestration approaches are supported
by the project design:

- Native Snowflake Tasks
- Azure Data Factory orchestration

Only one approach should consume the same
Snowflake Stream at a time.

## Security

Credentials and private keys are excluded
from this public repository.

Production environments should use secure
authentication and least-privilege access.

## Project Scope

This is a portfolio implementation inspired
by the ALIGN adaptive learning initiative
at Techinnov.


# Snowflake Data Model – ALIGN E-Learning

## 1. Overview

The ALIGN E-Learning project uses a dimensional data model to analyze learner performance, engagement, and learning progress.

The analytical data is organized into a Snowflake Medallion architecture:

- **Bronze:** Raw learning data.
- **Silver:** Cleaned and structured analytical tables.
- **Gold:** Business KPI views for reporting.

## 2. Fact Table

### FACT_LEARNINGATTEMPT

The central fact table contains learning attempt records.

Each record represents a learning attempt and its associated performance metrics.

Key analytical attributes include:

- Learning attempt identifier
- Learner identifier
- Module identifier
- Initial score
- Final score
- Score improvement
- Attempt number
- Learning activity date

**Records in the validated dataset:** 2,550.

## 3. Dimension Tables

| Dimension | Description |
|---|---|
| DIM_USER | Learner information |
| DIM_MODULE | Learning modules |
| DIM_DATE | Calendar attributes for time-based analysis |
| DIM_QUESTION | Assessment questions |
| DIM_CONCEPT | Learning concepts |
| DIM_CONTENT_TYPE | Learning content categories |

## 4. Dimensional Modeling

The model supports analytical queries that combine learning attempts with descriptive dimensions.

Typical analytical relationships include:

- Learning attempts to learners
- Learning attempts to learning modules
- Learning attempts to calendar dates

Additional relationships involving questions, concepts, and content types depend on the available foreign keys and table structure.

## 5. Business Metrics

The model supports the calculation of:

- Average initial score
- Average final score
- Average score improvement
- Number of learning attempts
- Number of learners
- Performance by learning module

## 6. Data Quality

The ELT process includes validation of:

- Duplicate attempt identifiers
- Missing mandatory keys
- Invalid score values
- Invalid attempt numbers
- Inconsistent score improvement calculations

## 7. Reporting

Snowflake Gold views provide aggregated metrics for analytical consumption.

Examples:

- `GOLD.V_KPI_GLOBAL`
- `GOLD.V_KPI_MODULE`

Power BI is the intended visualization layer for interactive reporting.

## 8. Conclusion

This dimensional model provides a structured analytical foundation for monitoring learner performance and supporting educational decision-making.

# Business KPIs – ALIGN E-Learning Analytics

## 1. Project Overview

The ALIGN E-Learning Analytics project focuses on monitoring learner performance, measuring knowledge improvement, and supporting data-driven educational decisions.

The solution uses Snowflake for data processing and analytical aggregations, Azure Data Factory for ELT orchestration, and Power BI as the intended reporting layer.

This portfolio implementation is based on an adaptive learning analytics use case.

## 2. Business Objectives

The main objectives are:

- Monitor learner performance across learning modules.
- Measure knowledge improvement between initial and final assessments.
- Identify modules requiring educational improvements.
- Analyze learner participation and learning activity.
- Provide reliable KPIs for reporting and decision-making.

## 3. Global Business KPIs

The following results were obtained from the Snowflake analytical dataset.

| KPI | Value | Business Meaning |
|---|---:|---|
| Total Learning Attempts | 2,550 | Number of learning attempts |
| Total Learners | 200 | Number of distinct learners |
| Total Modules | 12 | Number of learning modules |
| Average Initial Score | 63.88 | Average score before learning |
| Average Final Score | 72.80 | Average score after learning |
| Average Score Improvement | +8.92 | Average improvement in score points |

These metrics provide an overall view of learning performance.

## 4. KPI Definitions

### KPI 1 – Total Learning Attempts

**Business definition:** Total number of learning attempts recorded in the analytical dataset.

**Formula:**

Total Learning Attempts = COUNT(Learning Attempts)

**SQL example:**

```sql
SELECT COUNT(*) AS TOTAL_ATTEMPTS
FROM TECHINNOV_DB.SILVER.FACT_LEARNINGATTEMPT;
```

**Business value:** Measures learning activity volume and supports participation analysis.

### KPI 2 – Total Learners

**Business definition:** Number of distinct learners represented in the learning attempt dataset.

**Formula:**

Total Learners = COUNT(DISTINCT Learner ID)

**Business value:** Measures the number of learners participating in recorded learning activities.

### KPI 3 – Total Modules

**Business definition:** Number of learning modules available in the module dimension.

**Formula:**

Total Modules = COUNT(Module Records)

**SQL example:**

```sql
SELECT COUNT(*) AS TOTAL_MODULES
FROM TECHINNOV_DB.SILVER.DIM_MODULE;
```

**Business value:** Measures the size of the learning module catalog.

### KPI 4 – Average Initial Score

**Business definition:** Average learner assessment score before completing a learning activity.

**Formula:**

Average Initial Score = SUM(Initial Scores) / Number of Valid Scores

**Business value:** Helps assess learners' initial knowledge levels.

### KPI 5 – Average Final Score

**Business definition:** Average assessment score after the learning activity.

**Formula:**

Average Final Score = SUM(Final Scores) / Number of Valid Scores

**Business value:** Measures overall performance after learning.

### KPI 6 – Average Score Improvement

**Business definition:** Average difference between final and initial assessment scores.

**Formula:**

Score Improvement = Final Score - Initial Score

Average Score Improvement = AVG(Score Improvement)

**Observed result:** +8.92 score points.

**Business value:** Helps evaluate knowledge progression across learning activities.

## 5. Gold Layer – Analytical Views

The Snowflake Gold layer provides aggregated metrics through analytical SQL views.

### V_KPI_GLOBAL

This view summarizes the overall performance of the e-learning platform.

```sql
SELECT *
FROM TECHINNOV_DB.GOLD.V_KPI_GLOBAL;
```

It provides global indicators such as learning attempts, learners, modules, and assessment scores.

### V_KPI_MODULE

This view supports performance analysis at the module level.

```sql
SELECT *
FROM TECHINNOV_DB.GOLD.V_KPI_MODULE;
```

It enables comparisons between learning modules and helps identify areas requiring additional attention.

## 6. Business Analysis

### Overall Learning Performance

The average initial score was 63.88, compared with an average final score of 72.80.

This represents an average improvement of 8.92 score points.

The observed improvement suggests positive learning progression within the analyzed dataset. It does not, by itself, establish that the learning activities caused the improvement.

### Learner Participation

The dataset contains 2,550 learning attempts and 200 distinct learners.

These figures support analysis of learning activity volume and learner participation.

### Module Performance

The module-level Gold view can be used to compare:

- Average initial scores by module.
- Average final scores by module.
- Average score improvement by module.
- Number of learning attempts per module.

## 7. Data Quality and KPI Reliability

Before using the analytical results, the ELT pipeline performs data quality checks.

Validation rules include:

- Detecting duplicate learning attempt identifiers.
- Checking mandatory identifiers.
- Validating assessment score ranges.
- Checking attempt numbers.
- Verifying score improvement calculations.

These checks help improve the reliability of business KPIs.

## 8. Power BI Reporting

Power BI is the intended reporting and visualization layer.

The planned analytical dashboard includes:

- KPI cards for global learning performance.
- Module performance comparisons.
- Initial versus final score analysis.
- Learning activity trends.
- Filters by learner, module, and date.

**Reporting status:** Power BI data connectivity and query preparation have been explored; the final dashboard remains in progress.

## 9. Technologies

- Snowflake
- Snowflake SQL
- Azure Data Factory
- ELT Pipelines
- Dimensional Data Modeling
- Data Quality Validation
- Power BI

## 10. Conclusion

The ALIGN E-Learning Analytics portfolio project demonstrates how a modern data engineering architecture can transform learning activity data into actionable business indicators.

By combining Snowflake, Azure Data Factory, SQL transformations, and analytical reporting, the project illustrates an end-to-end approach to educational data analytics.

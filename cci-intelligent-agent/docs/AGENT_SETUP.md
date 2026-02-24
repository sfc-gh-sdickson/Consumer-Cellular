# Consumer Cellular Intelligence Agent - Setup Guide

## Prerequisites

- Snowflake account with ACCOUNTADMIN or appropriate privileges
- Access to Cortex AI features
- Warehouse with sufficient compute resources

## Step 1: Database and Schema Setup

Run the setup scripts in order:

```bash
# Execute from Snowflake worksheet or CLI
snowsql -f sql/setup/01_database_and_schema.sql
snowsql -f sql/setup/02_create_tables.sql
```

This creates:
- **CCI_INTELLIGENCE** database
- **RAW** schema (source data)
- **ANALYTICS** schema (views and agent)
- **CCI_WH** warehouse (X-Small, auto-suspend 5 min)

## Step 2: Load Synthetic Data

```bash
snowsql -f sql/data/03_generate_synthetic_data.sql
```

Generates:
- 5,000 customers
- 10 service plans
- 50,000+ usage records
- 50,000+ billing records
- Support tickets, feedback, and ML predictions

## Step 3: Create Analytics Views

```bash
snowsql -f sql/views/04_create_views.sql
snowsql -f sql/views/05_create_semantic_views.sql
```

Views created:
| View | Purpose |
|------|---------|
| CUSTOMER_360 | Unified customer profile |
| MONTHLY_REVENUE_SUMMARY | Revenue aggregations |
| SUPPORT_ANALYTICS | Ticket metrics |
| USAGE_PATTERNS | Data/voice usage trends |
| CHURN_RISK_DASHBOARD | At-risk customer segments |
| PLAN_PERFORMANCE | Plan-level metrics |
| CUSTOMER_HEALTH_SCORE | Composite health metric |

## Step 4: Create Cortex Search Service

```bash
snowsql -f sql/search/06_create_cortex_search.sql
```

Creates `CCI_KNOWLEDGE_SEARCH` for semantic search over knowledge base articles.

## Step 5: Deploy ML Model Functions

```bash
snowsql -f sql/models/07_ml_model_functions.sql
```

Functions:
- `PREDICT_CHURN()` - Churn probability scoring
- `CALCULATE_LTV()` - Lifetime value prediction
- `RECOMMEND_PLAN()` - Plan optimization
- `CALCULATE_HEALTH_SCORE()` - Customer health composite

## Step 6: Create the Agent

```bash
snowsql -f sql/agent/08_create_financial_agent.sql
```

Creates `CCI_FINANCIAL_AGENT` with:
- Semantic view for structured queries
- Knowledge base search for support content
- Claude 3.5 Sonnet as the base model

## Step 7: Verify Deployment

```sql
-- Check agent exists
SHOW CORTEX AGENTS IN SCHEMA CCI_INTELLIGENCE.ANALYTICS;

-- Test a query
SELECT CCI_INTELLIGENCE.ANALYTICS.CCI_FINANCIAL_AGENT(
  'What is the average customer lifetime value by segment?'
);
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Agent not responding | Verify warehouse is running |
| Missing data | Re-run 03_generate_synthetic_data.sql |
| Search not working | Check CCI_KNOWLEDGE_SEARCH service status |
| Permission errors | Ensure ACCOUNTADMIN or proper grants |

## Next Steps

1. Review `questions.md` for test queries
2. Customize the system prompt for your use case
3. Add additional data sources as needed

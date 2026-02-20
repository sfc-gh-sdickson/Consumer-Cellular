# Consumer Cellular Intelligence Agent (CCI)

A Snowflake Cortex Agent project for Consumer Cellular customer service and business intelligence.

## Project Structure

```
Consumer-Cellular/
├── sql/
│   └── setup/
│       ├── 01_database_and_schema.sql   # Database, schemas, warehouse
│       ├── 02_create_tables.sql          # Table definitions
│       ├── 03_generate_synthetic_data.sql # Synthetic test data
│       ├── 04_create_views.sql           # Analytical views
│       ├── 05_create_semantic_views.sql  # Semantic views for Cortex Analyst
│       ├── 06_create_cortex_search.sql   # Cortex Search services
│       ├── 07_ml_model_functions.sql     # UDF functions for agent
│       └── 08_create_cci_agent.sql       # Cortex Agent definition
└── README.md
```

## Deployment Order

Run SQL files in numbered order:
1. `01_database_and_schema.sql` - Creates CCI_INTELLIGENCE database
2. `02_create_tables.sql` - Creates all tables
3. `03_generate_synthetic_data.sql` - Loads test data
4. `04_create_views.sql` - Creates analytical views
5. `05_create_semantic_views.sql` - Creates semantic view
6. `06_create_cortex_search.sql` - Creates search services
7. `07_ml_model_functions.sql` - Creates UDF functions
8. `08_create_cci_agent.sql` - Creates the agent

## Agent Capabilities

- Customer lookup and 360-degree view
- Billing history and dispute resolution
- Knowledge base search
- Plan recommendations
- Churn risk analysis
- Revenue analytics

## Sample Queries

```
"Look up customer CUS000001"
"What are the top 10 high-risk churn customers?"
"How do I set up voicemail?"
"Show me revenue for the last 6 months"
"Recommend a plan for customer CUS000050"
```

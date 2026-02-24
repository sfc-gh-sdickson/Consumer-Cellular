# Snowflake Intelligence Agent Project Template

## Purpose
This document provides a complete template for creating a Snowflake Intelligence Agent project for any customer. It includes the project structure, file templates, naming conventions, and critical lessons learned.

## Customer details
Consumer Cellular is an American Mobile Virtual Network Operator (MVNO) that provides no-contract, affordable cellphone plans and devices, with a specific focus on users over the age of 50. Founded in 1995, it operates as an AARP partner and utilizes major networks like AT&T and T-Mobile.

---

## Customer Configuration

**To create a new project, replace these variables throughout:**

| Variable | Description | Example (GoDaddy) |
|----------|-------------|-------------------|
| `{CUSTOMER_NAME}` | Customer name | Consumer Cellular |
| `{CUSTOMER_NAME_UPPER}` | Uppercase for SQL objects | CCI |
| `{DATABASE_NAME}` | Main database name | CCI_INTELLIGENCE |
| `{WAREHOUSE_NAME}` | Warehouse name | CCI_WH |
| `{AGENT_NAME}` | Agent identifier | CCI_AGENT |
| `{BUSINESS_DOMAIN}` | Customer's business focus | Domain registration, hosting, customer support |
| `{WEB_PRESENCE}`  | Web Address | https://www.consumercellular.com/

---

## Project Structure

```
/
├── README.md                              # Project overview with SVG diagrams
├── Snowflake_Logo.svg                     # Snowflake branding logo
├── agent.md                               # This template file
├── docs/
│   ├── AGENT_SETUP.md                     # Step-by-step agent configuration guide
│   ├── DEPLOYMENT_SUMMARY.md              # Current deployment status with SVG diagrams
│   ├── questions.md                       # 50+ complex test questions
│   └── images/
│       ├── architecture.svg               # System architecture diagram
│       ├── deployment_flow.svg            # Deployment workflow diagram
│       ├── ml_models.svg                  # ML pipeline visualization
│       └── project_structure.svg          # Project file structure diagram
├── notebooks/
│   └── ml_financial_models.ipynb          # ML model training notebook
└── sql/
    ├── setup/
    │   ├── 01_database_and_schema.sql     # Database, schemas, warehouse
    │   └── 02_create_tables.sql           # All table definitions
    ├── data/
    │   └── 03_generate_synthetic_data.sql # Test data generation
    ├── views/
    │   ├── 04_create_views.sql            # Analytical views
    │   └── 05_create_semantic_views.sql   # Semantic views for Cortex Analyst
    ├── search/
    │   └── 06_create_cortex_search.sql    # Cortex Search services
    ├── models/
    │   └── 07_ml_model_functions.sql      # ML prediction UDFs
    └── agent/
        └── 08_create_financial_agent.sql  # Agent creation script
```

---

## File Execution Order

**MUST be executed in this exact order:**

1. `sql/setup/01_database_and_schema.sql`
2. `sql/setup/02_create_tables.sql`
3. `sql/data/03_generate_synthetic_data.sql`
4. `sql/views/04_create_views.sql`
5. `sql/views/05_create_semantic_views.sql`
6. `sql/search/06_create_cortex_search.sql`
7. `notebooks/ml_financial_models.ipynb` (Optional - run in Snowflake Notebooks)
8. `sql/models/07_ml_model_functions.sql`
9. `sql/agent/08_create_financial_agent.sql`

---

## MANDATORY Documentation Requirements

### README.md MUST Include:
- Snowflake logo at the top: `![Snowflake](Snowflake_Logo.svg)`
- Architecture diagram: `![System Architecture](docs/images/architecture.svg)`
- Project structure diagram: `![Project Structure](docs/images/project_structure.svg)`
- Deployment workflow diagram: `![Deployment Workflow](docs/images/deployment_flow.svg)`
- ML models diagram: `![ML Pipeline](docs/images/ml_models.svg)`
- Quick start instructions
- Usage examples
- Links to documentation files

### DEPLOYMENT_SUMMARY.md MUST Include:
- Architecture diagram reference
- Deployment workflow diagram reference
- ML models diagram reference
- Tables showing all SQL scripts and their status
- Data model relationships
- Resource requirements

### questions.md MUST Include:
- At least 50 test questions organized by category
- Customer analytics questions
- Revenue and billing questions
- Churn and retention questions
- Support and satisfaction questions
- Complex multi-part questions
- Knowledge base questions

---

## MANDATORY SVG Image Requirements

### CRITICAL: NEVER use text-based graphics (ASCII art, code blocks with tree structures)
### ALWAYS create proper SVG images for:
- Architecture diagrams
- Deployment workflows
- ML model pipelines
- Project structure

### SVG Technical Requirements:

1. **Use compatible shadow filters:**
```xml
<filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
  <feGaussianBlur in="SourceAlpha" stdDeviation="3" result="blur"/>
  <feOffset in="blur" dx="2" dy="2" result="offsetBlur"/>
  <feFlood flood-color="#000000" flood-opacity="0.2" result="color"/>
  <feComposite in="color" in2="offsetBlur" operator="in" result="shadow"/>
  <feMerge>
    <feMergeNode in="shadow"/>
    <feMergeNode in="SourceGraphic"/>
  </feMerge>
</filter>
```

2. **DO NOT use feDropShadow** - causes encoding errors

3. **DO NOT use Unicode characters** (checkmarks, special symbols) - causes btoa encoding errors

4. **Ensure viewBox is large enough** - expand height to fit ALL content, do not cut off elements

5. **Element positioning:**
   - Numbered circles must be ABOVE or BESIDE description boxes, NEVER underneath
   - Elements must NOT overlap - calculate positions carefully
   - Leave adequate spacing between parallel elements

6. **Add shadows to ALL boxes** using the compatible filter above

### architecture.svg MUST Include:
- Business Users layer at top
- Agent box (DO NOT include specific model names like "Claude 3.5 Sonnet")
- Three tool boxes: ANALYST_TOOL, SEARCH_TOOL, ML FUNCTIONS
- Semantic View and Search Service boxes
- ML Functions detail box listing all UDFs
- Data layer showing ALL tables
- Connection arrows between layers
- Shadows on all boxes

### deployment_flow.svg MUST Include:
- ALL 8 SQL script steps numbered and labeled
- ML Notebook step (marked as optional, with different color)
- Parallel execution paths where applicable (steps 6, NB, 7 run in parallel)
- Merge point before final step
- Legend showing step types
- Shadows on all boxes
- Numbered circles ABOVE or BESIDE (not underneath) description boxes

### ml_models.svg MUST Include:
- All ML functions as separate boxes
- Input parameters for each function
- Output values for each function
- Color coding for inputs vs outputs
- Legend

### project_structure.svg MUST Include:
- EVERY file in the project - no wildcards, no abbreviations
- Root level files (README.md, Snowflake_Logo.svg, agent.md)
- All SQL folders and their files
- Notebooks folder and files
- Docs folder, all markdown files, AND images subfolder with ALL SVG files
- Color coding by file type
- Legend

---

## Critical Syntax Reference

### Snowflake Agent YAML Specification (VERIFIED WORKING)

```yaml
CREATE OR REPLACE AGENT {AGENT_NAME}
  COMMENT = '{Customer} intelligence agent'
  PROFILE = '{"display_name": "{Customer} Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    response: "Response instructions..."
    orchestration: "Tool routing instructions..."
    system: "System role description..."
    sample_questions:
      - question: "Sample question?"
        answer: "How the agent should respond."

  tools:
    # Cortex Analyst (text-to-SQL)
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "ToolName"
        description: "Description of what this tool does"

    # Cortex Search
    - tool_spec:
        type: "cortex_search"
        name: "SearchName"
        description: "Description of search capability"

    # Custom Function (generic)
    - tool_spec:
        type: "generic"
        name: "FunctionName"
        description: "Description of function output"

  tool_resources:
    # Cortex Analyst resource
    ToolName:
      semantic_view: "{DATABASE}.{SCHEMA}.{SEMANTIC_VIEW_NAME}"

    # Cortex Search resource
    SearchName:
      name: "{DATABASE}.{SCHEMA}.{SEARCH_SERVICE_NAME}"
      max_results: "10"
      title_column: "column_name"
      id_column: "id_column"

    # Custom Function resource
    FunctionName:
      type: "function"
      identifier: "{DATABASE}.{SCHEMA}.{FUNCTION_NAME}"
      execution_environment:
        type: "warehouse"
        warehouse: "{WAREHOUSE_NAME}"
  $$;
```

### SQL UDF Return Types (VERIFIED)

| Function Returns | Correct Return Type |
|------------------|---------------------|
| `ARRAY_AGG(...)` | `RETURNS ARRAY` |
| `OBJECT_CONSTRUCT(...)` | `RETURNS OBJECT` |
| Single scalar value | `RETURNS VARCHAR/NUMBER/etc` |

**DO NOT USE:**
- `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
- `LANGUAGE SQL` clause in SQL UDFs

### SQL UDF Syntax (VERIFIED)

```sql
-- Correct syntax for scalar UDF returning ARRAY
CREATE OR REPLACE FUNCTION AGENT_GET_DATA()
RETURNS ARRAY
AS
$$
SELECT ARRAY_AGG(OBJECT_CONSTRUCT(
    'key1', COLUMN1,
    'key2', COLUMN2
)) FROM (SELECT * FROM TABLE LIMIT 50)
$$;

-- Correct syntax for scalar UDF returning OBJECT
CREATE OR REPLACE FUNCTION AGENT_GET_SUMMARY()
RETURNS OBJECT
AS
$$
SELECT OBJECT_CONSTRUCT(
    'metric1', (SELECT COUNT(*) FROM TABLE1),
    'metric2', (SELECT AVG(COLUMN) FROM TABLE2)
)
$$;
```

---

## Lessons Learned (CRITICAL)

### 1. ALWAYS VERIFY SNOWFLAKE SYNTAX BEFORE WRITING CODE

**What went wrong:** Multiple syntax errors because I guessed at syntax instead of verifying against Snowflake documentation.

**Correct approach:**
- Use `snowflake_product_docs` tool to look up syntax BEFORE writing any SQL
- Use `system_instructions` tool for Cortex Agent, Analyst, and other Snowflake products
- Reference working examples (like Troon Intelligence Agent)

**Specific errors made:**
- Used `RETURNS VARIANT` instead of `RETURNS ARRAY` for `ARRAY_AGG`
- Used `RETURNS VARIANT` instead of `RETURNS OBJECT` for `OBJECT_CONSTRUCT`
- Used `LANGUAGE SQL` clause which is invalid for SQL UDFs
- Used `type: "procedure"` instead of `type: "function"` for agent tools
- Used `search_service:` instead of `name:` for Cortex Search resources
- Used JSON format instead of YAML for agent specification

### 2. COMPLETE ALL FILES BEFORE STOPPING

**What went wrong:** Generated partial files and stopped without completing the project, leaving merge conflicts and incomplete code.

**Correct approach:**
- Review ALL files in the project at the start
- Create a TODO list for every file that needs to be created/modified
- Do not mark a task complete until the file is verified to compile/run
- Verify file completeness before moving to the next task

### 3. NEVER GUESS - ASK OR RESEARCH

**What went wrong:** Made assumptions about:
- Agent YAML syntax
- SQL UDF return types
- Function naming conventions
- Tool resource configuration

**Correct approach:**
- If unsure about syntax, use documentation tools first
- If documentation is unclear, ask the user for clarification
- Reference working examples from similar projects
- Test small pieces of code before combining them

### 4. ASK QUESTIONS WHEN UNCLEAR

**What went wrong:** Proceeded with assumptions instead of asking for clarification on requirements.

**Questions to ask upfront:**
- What business domain/industry is this for?
- What specific ML models or predictions are needed?
- What data sources exist or need to be created?
- What sample questions should the agent answer?
- Are there any existing working examples to reference?

### 5. VERIFY GIT MERGE CONFLICTS

**What went wrong:** Left merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in SQL files.

**Correct approach:**
- After any file operations, verify no merge conflicts exist
- Search for conflict markers before marking files complete
- Test SQL files compile before considering them done

### 6. NEVER USE TEXT-BASED GRAPHICS

**What went wrong:** Used ASCII art and code blocks to represent diagrams instead of proper SVG images.

**Correct approach:**
- ALWAYS create SVG files for ALL diagrams
- Reference SVG files in markdown using `![Description](path/to/image.svg)`
- Never use code blocks with tree structures or box-drawing characters

### 7. SVG IMAGES MUST BE COMPLETE

**What went wrong:** 
- Cut off content by not sizing viewBox correctly
- Used wildcards like `*.svg` instead of listing every file
- Overlapped elements by poor positioning
- Placed numbered circles underneath description boxes where they couldn't be seen
- Forgot to include ML notebook in deployment flow
- Forgot to include ML functions in architecture diagram
- Included specific model names that shouldn't be shown

**Correct approach:**
- Calculate viewBox height to fit ALL content with padding
- List EVERY file explicitly - no wildcards or abbreviations
- Calculate element positions to prevent ANY overlap
- Place numbered circles ABOVE or BESIDE boxes, never underneath
- Include ALL steps in deployment flow including notebooks
- Include ALL components in architecture including ML functions
- Use generic descriptions (e.g., "Cortex Agent") not specific model names

### 8. ADD SHADOWS TO ALL BOXES IN SVG

**What went wrong:** Created flat boxes without shadows, making diagrams look unprofessional.

**Correct approach:**
- Add `filter="url(#shadow)"` to ALL rect elements
- Use compatible shadow filter (feGaussianBlur + feOffset + feMerge)
- Do NOT use feDropShadow (causes encoding errors)

### 9. DIRECTORY STRUCTURE MUST BE EXACT

**What went wrong:** Created files in wrong directories or with wrong naming.

**Correct approach:**
- Follow the exact directory structure specified in this document
- Use the exact file names specified
- Create ALL directories before creating files
- Verify structure with `ls -R` after creation

---

## Component Templates

### Database Setup (01_database_and_schema.sql)

```sql
CREATE DATABASE IF NOT EXISTS {DATABASE_NAME};
USE DATABASE {DATABASE_NAME};

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

CREATE OR REPLACE WAREHOUSE {WAREHOUSE_NAME} WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for {CUSTOMER_NAME} Intelligence Agent';

USE WAREHOUSE {WAREHOUSE_NAME};
```

### Cortex Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE {SEARCH_SERVICE_NAME}
  ON {text_column}
  ATTRIBUTES {attr1}, {attr2}, {attr3}
  WAREHOUSE = {WAREHOUSE_NAME}
  TARGET_LAG = '1 hour'
  COMMENT = 'Description of search service'
AS
  SELECT
    {columns}
  FROM {TABLE};
```

### Semantic View

```sql
CREATE OR REPLACE SEMANTIC VIEW {SEMANTIC_VIEW_NAME}
  COMMENT = 'Semantic view description'
AS
  SELECT
    {table}.{column} AS {alias}
      WITH SYNONYMS ('{synonym1}', '{synonym2}')
      COMMENT = '{Column description}',
    ...
  FROM {database}.{schema}.{table}
  ...;
```

---

## Checklist for New Projects

### Before Starting
- [ ] Confirm customer name and business domain
- [ ] Identify data sources (existing tables or need synthetic data)
- [ ] Determine ML models needed (LTV, churn, risk, etc.)
- [ ] Collect sample questions the agent should answer
- [ ] Get working example project for reference

### During Development
- [ ] Verify ALL SQL syntax against Snowflake docs before writing
- [ ] Test each SQL file compiles before moving to next
- [ ] Check for merge conflicts after any file operations
- [ ] Complete TODO list for every component

### Documentation & Images (MANDATORY)
- [ ] Create README.md with Snowflake logo and all diagrams
- [ ] Create docs/AGENT_SETUP.md with step-by-step guide
- [ ] Create docs/DEPLOYMENT_SUMMARY.md with all diagrams
- [ ] Create docs/questions.md with 50+ test questions
- [ ] Create docs/images/architecture.svg (with shadows, ML functions, all tables)
- [ ] Create docs/images/deployment_flow.svg (with shadows, all steps including notebook)
- [ ] Create docs/images/ml_models.svg (with shadows, all functions)
- [ ] Create docs/images/project_structure.svg (with shadows, EVERY file listed)
- [ ] Verify NO text-based graphics anywhere in markdown files
- [ ] Verify ALL SVG elements have shadows
- [ ] Verify NO elements overlap in SVG files
- [ ] Verify viewBox is large enough to show ALL content
- [ ] Verify NO Unicode special characters in SVG files

### Before Delivery
- [ ] Run all SQL files in order (01-08)
- [ ] Test agent creation succeeds
- [ ] Verify agent responds to sample questions
- [ ] Update documentation with customer-specific details
- [ ] Remove any placeholder values
- [ ] Verify all SVG images render correctly

---

## Reference Links

- Snowflake Agent Docs: `snowflake_product_docs` → "Cortex Agent"
- SQL UDF Reference: `snowflake_product_docs` → "CREATE FUNCTION SQL"
- Cortex Search: `snowflake_product_docs` → "CREATE CORTEX SEARCH SERVICE"
- Semantic Views: `snowflake_product_docs` → "CREATE SEMANTIC VIEW"

---

## Version History

- **v1.0** - Initial template based on previous Intelligence Agent project
- **v2.0** - Added mandatory SVG requirements, documentation requirements, and lessons learned from Consumer Cellular project
- **Created:** February 2026
- **Updated:** February 2026

---

## DO NOT:
1. Guess at syntax - VERIFY FIRST
2. Use `RETURNS VARIANT` for `ARRAY_AGG` or `OBJECT_CONSTRUCT`
3. Use `LANGUAGE SQL` in SQL UDFs
4. Use JSON format for Agent specification (use YAML)
5. Leave merge conflicts in files
6. Mark tasks complete before verifying they work
7. Assume you know Snowflake syntax without checking
8. Use text-based graphics (ASCII art, code block trees) - USE SVG
9. Use wildcards or abbreviations in project structure diagrams - LIST EVERY FILE
10. Use feDropShadow in SVG - causes encoding errors
11. Use Unicode special characters in SVG - causes encoding errors
12. Place numbered circles underneath description boxes - they must be visible
13. Overlap elements in SVG diagrams - calculate positions carefully
14. Cut off content by using too small viewBox - expand to fit ALL content
15. Forget to add ML notebook to deployment flow diagram
16. Forget to add ML functions to architecture diagram
17. Include specific model names (like "Claude 3.5 Sonnet") in diagrams
18. Create flat boxes without shadows in SVG

## DO:
1. Use `snowflake_product_docs` before writing SQL
2. Use `system_instructions` for Cortex products
3. Reference working examples
4. Ask questions when requirements are unclear
5. Test each file compiles before moving on
6. Complete ALL files before stopping
7. Verify no merge conflicts exist
8. Create ALL documentation files as specified
9. Create ALL SVG images as specified
10. Add shadows to ALL boxes in SVG using compatible filter
11. List EVERY file in project structure diagram
12. Include ALL steps in deployment flow (including notebook)
13. Include ALL components in architecture (including ML functions)
14. Use generic descriptions not specific model names in diagrams
15. Position numbered circles ABOVE or BESIDE description boxes
16. Calculate element positions to prevent overlap
17. Size viewBox large enough to fit ALL content with padding
18. Verify SVG renders correctly before marking complete

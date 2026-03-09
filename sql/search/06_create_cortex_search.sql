-- =============================================================================
-- Cortex Search 1: Knowledge Base Articles
-- =============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE CCI_INTELLIGENCE.RAW.CCI_KNOWLEDGE_SEARCH
  ON CONTENT
  ATTRIBUTES CATEGORY, SUBCATEGORY, KEYWORDS
  WAREHOUSE = AICOLLEGE
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for Consumer Cellular knowledge base articles'
AS (
  SELECT
    ARTICLE_ID,
    TITLE,
    CATEGORY,
    SUBCATEGORY,
    CONTENT,
    KEYWORDS,
    LAST_UPDATED
  FROM CCI_INTELLIGENCE.RAW.KNOWLEDGE_BASE
);


-- =============================================================================
-- Cortex Search 2: Support Ticket Search
-- =============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE CCI_INTELLIGENCE.RAW.CCI_SUPPORT_TICKET_SEARCH
  ON SEARCH_TEXT
  ATTRIBUTES CATEGORY, SUBCATEGORY, PRIORITY, STATUS
  WAREHOUSE = AICOLLEGE
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for searching support tickets by issue description and resolution'
AS (
  SELECT
    TICKET_ID,
    CATEGORY,
    SUBCATEGORY,
    PRIORITY,
    STATUS,
    ISSUE_DESCRIPTION || ' ' || COALESCE(RESOLUTION_NOTES, '') AS SEARCH_TEXT,
    CREATED_DATE
  FROM CCI_INTELLIGENCE.RAW.SUPPORT_TICKETS
);


-- =============================================================================
-- Cortex Search 3: Customer Feedback Search
-- =============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE CCI_INTELLIGENCE.RAW.CCI_FEEDBACK_SEARCH
  ON COMMENTS
  ATTRIBUTES FEEDBACK_TYPE
  WAREHOUSE = AICOLLEGE
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for searching customer feedback comments and surveys'
AS (
  SELECT
    FEEDBACK_ID,
    CUSTOMER_ID,
    FEEDBACK_TYPE,
    COMMENTS,
    FEEDBACK_DATE,
    NPS_SCORE,
    CSAT_SCORE
  FROM CCI_INTELLIGENCE.RAW.CUSTOMER_FEEDBACK
  WHERE COMMENTS IS NOT NULL
);

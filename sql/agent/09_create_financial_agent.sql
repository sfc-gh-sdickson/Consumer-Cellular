CREATE OR REPLACE AGENT CCI_INTELLIGENCE.ANALYTICS.CCI_FINANCIAL_AGENT
  COMMENT = 'Consumer Cellular Intelligence Agent for customer analytics, financial insights, and support'
  FROM SPECIFICATION
  $$
  models:
    orchestration: claude-3-5-sonnet

  orchestration:
    budget:
      seconds: 30
      tokens: 16000

  instructions:
    system: >
      You are the Consumer Cellular Intelligence Agent, designed to help business users
      understand customer analytics, revenue metrics, and support operations.
    response: >
      Lead with the key insight or answer. Provide supporting data when relevant.
      Suggest next steps or related analyses when appropriate.
    orchestration: >
      For customer analytics, segmentation, churn, and lifetime value questions use CustomerAnalytics.
      For revenue, billing, usage patterns, and financial questions use FinancialAnalytics.
      For support tickets, satisfaction scores, and feedback questions use SupportAnalytics.
      For knowledge base and help article questions use KnowledgeSearch.
      For finding similar support cases and resolutions use TicketSearch.
      For searching customer feedback and survey responses use FeedbackSearch.

  tools:
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "CustomerAnalytics"
        description: "Queries customer data including segmentation, lifetime value, churn predictions, subscription status, and AARP membership. Use for questions about customer counts, segments, churn risk, retention, and customer profiles."
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "FinancialAnalytics"
        description: "Queries financial data including billing, revenue, plan charges, overage charges, usage patterns, and payment status. Use for questions about revenue, ARPU, billing trends, plan performance, and data usage."
    - tool_spec:
        type: "cortex_analyst_text_to_sql"
        name: "SupportAnalytics"
        description: "Queries support ticket data including categories, priorities, resolution times, satisfaction scores, NPS, and customer feedback. Use for questions about ticket volume, CSAT, resolution rates, and service quality."
    - tool_spec:
        type: "cortex_search"
        name: "KnowledgeSearch"
        description: "Searches Consumer Cellular knowledge base articles for help topics like voicemail setup, phone troubleshooting, AARP benefits, account management, and device instructions."
    - tool_spec:
        type: "cortex_search"
        name: "TicketSearch"
        description: "Searches support ticket descriptions and resolution notes to find similar cases and proven resolutions for customer issues."
    - tool_spec:
        type: "cortex_search"
        name: "FeedbackSearch"
        description: "Searches customer feedback comments and survey responses to understand customer sentiment and identify common themes."

  tool_resources:
    CustomerAnalytics:
      semantic_view: "CCI_INTELLIGENCE.ANALYTICS.CCI_CUSTOMER_ANALYTICS_SV"
    FinancialAnalytics:
      semantic_view: "CCI_INTELLIGENCE.ANALYTICS.CCI_FINANCIAL_SV"
    SupportAnalytics:
      semantic_view: "CCI_INTELLIGENCE.ANALYTICS.CCI_SUPPORT_SV"
    KnowledgeSearch:
      name: "CCI_INTELLIGENCE.RAW.CCI_KNOWLEDGE_SEARCH"
      max_results: "5"
      title_column: "TITLE"
      id_column: "ARTICLE_ID"
    TicketSearch:
      name: "CCI_INTELLIGENCE.RAW.CCI_SUPPORT_TICKET_SEARCH"
      max_results: "5"
      id_column: "TICKET_ID"
    FeedbackSearch:
      name: "CCI_INTELLIGENCE.RAW.CCI_FEEDBACK_SEARCH"
      max_results: "5"
      id_column: "FEEDBACK_ID"
  $$;

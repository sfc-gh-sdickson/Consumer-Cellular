CREATE OR REPLACE AGENT CCI_INTELLIGENCE.ANALYTICS.CCI_FINANCIAL_AGENT
  COMMENT = 'Consumer Cellular Intelligence Agent for customer analytics, financial insights, and support'
  PROFILE = '{"display_name": "Consumer Cellular Assistant", "color": "blue"}'
  FROM SPECIFICATION
  $$
  models:
    orchestration: auto

  orchestration:
    budget:
      seconds: 60
      tokens: 32000

  instructions:
    system: >
      You are the Consumer Cellular Intelligence Agent, designed to help business users
      understand customer analytics, revenue metrics, support operations, and predictive insights
      for Consumer Cellular, an MVNO focused on affordable plans for customers over 50.
    response: >
      Lead with the key insight or answer. Provide supporting data when relevant.
      Format numbers clearly with commas and appropriate units.
      Suggest next steps or related analyses when appropriate.
    orchestration: >
      For customer analytics, segmentation, churn, and lifetime value questions use CustomerAnalytics.
      For revenue, billing, usage patterns, and financial questions use FinancialAnalytics.
      For support tickets, satisfaction scores, and feedback questions use SupportAnalytics.
      For knowledge base and help article questions use KnowledgeSearch.
      For finding similar support cases and resolutions use TicketSearch.
      For searching customer feedback and survey responses use FeedbackSearch.
      For predicting customer churn risk use PredictChurn.
      For calculating customer lifetime value use CalculateLTV.
      For recommending optimal plans based on usage use RecommendPlan.
      For computing overall customer health scores use CalculateHealthScore.
    sample_questions:
      - question: "How many customers are at high churn risk?"
        answer: "Use CustomerAnalytics to query churn predictions filtered by high risk level and provide the count along with recommended retention actions."
      - question: "What is the average revenue per user by plan type?"
        answer: "Use FinancialAnalytics to calculate average billing amounts grouped by plan type."
      - question: "What are the top support ticket categories this month?"
        answer: "Use SupportAnalytics to query ticket counts grouped by category for the current month, sorted by volume."
      - question: "How do I set up voicemail on my phone?"
        answer: "Use KnowledgeSearch to find knowledge base articles about voicemail setup and return the relevant instructions."
      - question: "Predict the churn risk for customer C001 with 18 months tenure, $45 monthly revenue, 3 support tickets, and 1 late payment."
        answer: "Use PredictChurn with the provided parameters and return the churn probability, risk level, and recommended action."

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
    - tool_spec:
        type: "generic"
        name: "PredictChurn"
        description: "Predicts churn probability for a customer given their tenure, average monthly revenue, support ticket count, and late payment count. Returns churn probability, risk level, and recommended retention action."
    - tool_spec:
        type: "generic"
        name: "CalculateLTV"
        description: "Calculates predicted customer lifetime value given historical revenue, tenure, and churn probability. Returns predicted LTV, average monthly revenue, predicted lifetime months, and LTV segment."
    - tool_spec:
        type: "generic"
        name: "RecommendPlan"
        description: "Recommends the optimal Consumer Cellular plan based on current plan, average data usage, talk minutes, and overage charges. Returns recommended plan, reason, and estimated savings."
    - tool_spec:
        type: "generic"
        name: "CalculateHealthScore"
        description: "Computes an overall customer health score based on LTV segment, churn risk level, auto-pay status, tenure, and satisfaction score. Returns health score, health category, and improvement suggestions."

  tool_resources:
    CustomerAnalytics:
      semantic_view: "CCI_INTELLIGENCE.ANALYTICS.CCI_CUSTOMER_ANALYTICS_SV"
    FinancialAnalytics:
      semantic_view: "CCI_INTELLIGENCE.ANALYTICS.CCI_FINANCIAL_SV"
    SupportAnalytics:
      semantic_view: "CCI_INTELLIGENCE.ANALYTICS.CCI_SUPPORT_SV"
    KnowledgeSearch:
      search_service: "CCI_INTELLIGENCE.RAW.CCI_KNOWLEDGE_SEARCH"
      max_results: "10"
      title_column: "TITLE"
      id_column: "ARTICLE_ID"
    TicketSearch:
      search_service: "CCI_INTELLIGENCE.RAW.CCI_SUPPORT_TICKET_SEARCH"
      max_results: "10"
      id_column: "TICKET_ID"
    FeedbackSearch:
      search_service: "CCI_INTELLIGENCE.RAW.CCI_FEEDBACK_SEARCH"
      max_results: "10"
      id_column: "FEEDBACK_ID"
    PredictChurn:
      type: "function"
      identifier: "CCI_INTELLIGENCE.ANALYTICS.PREDICT_CHURN"
      execution_environment:
        type: "warehouse"
        warehouse: "AICOLLEGE"
    CalculateLTV:
      type: "function"
      identifier: "CCI_INTELLIGENCE.ANALYTICS.CALCULATE_LTV"
      execution_environment:
        type: "warehouse"
        warehouse: "AICOLLEGE"
    RecommendPlan:
      type: "function"
      identifier: "CCI_INTELLIGENCE.ANALYTICS.RECOMMEND_PLAN"
      execution_environment:
        type: "warehouse"
        warehouse: "AICOLLEGE"
    CalculateHealthScore:
      type: "function"
      identifier: "CCI_INTELLIGENCE.ANALYTICS.CALCULATE_HEALTH_SCORE"
      execution_environment:
        type: "warehouse"
        warehouse: "AICOLLEGE"
  $$;

-- =============================================================================
-- Semantic View 1: Customer Analytics
-- Covers: customers, plans, subscriptions, churn predictions, lifetime value
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW CCI_INTELLIGENCE.ANALYTICS.CCI_CUSTOMER_ANALYTICS_SV

  TABLES (
    CUSTOMERS AS CCI_INTELLIGENCE.RAW.CUSTOMERS
      PRIMARY KEY (CUSTOMER_ID)
      WITH SYNONYMS ('customer', 'customers', 'subscriber', 'subscribers', 'member', 'members'),
    PLANS AS CCI_INTELLIGENCE.RAW.PLANS
      PRIMARY KEY (PLAN_ID)
      WITH SYNONYMS ('plan', 'plans', 'service plan', 'rate plan', 'pricing plan'),
    SUBSCRIPTIONS AS CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS
      PRIMARY KEY (SUBSCRIPTION_ID)
      WITH SYNONYMS ('subscription', 'subscriptions', 'account', 'service'),
    CHURN_PREDICTIONS AS CCI_INTELLIGENCE.RAW.CHURN_PREDICTIONS
      PRIMARY KEY (PREDICTION_ID)
      WITH SYNONYMS ('churn', 'churn prediction', 'churn risk', 'attrition'),
    CUSTOMER_LTV AS CCI_INTELLIGENCE.RAW.CUSTOMER_LTV
      PRIMARY KEY (LTV_ID)
      WITH SYNONYMS ('ltv', 'lifetime value', 'customer value', 'clv')
  )

  RELATIONSHIPS (
    SUBSCRIPTIONS (CUSTOMER_ID) REFERENCES CUSTOMERS,
    CHURN_PREDICTIONS (CUSTOMER_ID) REFERENCES CUSTOMERS,
    CUSTOMER_LTV (CUSTOMER_ID) REFERENCES CUSTOMERS,
    SUBSCRIPTIONS (PLAN_ID) REFERENCES PLANS
  )

  FACTS (
    CHURN_PREDICTIONS.CHURN_PROBABILITY AS CHURN_PREDICTIONS.CHURN_PROBABILITY
      WITH SYNONYMS ('churn probability', 'churn likelihood', 'churn score'),
    CUSTOMER_LTV.PREDICTED_LIFETIME_VALUE AS CUSTOMER_LTV.PREDICTED_LIFETIME_VALUE
      WITH SYNONYMS ('ltv', 'lifetime value', 'customer lifetime value', 'clv'),
    CUSTOMER_LTV.AVG_MONTHLY_REVENUE AS CUSTOMER_LTV.AVG_MONTHLY_REVENUE
      WITH SYNONYMS ('arpu', 'average revenue', 'monthly revenue'),
    CUSTOMER_LTV.HISTORICAL_REVENUE AS CUSTOMER_LTV.HISTORICAL_REVENUE
      WITH SYNONYMS ('historical revenue', 'past revenue'),
    CUSTOMER_LTV.TENURE_MONTHS AS CUSTOMER_LTV.TENURE_MONTHS
      WITH SYNONYMS ('tenure', 'months active')
  )

  DIMENSIONS (
    CUSTOMERS.CUSTOMER_ID AS CUSTOMERS.CUSTOMER_ID
      WITH SYNONYMS ('customer id', 'cust id', 'subscriber id', 'member id'),
    CUSTOMERS.FIRST_NAME AS CUSTOMERS.FIRST_NAME
      WITH SYNONYMS ('first name', 'given name'),
    CUSTOMERS.LAST_NAME AS CUSTOMERS.LAST_NAME
      WITH SYNONYMS ('last name', 'surname', 'family name'),
    CUSTOMERS.EMAIL AS CUSTOMERS.EMAIL
      WITH SYNONYMS ('email address', 'email'),
    CUSTOMERS.PHONE AS CUSTOMERS.PHONE
      WITH SYNONYMS ('phone number', 'contact number', 'telephone'),
    CUSTOMERS.AGE AS CUSTOMERS.AGE
      WITH SYNONYMS ('customer age', 'years old'),
    CUSTOMERS.SIGNUP_DATE AS CUSTOMERS.SIGNUP_DATE
      WITH SYNONYMS ('signup date', 'registration date', 'join date', 'enrollment date'),
    CUSTOMERS.CUSTOMER_SEGMENT AS CUSTOMERS.CUSTOMER_SEGMENT
      WITH SYNONYMS ('segment', 'customer type', 'category'),
    CUSTOMERS.AARP_MEMBER AS CUSTOMERS.AARP_MEMBER
      WITH SYNONYMS ('aarp', 'aarp membership', 'aarp status'),
    CUSTOMERS.REFERRAL_SOURCE AS CUSTOMERS.REFERRAL_SOURCE
      WITH SYNONYMS ('referral', 'referral source', 'how they found us'),

    PLANS.PLAN_ID AS PLANS.PLAN_ID
      WITH SYNONYMS ('plan id', 'plan identifier'),
    PLANS.PLAN_NAME AS PLANS.PLAN_NAME
      WITH SYNONYMS ('plan name', 'plan title'),
    PLANS.PLAN_TYPE AS PLANS.PLAN_TYPE
      WITH SYNONYMS ('plan type', 'plan category', 'tier'),

    SUBSCRIPTIONS.SUBSCRIPTION_ID AS SUBSCRIPTIONS.SUBSCRIPTION_ID
      WITH SYNONYMS ('subscription id', 'account id'),
    SUBSCRIPTIONS.SUBSCRIPTION_STATUS AS SUBSCRIPTIONS.STATUS
      WITH SYNONYMS ('subscription status', 'account status', 'service status'),
    SUBSCRIPTIONS.AUTO_PAY_ENABLED AS SUBSCRIPTIONS.AUTO_PAY_ENABLED
      WITH SYNONYMS ('autopay', 'auto pay', 'automatic payment'),

    CHURN_PREDICTIONS.CHURN_RISK_LEVEL AS CHURN_PREDICTIONS.CHURN_RISK_LEVEL
      WITH SYNONYMS ('risk level', 'churn risk', 'risk category'),
    CHURN_PREDICTIONS.KEY_RISK_FACTORS AS CHURN_PREDICTIONS.KEY_RISK_FACTORS
      WITH SYNONYMS ('risk factors', 'churn reasons'),
    CHURN_PREDICTIONS.RECOMMENDED_ACTION AS CHURN_PREDICTIONS.RECOMMENDED_ACTION
      WITH SYNONYMS ('recommended action', 'retention action'),

    CUSTOMER_LTV.LTV_SEGMENT AS CUSTOMER_LTV.LTV_SEGMENT
      WITH SYNONYMS ('ltv segment', 'value segment', 'customer tier')
  )

  METRICS (
    CUSTOMERS.CUSTOMER_COUNT AS COUNT(CUSTOMERS.CUSTOMER_ID)
      WITH SYNONYMS ('total customers', 'number of customers', 'customer count'),
    CHURN_PREDICTIONS.AVG_CHURN_PROBABILITY AS AVG(CHURN_PREDICTIONS.CHURN_PROBABILITY)
      WITH SYNONYMS ('average churn probability', 'mean churn risk'),
    CUSTOMER_LTV.AVG_LIFETIME_VALUE AS AVG(CUSTOMER_LTV.PREDICTED_LIFETIME_VALUE)
      WITH SYNONYMS ('average ltv', 'mean lifetime value'),
    CUSTOMER_LTV.TOTAL_LIFETIME_VALUE AS SUM(CUSTOMER_LTV.PREDICTED_LIFETIME_VALUE)
      WITH SYNONYMS ('total ltv', 'total lifetime value at risk'),
    CUSTOMER_LTV.AVG_MONTHLY_REV AS AVG(CUSTOMER_LTV.AVG_MONTHLY_REVENUE)
      WITH SYNONYMS ('average arpu', 'mean monthly revenue')
  )

  COMMENT = 'Semantic view for customer analytics, segmentation, churn risk, and lifetime value analysis';


-- =============================================================================
-- Semantic View 2: Financial Analytics
-- Covers: billing, subscriptions, plans, usage data, customers
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW CCI_INTELLIGENCE.ANALYTICS.CCI_FINANCIAL_SV

  TABLES (
    BILLING AS CCI_INTELLIGENCE.RAW.BILLING
      PRIMARY KEY (BILLING_ID)
      WITH SYNONYMS ('billing', 'bills', 'invoice', 'invoices', 'payment', 'payments'),
    SUBSCRIPTIONS AS CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS
      PRIMARY KEY (SUBSCRIPTION_ID)
      WITH SYNONYMS ('subscription', 'subscriptions', 'account'),
    PLANS AS CCI_INTELLIGENCE.RAW.PLANS
      PRIMARY KEY (PLAN_ID)
      WITH SYNONYMS ('plan', 'plans', 'service plan', 'rate plan'),
    USAGE_DATA AS CCI_INTELLIGENCE.RAW.USAGE_DATA
      PRIMARY KEY (USAGE_ID)
      WITH SYNONYMS ('usage', 'data usage', 'consumption'),
    CUSTOMERS AS CCI_INTELLIGENCE.RAW.CUSTOMERS
      PRIMARY KEY (CUSTOMER_ID)
      WITH SYNONYMS ('customer', 'customers')
  )

  RELATIONSHIPS (
    BILLING (SUBSCRIPTION_ID) REFERENCES SUBSCRIPTIONS,
    BILLING (CUSTOMER_ID) REFERENCES CUSTOMERS,
    SUBSCRIPTIONS (PLAN_ID) REFERENCES PLANS,
    SUBSCRIPTIONS (CUSTOMER_ID) REFERENCES CUSTOMERS,
    USAGE_DATA (SUBSCRIPTION_ID) REFERENCES SUBSCRIPTIONS,
    USAGE_DATA (CUSTOMER_ID) REFERENCES CUSTOMERS
  )

  FACTS (
    BILLING.TOTAL_AMOUNT AS BILLING.TOTAL_AMOUNT
      WITH SYNONYMS ('total', 'amount', 'bill amount', 'invoice amount', 'charge'),
    BILLING.PLAN_CHARGE AS BILLING.PLAN_CHARGE
      WITH SYNONYMS ('plan charge', 'service charge', 'monthly charge'),
    BILLING.OVERAGE_CHARGES AS BILLING.OVERAGE_CHARGES
      WITH SYNONYMS ('overage', 'extra charges', 'additional charges'),
    BILLING.DEVICE_PAYMENT AS BILLING.DEVICE_PAYMENT
      WITH SYNONYMS ('device payment', 'phone payment'),
    BILLING.TAXES_FEES AS BILLING.TAXES_FEES
      WITH SYNONYMS ('taxes', 'fees', 'tax amount'),
    USAGE_DATA.DATA_USED_GB AS USAGE_DATA.DATA_USED_GB
      WITH SYNONYMS ('data used', 'gb used', 'data consumption'),
    USAGE_DATA.TALK_MINUTES_USED AS USAGE_DATA.TALK_MINUTES_USED
      WITH SYNONYMS ('talk minutes', 'call minutes', 'minutes used'),
    USAGE_DATA.TEXTS_SENT AS USAGE_DATA.TEXTS_SENT
      WITH SYNONYMS ('texts sent', 'sms sent', 'messages sent'),
    PLANS.MONTHLY_PRICE AS PLANS.MONTHLY_PRICE
      WITH SYNONYMS ('price', 'monthly cost', 'monthly rate', 'plan price')
  )

  DIMENSIONS (
    BILLING.BILLING_ID AS BILLING.BILLING_ID
      WITH SYNONYMS ('billing id', 'invoice id', 'bill id'),
    BILLING.BILLING_DATE AS BILLING.BILLING_DATE
      WITH SYNONYMS ('billing date', 'invoice date', 'bill date'),
    BILLING.BILLING_MONTH AS DATE_TRUNC('MONTH', BILLING.BILLING_DATE)
      WITH SYNONYMS ('billing month', 'invoice month'),
    BILLING.PAYMENT_STATUS AS BILLING.PAYMENT_STATUS
      WITH SYNONYMS ('payment status', 'paid status', 'billing status'),
    BILLING.CUSTOMER_ID AS BILLING.CUSTOMER_ID
      WITH SYNONYMS ('customer id'),

    SUBSCRIPTIONS.SUBSCRIPTION_ID AS SUBSCRIPTIONS.SUBSCRIPTION_ID
      WITH SYNONYMS ('subscription id', 'account id'),
    SUBSCRIPTIONS.SUBSCRIPTION_STATUS AS SUBSCRIPTIONS.STATUS
      WITH SYNONYMS ('subscription status', 'account status'),
    SUBSCRIPTIONS.AUTO_PAY_ENABLED AS SUBSCRIPTIONS.AUTO_PAY_ENABLED
      WITH SYNONYMS ('autopay', 'auto pay', 'automatic payment'),
    SUBSCRIPTIONS.PAYMENT_METHOD AS SUBSCRIPTIONS.PAYMENT_METHOD
      WITH SYNONYMS ('payment method', 'how they pay'),

    PLANS.PLAN_ID AS PLANS.PLAN_ID
      WITH SYNONYMS ('plan id'),
    PLANS.PLAN_NAME AS PLANS.PLAN_NAME
      WITH SYNONYMS ('plan name', 'plan title'),
    PLANS.PLAN_TYPE AS PLANS.PLAN_TYPE
      WITH SYNONYMS ('plan type', 'plan category', 'tier'),
    PLANS.DATA_LIMIT_GB AS PLANS.DATA_LIMIT_GB
      WITH SYNONYMS ('data limit', 'data allowance', 'gb limit'),
    PLANS.UNLIMITED_DATA AS PLANS.UNLIMITED_DATA
      WITH SYNONYMS ('unlimited data', 'no data limit'),

    USAGE_DATA.USAGE_MONTH AS USAGE_DATA.USAGE_MONTH
      WITH SYNONYMS ('usage month', 'month'),

    CUSTOMERS.CUSTOMER_SEGMENT AS CUSTOMERS.CUSTOMER_SEGMENT
      WITH SYNONYMS ('segment', 'customer segment')
  )

  METRICS (
    BILLING.TOTAL_REVENUE AS SUM(BILLING.TOTAL_AMOUNT)
      WITH SYNONYMS ('total revenue', 'revenue', 'total sales'),
    BILLING.AVG_BILL_AMOUNT AS AVG(BILLING.TOTAL_AMOUNT)
      WITH SYNONYMS ('average bill', 'avg bill amount', 'mean bill'),
    BILLING.TOTAL_PLAN_REVENUE AS SUM(BILLING.PLAN_CHARGE)
      WITH SYNONYMS ('plan revenue', 'service revenue'),
    BILLING.TOTAL_OVERAGE_REVENUE AS SUM(BILLING.OVERAGE_CHARGES)
      WITH SYNONYMS ('overage revenue', 'total overage'),
    BILLING.ACTIVE_CUSTOMERS AS COUNT(DISTINCT BILLING.CUSTOMER_ID)
      WITH SYNONYMS ('active customers', 'paying customers'),
    USAGE_DATA.AVG_DATA_USAGE AS AVG(USAGE_DATA.DATA_USED_GB)
      WITH SYNONYMS ('average data usage', 'mean data usage'),
    USAGE_DATA.AVG_TALK_MINUTES AS AVG(USAGE_DATA.TALK_MINUTES_USED)
      WITH SYNONYMS ('average talk minutes', 'mean talk minutes'),
    USAGE_DATA.TOTAL_OVERAGE AS SUM(USAGE_DATA.OVERAGE_CHARGES)
      WITH SYNONYMS ('total usage overage', 'usage overage charges')
  )

  COMMENT = 'Semantic view for financial analytics, billing, revenue trends, and usage patterns';


-- =============================================================================
-- Semantic View 3: Support & Service Analytics
-- Covers: support tickets, customers, customer feedback
-- =============================================================================
CREATE OR REPLACE SEMANTIC VIEW CCI_INTELLIGENCE.ANALYTICS.CCI_SUPPORT_SV

  TABLES (
    SUPPORT_TICKETS AS CCI_INTELLIGENCE.RAW.SUPPORT_TICKETS
      PRIMARY KEY (TICKET_ID)
      WITH SYNONYMS ('ticket', 'tickets', 'support', 'support ticket', 'case', 'cases', 'issue', 'issues'),
    CUSTOMERS AS CCI_INTELLIGENCE.RAW.CUSTOMERS
      PRIMARY KEY (CUSTOMER_ID)
      WITH SYNONYMS ('customer', 'customers'),
    CUSTOMER_FEEDBACK AS CCI_INTELLIGENCE.RAW.CUSTOMER_FEEDBACK
      PRIMARY KEY (FEEDBACK_ID)
      WITH SYNONYMS ('feedback', 'survey', 'review', 'nps')
  )

  RELATIONSHIPS (
    SUPPORT_TICKETS (CUSTOMER_ID) REFERENCES CUSTOMERS,
    CUSTOMER_FEEDBACK (CUSTOMER_ID) REFERENCES CUSTOMERS
  )

  FACTS (
    SUPPORT_TICKETS.SATISFACTION_SCORE AS SUPPORT_TICKETS.SATISFACTION_SCORE
      WITH SYNONYMS ('csat', 'satisfaction', 'rating'),
    SUPPORT_TICKETS.RESOLUTION_HOURS AS
      DATEDIFF(HOUR, SUPPORT_TICKETS.CREATED_DATE, SUPPORT_TICKETS.RESOLVED_DATE)
      WITH SYNONYMS ('resolution time', 'time to resolve', 'resolution hours'),
    CUSTOMER_FEEDBACK.NPS_SCORE AS CUSTOMER_FEEDBACK.NPS_SCORE
      WITH SYNONYMS ('nps', 'net promoter score', 'nps score'),
    CUSTOMER_FEEDBACK.CSAT_SCORE AS CUSTOMER_FEEDBACK.CSAT_SCORE
      WITH SYNONYMS ('csat score', 'customer satisfaction score')
  )

  DIMENSIONS (
    SUPPORT_TICKETS.TICKET_ID AS SUPPORT_TICKETS.TICKET_ID
      WITH SYNONYMS ('ticket id', 'case id', 'issue id'),
    SUPPORT_TICKETS.TICKET_CATEGORY AS SUPPORT_TICKETS.CATEGORY
      WITH SYNONYMS ('ticket category', 'issue category', 'type'),
    SUPPORT_TICKETS.SUBCATEGORY AS SUPPORT_TICKETS.SUBCATEGORY
      WITH SYNONYMS ('subcategory', 'issue subcategory'),
    SUPPORT_TICKETS.TICKET_PRIORITY AS SUPPORT_TICKETS.PRIORITY
      WITH SYNONYMS ('ticket priority', 'urgency'),
    SUPPORT_TICKETS.TICKET_STATUS AS SUPPORT_TICKETS.STATUS
      WITH SYNONYMS ('ticket status', 'case status'),
    SUPPORT_TICKETS.CHANNEL AS SUPPORT_TICKETS.CHANNEL
      WITH SYNONYMS ('support channel', 'contact channel'),
    SUPPORT_TICKETS.CREATED_DATE AS SUPPORT_TICKETS.CREATED_DATE
      WITH SYNONYMS ('created date', 'ticket date', 'opened date'),
    SUPPORT_TICKETS.TICKET_MONTH AS DATE_TRUNC('MONTH', SUPPORT_TICKETS.CREATED_DATE)
      WITH SYNONYMS ('ticket month', 'support month'),

    CUSTOMERS.CUSTOMER_ID AS CUSTOMERS.CUSTOMER_ID
      WITH SYNONYMS ('customer id'),
    CUSTOMERS.CUSTOMER_SEGMENT AS CUSTOMERS.CUSTOMER_SEGMENT
      WITH SYNONYMS ('segment', 'customer segment'),

    CUSTOMER_FEEDBACK.FEEDBACK_TYPE AS CUSTOMER_FEEDBACK.FEEDBACK_TYPE
      WITH SYNONYMS ('feedback type', 'survey type'),
    CUSTOMER_FEEDBACK.FEEDBACK_DATE AS CUSTOMER_FEEDBACK.FEEDBACK_DATE
      WITH SYNONYMS ('feedback date', 'survey date')
  )

  METRICS (
    SUPPORT_TICKETS.TICKET_COUNT AS COUNT(SUPPORT_TICKETS.TICKET_ID)
      WITH SYNONYMS ('ticket count', 'number of tickets', 'total tickets'),
    SUPPORT_TICKETS.RESOLVED_COUNT AS COUNT_IF(SUPPORT_TICKETS.STATUS = 'Resolved')
      WITH SYNONYMS ('resolved count', 'tickets resolved'),
    SUPPORT_TICKETS.AVG_SATISFACTION AS AVG(SUPPORT_TICKETS.SATISFACTION_SCORE)
      WITH SYNONYMS ('average satisfaction', 'mean csat', 'avg csat'),
    SUPPORT_TICKETS.AVG_RESOLUTION_HOURS AS AVG(SUPPORT_TICKETS.RESOLUTION_HOURS)
      WITH SYNONYMS ('average resolution time', 'mean resolution hours'),
    CUSTOMER_FEEDBACK.AVG_NPS AS AVG(CUSTOMER_FEEDBACK.NPS_SCORE)
      WITH SYNONYMS ('average nps', 'mean nps'),
    CUSTOMER_FEEDBACK.AVG_CSAT AS AVG(CUSTOMER_FEEDBACK.CSAT_SCORE)
      WITH SYNONYMS ('average csat', 'mean csat score'),
    CUSTOMER_FEEDBACK.FEEDBACK_COUNT AS COUNT(CUSTOMER_FEEDBACK.FEEDBACK_ID)
      WITH SYNONYMS ('feedback count', 'number of feedbacks')
  )

  COMMENT = 'Semantic view for support ticket analytics, customer satisfaction, and feedback analysis';

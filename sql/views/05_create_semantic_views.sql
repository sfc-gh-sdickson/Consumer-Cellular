USE DATABASE CCI_INTELLIGENCE;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE SEMANTIC VIEW CCI_CUSTOMER_ANALYTICS_SV
  COMMENT = 'Semantic view for Consumer Cellular customer analytics and business intelligence queries'
AS
  TABLES (
    CCI_INTELLIGENCE.RAW.CUSTOMERS
      WITH SYNONYMS ('customer', 'customers', 'subscriber', 'subscribers', 'member', 'members')
      COLUMNS (
        CUSTOMER_ID
          WITH SYNONYMS ('customer id', 'cust id', 'subscriber id', 'member id'),
        FIRST_NAME
          WITH SYNONYMS ('first name', 'given name'),
        LAST_NAME
          WITH SYNONYMS ('last name', 'surname', 'family name'),
        EMAIL
          WITH SYNONYMS ('email address', 'email'),
        PHONE
          WITH SYNONYMS ('phone number', 'contact number', 'telephone'),
        AGE
          WITH SYNONYMS ('customer age', 'years old'),
        SIGNUP_DATE
          WITH SYNONYMS ('signup date', 'registration date', 'join date', 'enrollment date'),
        CUSTOMER_SEGMENT
          WITH SYNONYMS ('segment', 'customer type', 'category'),
        AARP_MEMBER
          WITH SYNONYMS ('aarp', 'aarp membership', 'aarp status')
      ),
    CCI_INTELLIGENCE.RAW.PLANS
      WITH SYNONYMS ('plan', 'plans', 'service plan', 'rate plan', 'pricing plan')
      COLUMNS (
        PLAN_ID
          WITH SYNONYMS ('plan id', 'plan identifier'),
        PLAN_NAME
          WITH SYNONYMS ('plan name', 'plan title'),
        PLAN_TYPE
          WITH SYNONYMS ('plan type', 'plan category', 'tier'),
        MONTHLY_PRICE
          WITH SYNONYMS ('price', 'monthly cost', 'monthly rate', 'plan price'),
        DATA_LIMIT_GB
          WITH SYNONYMS ('data limit', 'data allowance', 'gb limit'),
        UNLIMITED_DATA
          WITH SYNONYMS ('unlimited data', 'no data limit')
      ),
    CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS
      WITH SYNONYMS ('subscription', 'subscriptions', 'account', 'service')
      COLUMNS (
        SUBSCRIPTION_ID
          WITH SYNONYMS ('subscription id', 'account id'),
        STATUS
          WITH SYNONYMS ('subscription status', 'account status', 'service status'),
        START_DATE
          WITH SYNONYMS ('start date', 'activation date'),
        AUTO_PAY_ENABLED
          WITH SYNONYMS ('autopay', 'auto pay', 'automatic payment')
      ),
    CCI_INTELLIGENCE.RAW.BILLING
      WITH SYNONYMS ('billing', 'bills', 'invoice', 'invoices', 'payment', 'payments')
      COLUMNS (
        BILLING_ID
          WITH SYNONYMS ('billing id', 'invoice id', 'bill id'),
        BILLING_DATE
          WITH SYNONYMS ('billing date', 'invoice date', 'bill date'),
        TOTAL_AMOUNT
          WITH SYNONYMS ('total', 'amount', 'bill amount', 'invoice amount', 'charge'),
        PLAN_CHARGE
          WITH SYNONYMS ('plan charge', 'service charge', 'monthly charge'),
        OVERAGE_CHARGES
          WITH SYNONYMS ('overage', 'extra charges', 'additional charges'),
        PAYMENT_STATUS
          WITH SYNONYMS ('payment status', 'paid status', 'billing status')
      ),
    CCI_INTELLIGENCE.RAW.SUPPORT_TICKETS
      WITH SYNONYMS ('ticket', 'tickets', 'support', 'support ticket', 'case', 'cases', 'issue', 'issues')
      COLUMNS (
        TICKET_ID
          WITH SYNONYMS ('ticket id', 'case id', 'issue id'),
        CATEGORY
          WITH SYNONYMS ('ticket category', 'issue category', 'type'),
        PRIORITY
          WITH SYNONYMS ('ticket priority', 'urgency'),
        STATUS
          WITH SYNONYMS ('ticket status', 'case status'),
        SATISFACTION_SCORE
          WITH SYNONYMS ('csat', 'satisfaction', 'rating')
      ),
    CCI_INTELLIGENCE.RAW.CHURN_PREDICTIONS
      WITH SYNONYMS ('churn', 'churn prediction', 'churn risk', 'attrition')
      COLUMNS (
        CHURN_PROBABILITY
          WITH SYNONYMS ('churn probability', 'churn likelihood', 'churn score'),
        CHURN_RISK_LEVEL
          WITH SYNONYMS ('risk level', 'churn risk', 'risk category')
      ),
    CCI_INTELLIGENCE.RAW.CUSTOMER_LTV
      WITH SYNONYMS ('ltv', 'lifetime value', 'customer value', 'clv')
      COLUMNS (
        PREDICTED_LIFETIME_VALUE
          WITH SYNONYMS ('ltv', 'lifetime value', 'customer lifetime value', 'clv'),
        LTV_SEGMENT
          WITH SYNONYMS ('ltv segment', 'value segment', 'customer tier'),
        AVG_MONTHLY_REVENUE
          WITH SYNONYMS ('arpu', 'average revenue', 'monthly revenue')
      )
  )
  RELATIONSHIPS (
    CCI_INTELLIGENCE.RAW.CUSTOMERS (CUSTOMER_ID) REFERENCES CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS (CUSTOMER_ID),
    CCI_INTELLIGENCE.RAW.CUSTOMERS (CUSTOMER_ID) REFERENCES CCI_INTELLIGENCE.RAW.BILLING (CUSTOMER_ID),
    CCI_INTELLIGENCE.RAW.CUSTOMERS (CUSTOMER_ID) REFERENCES CCI_INTELLIGENCE.RAW.SUPPORT_TICKETS (CUSTOMER_ID),
    CCI_INTELLIGENCE.RAW.CUSTOMERS (CUSTOMER_ID) REFERENCES CCI_INTELLIGENCE.RAW.CHURN_PREDICTIONS (CUSTOMER_ID),
    CCI_INTELLIGENCE.RAW.CUSTOMERS (CUSTOMER_ID) REFERENCES CCI_INTELLIGENCE.RAW.CUSTOMER_LTV (CUSTOMER_ID),
    CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS (PLAN_ID) REFERENCES CCI_INTELLIGENCE.RAW.PLANS (PLAN_ID),
    CCI_INTELLIGENCE.RAW.BILLING (SUBSCRIPTION_ID) REFERENCES CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS (SUBSCRIPTION_ID)
  );

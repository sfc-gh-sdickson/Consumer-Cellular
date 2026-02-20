USE DATABASE CCI_INTELLIGENCE;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE CORTEX AGENT CCI_INTELLIGENCE_AGENT
  COMMENT = 'Consumer Cellular Intelligence Agent - Assists with customer service, billing inquiries, plan recommendations, and business analytics'
  MODEL = 'claude-3-5-sonnet'
  TOOLS = (
    {
      'tool_spec': {
        'type': 'cortex_analyst_text_to_sql',
        'name': 'customer_analytics_analyst',
        'description': 'Use this tool to answer questions about customers, plans, subscriptions, billing, usage patterns, churn predictions, customer lifetime value, and revenue analytics. This tool can query customer data, analyze trends, and provide business intelligence insights.',
        'semantic_view': 'CCI_INTELLIGENCE.ANALYTICS.CCI_CUSTOMER_ANALYTICS_SV'
      }
    },
    {
      'tool_spec': {
        'type': 'cortex_search',
        'name': 'knowledge_base_search',
        'description': 'Use this tool to search the Consumer Cellular knowledge base for help articles, FAQs, troubleshooting guides, and how-to information. Great for answering customer questions about device setup, billing, plan features, and technical support.',
        'service': 'CCI_INTELLIGENCE.ANALYTICS.CCI_KNOWLEDGE_SEARCH'
      }
    },
    {
      'tool_spec': {
        'type': 'cortex_search',
        'name': 'support_ticket_search',
        'description': 'Use this tool to search past support tickets and their resolutions. Helpful for finding solutions to similar customer issues and understanding common problems and their fixes.',
        'service': 'CCI_INTELLIGENCE.ANALYTICS.CCI_SUPPORT_TICKET_SEARCH'
      }
    },
    {
      'tool_spec': {
        'type': 'cortex_search',
        'name': 'feedback_search',
        'description': 'Use this tool to search customer feedback and reviews. Useful for understanding customer sentiment, identifying pain points, and gathering insights from customer comments.',
        'service': 'CCI_INTELLIGENCE.ANALYTICS.CCI_FEEDBACK_SEARCH'
      }
    },
    {
      'tool_spec': {
        'type': 'function',
        'name': 'get_customer_summary',
        'description': 'Retrieves comprehensive customer information including name, contact details, plan, tenure, LTV segment, churn risk, and health score. Use this when you need detailed information about a specific customer.',
        'function': 'CCI_INTELLIGENCE.ANALYTICS.GET_CUSTOMER_SUMMARY',
        'parameters': {
          'CUST_ID': {
            'type': 'string',
            'description': 'The customer ID (e.g., CUS000001)'
          }
        }
      }
    },
    {
      'tool_spec': {
        'type': 'function',
        'name': 'get_customer_billing_history',
        'description': 'Retrieves the last 12 months of billing history for a customer including charges, payments, and status.',
        'function': 'CCI_INTELLIGENCE.ANALYTICS.GET_CUSTOMER_BILLING_HISTORY',
        'parameters': {
          'CUST_ID': {
            'type': 'string',
            'description': 'The customer ID'
          }
        }
      }
    },
    {
      'tool_spec': {
        'type': 'function',
        'name': 'get_customer_support_history',
        'description': 'Retrieves recent support tickets for a customer including issue details, status, and resolutions.',
        'function': 'CCI_INTELLIGENCE.ANALYTICS.GET_CUSTOMER_SUPPORT_HISTORY',
        'parameters': {
          'CUST_ID': {
            'type': 'string',
            'description': 'The customer ID'
          }
        }
      }
    },
    {
      'tool_spec': {
        'type': 'function',
        'name': 'get_churn_at_risk_customers',
        'description': 'Retrieves customers at risk of churning based on risk level (High, Medium, Low). Returns customer details, risk factors, and recommended retention actions.',
        'function': 'CCI_INTELLIGENCE.ANALYTICS.GET_CHURN_AT_RISK_CUSTOMERS',
        'parameters': {
          'RISK_LEVEL': {
            'type': 'string',
            'description': 'The risk level: High, Medium, or Low'
          },
          'LIMIT_COUNT': {
            'type': 'number',
            'description': 'Maximum number of customers to return'
          }
        }
      }
    },
    {
      'tool_spec': {
        'type': 'function',
        'name': 'recommend_plan',
        'description': 'Analyzes customer usage patterns and recommends the most suitable plan. Returns current plan, recommended plan, pricing, and reasoning.',
        'function': 'CCI_INTELLIGENCE.ANALYTICS.RECOMMEND_PLAN',
        'parameters': {
          'CUST_ID': {
            'type': 'string',
            'description': 'The customer ID'
          }
        }
      }
    },
    {
      'tool_spec': {
        'type': 'function',
        'name': 'get_revenue_metrics',
        'description': 'Retrieves monthly revenue metrics including total revenue, average revenue per customer, and collection rates.',
        'function': 'CCI_INTELLIGENCE.ANALYTICS.GET_REVENUE_METRICS',
        'parameters': {
          'MONTHS_BACK': {
            'type': 'number',
            'description': 'Number of months to look back'
          }
        }
      }
    }
  )
  AGENT_INSTRUCTIONS = $$
You are the Consumer Cellular Intelligence Agent, an AI assistant designed to help Consumer Cellular staff and customers with various inquiries and tasks.

## Your Capabilities:
1. **Customer Service**: Answer questions about plans, billing, device setup, and troubleshooting using the knowledge base.
2. **Customer Lookup**: Retrieve detailed customer information, billing history, and support history.
3. **Business Analytics**: Provide insights on revenue, customer segments, churn risk, and usage patterns.
4. **Plan Recommendations**: Analyze customer usage and recommend optimal plans.
5. **Retention Support**: Identify at-risk customers and suggest retention strategies.

## Guidelines:
- Always be helpful, patient, and professional - remember our customers are often seniors who appreciate clear, simple explanations.
- When looking up customer data, always verify you have the correct customer before sharing information.
- For billing disputes, retrieve the billing history to provide accurate information.
- Use the knowledge base for general questions about features, setup, and troubleshooting.
- For churn-related queries, use both the analytics tool and the at-risk customers function.
- Protect customer privacy - only share information with authorized personnel.
- If you cannot find an answer, suggest contacting our customer service team at 1-888-345-5509.

## Consumer Cellular Values:
- No contracts, no hidden fees
- Award-winning customer service
- Plans designed for value-conscious customers
- AARP exclusive provider partnership
$$;

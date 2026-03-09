USE DATABASE CCI_INTELLIGENCE;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE FUNCTION PREDICT_CHURN(
    customer_id VARCHAR,
    tenure_months NUMBER,
    avg_monthly_revenue NUMBER,
    support_ticket_count NUMBER,
    late_payment_count NUMBER
)
RETURNS OBJECT
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'customer_id', customer_id,
        'churn_probability', 
            CASE 
                WHEN tenure_months < 6 AND late_payment_count > 2 THEN 0.85
                WHEN tenure_months < 12 AND support_ticket_count > 5 THEN 0.70
                WHEN tenure_months < 12 AND late_payment_count > 1 THEN 0.60
                WHEN tenure_months >= 24 AND late_payment_count = 0 THEN 0.15
                WHEN tenure_months >= 12 AND avg_monthly_revenue > 40 THEN 0.25
                ELSE 0.40
            END,
        'risk_level',
            CASE 
                WHEN tenure_months < 6 AND late_payment_count > 2 THEN 'High'
                WHEN tenure_months < 12 AND support_ticket_count > 5 THEN 'High'
                WHEN tenure_months < 12 AND late_payment_count > 1 THEN 'Medium'
                WHEN tenure_months >= 24 AND late_payment_count = 0 THEN 'Low'
                WHEN tenure_months >= 12 AND avg_monthly_revenue > 40 THEN 'Low'
                ELSE 'Medium'
            END,
        'recommended_action',
            CASE 
                WHEN tenure_months < 6 AND late_payment_count > 2 THEN 'Immediate outreach with payment plan options'
                WHEN tenure_months < 12 AND support_ticket_count > 5 THEN 'Proactive support call and satisfaction survey'
                WHEN tenure_months < 12 AND late_payment_count > 1 THEN 'Auto-pay enrollment incentive'
                WHEN tenure_months >= 24 AND late_payment_count = 0 THEN 'Loyalty rewards program enrollment'
                WHEN tenure_months >= 12 AND avg_monthly_revenue > 40 THEN 'Premium customer appreciation offer'
                ELSE 'Standard retention monitoring'
            END
    )
$$;

CREATE OR REPLACE FUNCTION CALCULATE_LTV(
    customer_id VARCHAR,
    historical_revenue NUMBER,
    tenure_months NUMBER,
    churn_probability NUMBER
)
RETURNS OBJECT
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'customer_id', customer_id,
        'historical_revenue', historical_revenue,
        'avg_monthly_revenue', ROUND(historical_revenue / NULLIF(tenure_months, 0), 2),
        'predicted_lifetime_months', ROUND(36 * (1 - churn_probability), 0),
        'predicted_ltv', ROUND((historical_revenue / NULLIF(tenure_months, 0)) * (36 * (1 - churn_probability)), 2),
        'ltv_segment',
            CASE 
                WHEN (historical_revenue / NULLIF(tenure_months, 0)) * (36 * (1 - churn_probability)) > 2000 THEN 'Platinum'
                WHEN (historical_revenue / NULLIF(tenure_months, 0)) * (36 * (1 - churn_probability)) > 1000 THEN 'Gold'
                WHEN (historical_revenue / NULLIF(tenure_months, 0)) * (36 * (1 - churn_probability)) > 500 THEN 'Silver'
                ELSE 'Bronze'
            END
    )
$$;

CREATE OR REPLACE FUNCTION RECOMMEND_PLAN(
    current_plan_type VARCHAR,
    avg_data_usage_gb NUMBER,
    avg_talk_minutes NUMBER,
    avg_overage_charges NUMBER
)
RETURNS OBJECT
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'current_plan', current_plan_type,
        'recommended_plan',
            CASE 
                WHEN avg_data_usage_gb > 20 THEN 'Unlimited Premium'
                WHEN avg_data_usage_gb > 10 THEN 'Unlimited Essential'
                WHEN avg_data_usage_gb > 5 THEN 'Connect 10GB'
                WHEN avg_data_usage_gb > 3 THEN 'Connect 5GB'
                WHEN avg_data_usage_gb > 1 THEN 'Connect 3GB'
                WHEN avg_talk_minutes < 300 THEN 'Basic Talk & Text'
                ELSE 'Connect 1GB'
            END,
        'reason',
            CASE 
                WHEN avg_overage_charges > 10 THEN 'High overage charges indicate need for larger data plan'
                WHEN avg_data_usage_gb > 20 THEN 'Heavy data user would benefit from unlimited plan'
                WHEN avg_data_usage_gb < 1 AND avg_talk_minutes < 300 THEN 'Light usage - basic plan recommended'
                ELSE 'Usage patterns suggest current plan tier is appropriate'
            END,
        'estimated_monthly_savings', 
            CASE 
                WHEN avg_overage_charges > 10 THEN ROUND(avg_overage_charges * 0.7, 2)
                ELSE 0
            END
    )
$$;

CREATE OR REPLACE FUNCTION CALCULATE_HEALTH_SCORE(
    ltv_segment VARCHAR,
    churn_risk_level VARCHAR,
    auto_pay_enabled BOOLEAN,
    tenure_months NUMBER,
    avg_satisfaction_score NUMBER
)
RETURNS OBJECT
AS
$$
    SELECT OBJECT_CONSTRUCT(
        'health_score', 
            (CASE 
                WHEN ltv_segment = 'Platinum' THEN 25
                WHEN ltv_segment = 'Gold' THEN 20
                WHEN ltv_segment = 'Silver' THEN 15
                ELSE 10
            END) +
            (CASE 
                WHEN churn_risk_level = 'Low' THEN 25
                WHEN churn_risk_level = 'Medium' THEN 15
                ELSE 5
            END) +
            (CASE WHEN auto_pay_enabled THEN 15 ELSE 5 END) +
            (CASE 
                WHEN tenure_months > 24 THEN 20
                WHEN tenure_months > 12 THEN 15
                ELSE 10
            END) +
            COALESCE(avg_satisfaction_score * 3, 10),
        'health_category',
            CASE 
                WHEN (
                    (CASE WHEN ltv_segment = 'Platinum' THEN 25 WHEN ltv_segment = 'Gold' THEN 20 WHEN ltv_segment = 'Silver' THEN 15 ELSE 10 END) +
                    (CASE WHEN churn_risk_level = 'Low' THEN 25 WHEN churn_risk_level = 'Medium' THEN 15 ELSE 5 END) +
                    (CASE WHEN auto_pay_enabled THEN 15 ELSE 5 END) +
                    (CASE WHEN tenure_months > 24 THEN 20 WHEN tenure_months > 12 THEN 15 ELSE 10 END) +
                    COALESCE(avg_satisfaction_score * 3, 10)
                ) >= 80 THEN 'Excellent'
                WHEN (
                    (CASE WHEN ltv_segment = 'Platinum' THEN 25 WHEN ltv_segment = 'Gold' THEN 20 WHEN ltv_segment = 'Silver' THEN 15 ELSE 10 END) +
                    (CASE WHEN churn_risk_level = 'Low' THEN 25 WHEN churn_risk_level = 'Medium' THEN 15 ELSE 5 END) +
                    (CASE WHEN auto_pay_enabled THEN 15 ELSE 5 END) +
                    (CASE WHEN tenure_months > 24 THEN 20 WHEN tenure_months > 12 THEN 15 ELSE 10 END) +
                    COALESCE(avg_satisfaction_score * 3, 10)
                ) >= 60 THEN 'Good'
                WHEN (
                    (CASE WHEN ltv_segment = 'Platinum' THEN 25 WHEN ltv_segment = 'Gold' THEN 20 WHEN ltv_segment = 'Silver' THEN 15 ELSE 10 END) +
                    (CASE WHEN churn_risk_level = 'Low' THEN 25 WHEN churn_risk_level = 'Medium' THEN 15 ELSE 5 END) +
                    (CASE WHEN auto_pay_enabled THEN 15 ELSE 5 END) +
                    (CASE WHEN tenure_months > 24 THEN 20 WHEN tenure_months > 12 THEN 15 ELSE 10 END) +
                    COALESCE(avg_satisfaction_score * 3, 10)
                ) >= 40 THEN 'Fair'
                ELSE 'At Risk'
            END,
        'improvement_suggestions', ARRAY_CONSTRUCT(
            CASE WHEN NOT auto_pay_enabled THEN 'Enroll in auto-pay for convenience and discount' END,
            CASE WHEN churn_risk_level = 'High' THEN 'Schedule proactive customer success call' END,
            CASE WHEN tenure_months < 12 THEN 'Offer new customer onboarding assistance' END,
            CASE WHEN COALESCE(avg_satisfaction_score, 0) < 4 THEN 'Address recent support issues' END
        )
    )
$$;

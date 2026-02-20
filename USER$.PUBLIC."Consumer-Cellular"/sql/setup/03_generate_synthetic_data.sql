USE DATABASE CCI_INTELLIGENCE;
USE SCHEMA RAW;

INSERT INTO PLANS (PLAN_ID, PLAN_NAME, PLAN_TYPE, MONTHLY_PRICE, DATA_LIMIT_GB, TALK_MINUTES, TEXT_LIMIT, UNLIMITED_DATA, UNLIMITED_TALK, UNLIMITED_TEXT, NETWORK_CARRIER, FEATURES)
VALUES
('PLN001', 'Basic Talk & Text', 'Basic', 15.00, 0, 250, 1000, FALSE, FALSE, FALSE, 'AT&T', 'Nationwide coverage, Voicemail'),
('PLN002', 'Connect 1GB', 'Standard', 20.00, 1, 1000, 5000, FALSE, FALSE, FALSE, 'AT&T', 'Nationwide coverage, Voicemail, Caller ID'),
('PLN003', 'Connect 3GB', 'Standard', 25.00, 3, 1500, 10000, FALSE, FALSE, TRUE, 'AT&T', 'Nationwide coverage, Voicemail, Caller ID, WiFi Calling'),
('PLN004', 'Connect 5GB', 'Premium', 30.00, 5, NULL, NULL, FALSE, TRUE, TRUE, 'AT&T', 'Nationwide coverage, Unlimited Talk & Text, WiFi Calling, HD Voice'),
('PLN005', 'Connect 10GB', 'Premium', 35.00, 10, NULL, NULL, FALSE, TRUE, TRUE, 'AT&T', 'Nationwide coverage, Unlimited Talk & Text, WiFi Calling, HD Voice, Hotspot'),
('PLN006', 'Unlimited Essential', 'Unlimited', 45.00, 25, NULL, NULL, TRUE, TRUE, TRUE, 'AT&T', 'Unlimited everything, 25GB premium data, WiFi Calling, HD Voice'),
('PLN007', 'Unlimited Premium', 'Unlimited', 55.00, 50, NULL, NULL, TRUE, TRUE, TRUE, 'AT&T', 'Unlimited everything, 50GB premium data, WiFi Calling, HD Voice, 15GB Hotspot'),
('PLN008', 'Senior Saver Basic', 'Senior', 12.00, 0, 200, 500, FALSE, FALSE, FALSE, 'AT&T', 'Easy setup, Large display support, Priority support'),
('PLN009', 'Senior Saver Plus', 'Senior', 22.00, 2, NULL, NULL, FALSE, TRUE, TRUE, 'AT&T', 'Easy setup, Unlimited Talk & Text, Priority support, Family Safety features'),
('PLN010', 'Family Connect 20GB', 'Family', 60.00, 20, NULL, NULL, FALSE, TRUE, TRUE, 'AT&T', 'Shared data, Up to 4 lines, Unlimited Talk & Text, Family locator');

INSERT INTO CUSTOMERS (CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, DATE_OF_BIRTH, AGE, SIGNUP_DATE, CUSTOMER_SEGMENT, PREFERRED_CONTACT_METHOD, AARP_MEMBER, REFERRAL_SOURCE)
SELECT 
    'CUS' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    CASE MOD(SEQ4(), 20) 
        WHEN 0 THEN 'Margaret' WHEN 1 THEN 'Robert' WHEN 2 THEN 'Patricia' WHEN 3 THEN 'William'
        WHEN 4 THEN 'Barbara' WHEN 5 THEN 'Richard' WHEN 6 THEN 'Susan' WHEN 7 THEN 'Joseph'
        WHEN 8 THEN 'Dorothy' WHEN 9 THEN 'Thomas' WHEN 10 THEN 'Betty' WHEN 11 THEN 'Charles'
        WHEN 12 THEN 'Nancy' WHEN 13 THEN 'Daniel' WHEN 14 THEN 'Karen' WHEN 15 THEN 'George'
        WHEN 16 THEN 'Helen' WHEN 17 THEN 'Ronald' WHEN 18 THEN 'Sandra' ELSE 'Kenneth'
    END,
    CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'Johnson' WHEN 1 THEN 'Williams' WHEN 2 THEN 'Brown' WHEN 3 THEN 'Davis'
        WHEN 4 THEN 'Miller' WHEN 5 THEN 'Wilson' WHEN 6 THEN 'Moore' WHEN 7 THEN 'Taylor'
        WHEN 8 THEN 'Anderson' WHEN 9 THEN 'Thomas' WHEN 10 THEN 'Jackson' WHEN 11 THEN 'White'
        WHEN 12 THEN 'Harris' WHEN 13 THEN 'Martin' ELSE 'Thompson'
    END,
    LOWER(CASE MOD(SEQ4(), 20) 
        WHEN 0 THEN 'margaret' WHEN 1 THEN 'robert' WHEN 2 THEN 'patricia' WHEN 3 THEN 'william'
        WHEN 4 THEN 'barbara' WHEN 5 THEN 'richard' WHEN 6 THEN 'susan' WHEN 7 THEN 'joseph'
        WHEN 8 THEN 'dorothy' WHEN 9 THEN 'thomas' WHEN 10 THEN 'betty' WHEN 11 THEN 'charles'
        WHEN 12 THEN 'nancy' WHEN 13 THEN 'daniel' WHEN 14 THEN 'karen' WHEN 15 THEN 'george'
        WHEN 16 THEN 'helen' WHEN 17 THEN 'ronald' WHEN 18 THEN 'sandra' ELSE 'kenneth'
    END) || '.' || CASE MOD(SEQ4(), 15)
        WHEN 0 THEN 'johnson' WHEN 1 THEN 'williams' WHEN 2 THEN 'brown' WHEN 3 THEN 'davis'
        WHEN 4 THEN 'miller' WHEN 5 THEN 'wilson' WHEN 6 THEN 'moore' WHEN 7 THEN 'taylor'
        WHEN 8 THEN 'anderson' WHEN 9 THEN 'thomas' WHEN 10 THEN 'jackson' WHEN 11 THEN 'white'
        WHEN 12 THEN 'harris' WHEN 13 THEN 'martin' ELSE 'thompson'
    END || SEQ4()::VARCHAR || '@email.com',
    '555-' || LPAD((100 + MOD(SEQ4(), 900))::VARCHAR, 3, '0') || '-' || LPAD((1000 + MOD(SEQ4() * 7, 9000))::VARCHAR, 4, '0'),
    DATEADD(DAY, -UNIFORM(20000, 30000, RANDOM()), CURRENT_DATE()),
    DATEDIFF(YEAR, DATEADD(DAY, -UNIFORM(20000, 30000, RANDOM()), CURRENT_DATE()), CURRENT_DATE()),
    DATEADD(DAY, -UNIFORM(0, 1825, RANDOM()), CURRENT_DATE()),
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Senior'
        WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Value Seeker'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Family'
        ELSE 'Digital Native'
    END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Phone' WHEN 1 THEN 'Email' WHEN 2 THEN 'Mail' ELSE 'SMS' END,
    UNIFORM(1, 100, RANDOM()) <= 45,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'AARP Recommendation' WHEN 1 THEN 'TV Advertisement'
        WHEN 2 THEN 'Friend/Family Referral' WHEN 3 THEN 'Web Search'
        WHEN 4 THEN 'Print Advertisement' ELSE 'Retail Store'
    END
FROM TABLE(GENERATOR(ROWCOUNT => 5000));

INSERT INTO SUBSCRIPTIONS (SUBSCRIPTION_ID, CUSTOMER_ID, PLAN_ID, START_DATE, END_DATE, STATUS, AUTO_PAY_ENABLED, PAYMENT_METHOD, MONTHLY_BILL)
SELECT 
    'SUB' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    c.CUSTOMER_ID,
    p.PLAN_ID,
    c.SIGNUP_DATE,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 10 THEN DATEADD(DAY, UNIFORM(30, 365, RANDOM()), c.SIGNUP_DATE) ELSE NULL END,
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Active'
        WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Suspended'
        ELSE 'Cancelled'
    END,
    UNIFORM(1, 100, RANDOM()) <= 70,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Credit Card' WHEN 1 THEN 'Bank Transfer' WHEN 2 THEN 'Check' ELSE 'PayPal' END,
    p.MONTHLY_PRICE + UNIFORM(0, 15, RANDOM())
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c
CROSS JOIN (SELECT PLAN_ID, MONTHLY_PRICE FROM CCI_INTELLIGENCE.RAW.PLANS ORDER BY RANDOM() LIMIT 1) p;

UPDATE CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS sub
SET PLAN_ID = (SELECT PLAN_ID FROM CCI_INTELLIGENCE.RAW.PLANS ORDER BY RANDOM() LIMIT 1),
    MONTHLY_BILL = (SELECT MONTHLY_PRICE FROM CCI_INTELLIGENCE.RAW.PLANS ORDER BY RANDOM() LIMIT 1) + UNIFORM(0, 15, RANDOM());

INSERT INTO DEVICES (DEVICE_ID, CUSTOMER_ID, DEVICE_BRAND, DEVICE_MODEL, DEVICE_TYPE, IMEI, PURCHASE_DATE, PURCHASE_TYPE, DEVICE_PRICE, WARRANTY_END_DATE)
SELECT 
    'DEV' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    c.CUSTOMER_ID,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Apple' WHEN 1 THEN 'Samsung' WHEN 2 THEN 'Motorola'
        WHEN 3 THEN 'LG' WHEN 4 THEN 'Nokia' WHEN 5 THEN 'Alcatel'
        WHEN 6 THEN 'Doro' ELSE 'Jitterbug'
    END,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'iPhone SE' WHEN 1 THEN 'Galaxy A14' WHEN 2 THEN 'Moto G Power'
        WHEN 3 THEN 'LG K51' WHEN 4 THEN 'Nokia G20' WHEN 5 THEN 'Alcatel Go Flip'
        WHEN 6 THEN 'Doro 7050' ELSE 'Jitterbug Flip2'
    END,
    CASE WHEN MOD(SEQ4(), 10) < 7 THEN 'Smartphone' ELSE 'Flip Phone' END,
    LPAD(UNIFORM(100000000000000, 999999999999999, RANDOM())::VARCHAR, 15, '0'),
    DATEADD(DAY, UNIFORM(0, 30, RANDOM()), c.SIGNUP_DATE),
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Full Purchase' WHEN 1 THEN 'Payment Plan' ELSE 'BYOD' END,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 429.00 WHEN 1 THEN 199.00 WHEN 2 THEN 249.00
        WHEN 3 THEN 149.00 WHEN 4 THEN 179.00 WHEN 5 THEN 99.00
        WHEN 6 THEN 79.00 ELSE 69.00
    END,
    DATEADD(YEAR, 1, DATEADD(DAY, UNIFORM(0, 30, RANDOM()), c.SIGNUP_DATE))
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c;

INSERT INTO USAGE_DATA (USAGE_ID, CUSTOMER_ID, SUBSCRIPTION_ID, USAGE_DATE, USAGE_MONTH, DATA_USED_GB, TALK_MINUTES_USED, TEXTS_SENT, OVERAGE_CHARGES)
SELECT 
    'USG' || LPAD(ROW_NUMBER() OVER (ORDER BY c.CUSTOMER_ID, d.VALUE)::VARCHAR, 8, '0'),
    c.CUSTOMER_ID,
    s.SUBSCRIPTION_ID,
    DATEADD(MONTH, -d.VALUE, DATE_TRUNC('MONTH', CURRENT_DATE())),
    TO_CHAR(DATEADD(MONTH, -d.VALUE, DATE_TRUNC('MONTH', CURRENT_DATE())), 'YYYY-MM'),
    ROUND(UNIFORM(0.1, 8.0, RANDOM())::NUMERIC, 3),
    UNIFORM(50, 1500, RANDOM()),
    UNIFORM(10, 500, RANDOM()),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN ROUND(UNIFORM(1, 25, RANDOM())::NUMERIC, 2) ELSE 0 END
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c
JOIN CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS s ON c.CUSTOMER_ID = s.CUSTOMER_ID
CROSS JOIN TABLE(FLATTEN(ARRAY_GENERATE_RANGE(0, 12))) d
WHERE s.STATUS = 'Active'
LIMIT 50000;

INSERT INTO BILLING (BILLING_ID, CUSTOMER_ID, SUBSCRIPTION_ID, BILLING_DATE, BILLING_PERIOD_START, BILLING_PERIOD_END, PLAN_CHARGE, DEVICE_PAYMENT, TAXES_FEES, OVERAGE_CHARGES, TOTAL_AMOUNT, PAYMENT_STATUS, PAYMENT_DATE)
SELECT 
    'BIL' || LPAD(ROW_NUMBER() OVER (ORDER BY c.CUSTOMER_ID, d.VALUE)::VARCHAR, 8, '0'),
    c.CUSTOMER_ID,
    s.SUBSCRIPTION_ID,
    DATEADD(MONTH, -d.VALUE + 1, DATE_TRUNC('MONTH', CURRENT_DATE())),
    DATEADD(MONTH, -d.VALUE, DATE_TRUNC('MONTH', CURRENT_DATE())),
    DATEADD(DAY, -1, DATEADD(MONTH, -d.VALUE + 1, DATE_TRUNC('MONTH', CURRENT_DATE()))),
    s.MONTHLY_BILL,
    CASE WHEN dv.PURCHASE_TYPE = 'Payment Plan' THEN ROUND(dv.DEVICE_PRICE / 24, 2) ELSE 0 END,
    ROUND(s.MONTHLY_BILL * 0.08, 2),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN ROUND(UNIFORM(1, 25, RANDOM())::NUMERIC, 2) ELSE 0 END,
    ROUND(s.MONTHLY_BILL + (CASE WHEN dv.PURCHASE_TYPE = 'Payment Plan' THEN dv.DEVICE_PRICE / 24 ELSE 0 END) + (s.MONTHLY_BILL * 0.08) + (CASE WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN UNIFORM(1, 25, RANDOM()) ELSE 0 END), 2),
    CASE 
        WHEN d.VALUE > 0 THEN 'Paid'
        WHEN UNIFORM(1, 100, RANDOM()) <= 5 THEN 'Past Due'
        ELSE 'Pending'
    END,
    CASE WHEN d.VALUE > 0 THEN DATEADD(DAY, UNIFORM(1, 15, RANDOM()), DATEADD(MONTH, -d.VALUE + 1, DATE_TRUNC('MONTH', CURRENT_DATE()))) ELSE NULL END
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c
JOIN CCI_INTELLIGENCE.RAW.SUBSCRIPTIONS s ON c.CUSTOMER_ID = s.CUSTOMER_ID
LEFT JOIN CCI_INTELLIGENCE.RAW.DEVICES dv ON c.CUSTOMER_ID = dv.CUSTOMER_ID
CROSS JOIN TABLE(FLATTEN(ARRAY_GENERATE_RANGE(0, 12))) d
WHERE s.STATUS = 'Active'
LIMIT 50000;

INSERT INTO SUPPORT_TICKETS (TICKET_ID, CUSTOMER_ID, CREATED_DATE, RESOLVED_DATE, CATEGORY, SUBCATEGORY, PRIORITY, STATUS, CHANNEL, ISSUE_DESCRIPTION, RESOLUTION_NOTES, AGENT_ID, SATISFACTION_SCORE)
SELECT 
    'TKT' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    c.CUSTOMER_ID,
    DATEADD(DAY, -UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 
        THEN DATEADD(HOUR, UNIFORM(1, 72, RANDOM()), DATEADD(DAY, -UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()))
        ELSE NULL 
    END,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Billing' WHEN 1 THEN 'Technical Support' WHEN 2 THEN 'Account Management'
        WHEN 3 THEN 'Device Support' WHEN 4 THEN 'Plan Changes' WHEN 5 THEN 'Network Issues'
        WHEN 6 THEN 'Activation' ELSE 'General Inquiry'
    END,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Bill Dispute' WHEN 1 THEN 'Connectivity Issues' WHEN 2 THEN 'Password Reset'
        WHEN 3 THEN 'Device Setup' WHEN 4 THEN 'Upgrade Request' WHEN 5 THEN 'Coverage Question'
        WHEN 6 THEN 'SIM Activation' ELSE 'Information Request'
    END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Low' WHEN 1 THEN 'Medium' WHEN 2 THEN 'High' ELSE 'Critical' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Resolved' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'In Progress' ELSE 'Open' END,
    CASE MOD(SEQ4(), 4) WHEN 0 THEN 'Phone' WHEN 1 THEN 'Email' WHEN 2 THEN 'Chat' ELSE 'In-Store' END,
    CASE MOD(SEQ4(), 8)
        WHEN 0 THEN 'Customer reports unexpected charges on their monthly bill'
        WHEN 1 THEN 'Unable to make or receive calls in certain areas'
        WHEN 2 THEN 'Customer needs help resetting their voicemail password'
        WHEN 3 THEN 'Need assistance setting up new smartphone'
        WHEN 4 THEN 'Interested in upgrading to unlimited plan'
        WHEN 5 THEN 'Questions about coverage in their area'
        WHEN 6 THEN 'New SIM card not activating properly'
        ELSE 'General questions about account and services'
    END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Issue resolved to customer satisfaction. Provided step-by-step assistance.' ELSE NULL END,
    'AGT' || LPAD(UNIFORM(1, 50, RANDOM())::VARCHAR, 3, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN UNIFORM(3, 5, RANDOM()) ELSE NULL END
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c
WHERE UNIFORM(1, 100, RANDOM()) <= 30;

INSERT INTO KNOWLEDGE_BASE (ARTICLE_ID, TITLE, CATEGORY, SUBCATEGORY, CONTENT, KEYWORDS, LAST_UPDATED, VIEW_COUNT, HELPFUL_COUNT)
VALUES
('KB001', 'How to Set Up Voicemail on Your Phone', 'Device Support', 'Voicemail', 'Setting up voicemail is easy! First, dial *86 from your Consumer Cellular phone. Follow the prompts to create your PIN and record your greeting. For smartphones, you can also access voicemail through the Phone app by tapping and holding the 1 key. If you need help with your specific device, our customer service team is available 7 days a week.', 'voicemail, setup, greeting, PIN, message', DATEADD(DAY, -30, CURRENT_DATE()), 15234, 12456),
('KB002', 'Understanding Your Monthly Bill', 'Billing', 'Bill Explanation', 'Your Consumer Cellular bill includes several components: your monthly plan charge, any device payments if you purchased a phone on a payment plan, taxes and regulatory fees, and any overage charges if applicable. Auto-pay customers receive a $5 monthly discount. You can view your bill details anytime by logging into your account at ConsumerCellular.com or through our mobile app.', 'bill, charges, payment, autopay, monthly', DATEADD(DAY, -15, CURRENT_DATE()), 22156, 18234),
('KB003', 'How to Switch to a New Plan', 'Plan Changes', 'Plan Upgrade', 'Changing your plan is simple and can be done anytime without fees. Log into your account online, call us, or visit a Target store with Consumer Cellular service. When upgrading, your new plan takes effect immediately. If downgrading, the change happens at the start of your next billing cycle. Remember, our plans are designed to fit your needs - pay only for what you use!', 'plan, change, upgrade, downgrade, switch', DATEADD(DAY, -7, CURRENT_DATE()), 18567, 15123),
('KB004', 'Troubleshooting No Service or Poor Signal', 'Technical Support', 'Network Issues', 'If you are experiencing no service or weak signal, try these steps: 1) Restart your phone by turning it off for 30 seconds. 2) Check if you are in a covered area using our coverage map. 3) Remove and reinsert your SIM card. 4) Update your phone software if available. 5) Check for any network outages in your area. If issues persist, contact our support team for advanced troubleshooting.', 'signal, service, coverage, network, troubleshoot', DATEADD(DAY, -3, CURRENT_DATE()), 28934, 24567),
('KB005', 'Setting Up WiFi Calling', 'Device Support', 'WiFi Calling', 'WiFi Calling lets you make calls over a WiFi network when cellular signal is weak. To enable: On iPhone, go to Settings > Phone > WiFi Calling. On Android, go to Settings > Connections > WiFi Calling. Make sure you are connected to WiFi and have registered your emergency address. WiFi Calling is included free with most plans and uses your plan minutes.', 'wifi, calling, signal, home, settings', DATEADD(DAY, -10, CURRENT_DATE()), 12456, 10234),
('KB006', 'How to Transfer Data to a New Phone', 'Device Support', 'Data Transfer', 'Transferring your data to a new phone varies by device. For iPhone to iPhone, use Quick Start or iCloud backup. For Android to Android, use Google backup or Smart Switch (Samsung). For mixed transfers, third-party apps like Move to iOS can help. Always backup your old phone before starting. Our in-store experts can assist with data transfers at no extra charge.', 'transfer, data, backup, new phone, contacts', DATEADD(DAY, -5, CURRENT_DATE()), 19876, 16543),
('KB007', 'Understanding Data Usage', 'Billing', 'Data', 'Data is used when you browse the internet, use apps, stream video, or download content without WiFi. To monitor usage: Check your account online or in our app to see real-time usage. Tips to reduce data: Connect to WiFi when available, disable auto-play videos, and download content at home. If you regularly exceed your limit, consider upgrading to a higher data plan.', 'data, usage, internet, streaming, wifi', DATEADD(DAY, -8, CURRENT_DATE()), 21345, 17890),
('KB008', 'AARP Member Benefits', 'Account Management', 'Discounts', 'AARP members enjoy exclusive benefits with Consumer Cellular! As an AARP member, you receive 5% off monthly service charges. Simply provide your AARP membership number when signing up or add it to your existing account. AARP members also get priority customer service and exclusive promotional offers throughout the year.', 'AARP, discount, member, benefits, savings', DATEADD(DAY, -12, CURRENT_DATE()), 16789, 14567),
('KB009', 'International Calling Options', 'Plan Changes', 'International', 'Stay connected while traveling or calling abroad! We offer competitive international calling rates. For travel: Purchase a temporary international package before your trip. For calls to other countries: International long distance rates vary by country. Check our website for current rates. Consider WiFi calling or messaging apps when overseas to save on charges.', 'international, travel, roaming, calling, abroad', DATEADD(DAY, -20, CURRENT_DATE()), 8934, 7234),
('KB010', 'Phone Not Charging - Troubleshooting', 'Device Support', 'Charging Issues', 'If your phone is not charging, try these steps: 1) Check the charging cable for damage and try a different cable. 2) Clean the charging port gently with a dry brush. 3) Try a different power outlet or USB port. 4) Restart your phone. 5) Check if the charger is compatible with your device. If problems continue, your battery may need replacement - visit a service location.', 'charging, battery, power, cable, port', DATEADD(DAY, -2, CURRENT_DATE()), 24567, 21234),
('KB011', 'How to Block Spam Calls', 'Device Support', 'Call Blocking', 'Protect yourself from unwanted calls! On iPhone: Go to Settings > Phone > Silence Unknown Callers. On Android: Use the built-in call screening or download a call blocking app. You can also add numbers to your block list directly from your call history. We partner with services to identify and warn you about potential spam calls.', 'spam, block, calls, unwanted, scam', DATEADD(DAY, -4, CURRENT_DATE()), 31234, 28567),
('KB012', 'Activating a New SIM Card', 'Activation', 'SIM Card', 'To activate your new SIM card: 1) Insert the SIM into your phone (ensure phone is off). 2) Turn on your phone. 3) Call our activation line or activate online at ConsumerCellular.com. 4) Provide your account information and new SIM card number (ICCID). 5) Wait a few minutes for activation to complete. Your old SIM will be deactivated automatically.', 'SIM, activate, new, phone, ICCID', DATEADD(DAY, -1, CURRENT_DATE()), 17654, 15234),
('KB013', 'Family Plan Options', 'Plan Changes', 'Family Plans', 'Share data and save with our family plans! Add up to 4 lines to your account. Each line gets unlimited talk and text, and you share a pool of data. Adding a line is easy: Call us or visit your account online. Each additional line includes its own phone number. Family locator and usage controls are available for parents.', 'family, plan, lines, share, data', DATEADD(DAY, -6, CURRENT_DATE()), 14567, 12345),
('KB014', 'Returning or Exchanging a Phone', 'Account Management', 'Returns', 'Our 30-day risk-free guarantee means you can return or exchange your phone hassle-free! To initiate a return: Call customer service or visit a retail partner location. Phones must be in original condition with all accessories. Refunds are processed within 7-10 business days. Restocking fees may apply for some devices after the first 14 days.', 'return, exchange, refund, guarantee, policy', DATEADD(DAY, -9, CURRENT_DATE()), 11234, 9567),
('KB015', 'Setting Up Auto-Pay', 'Billing', 'Auto-Pay', 'Save $5/month with Auto-Pay! To enroll: Log into your account, go to Payment Settings, and add a credit card, debit card, or bank account. Your payment will be automatically processed on your bill due date. You can update or cancel Auto-Pay anytime. Paper billing is available for customers who prefer traditional statements.', 'autopay, automatic, payment, save, billing', DATEADD(DAY, -11, CURRENT_DATE()), 20123, 18234);

INSERT INTO CUSTOMER_FEEDBACK (FEEDBACK_ID, CUSTOMER_ID, FEEDBACK_DATE, FEEDBACK_TYPE, NPS_SCORE, CSAT_SCORE, COMMENTS, FOLLOW_UP_REQUIRED)
SELECT 
    'FBK' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    c.CUSTOMER_ID,
    DATEADD(DAY, -UNIFORM(0, 180, RANDOM()), CURRENT_DATE()),
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'NPS Survey' WHEN 1 THEN 'Post-Call Survey' ELSE 'App Review' END,
    UNIFORM(0, 10, RANDOM()),
    UNIFORM(1, 5, RANDOM()),
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Great service! Very helpful staff.'
        WHEN 1 THEN 'Easy to understand pricing. No hidden fees.'
        WHEN 2 THEN 'Sometimes hard to reach customer service.'
        WHEN 3 THEN 'Love the AARP discount!'
        WHEN 4 THEN 'Coverage could be better in rural areas.'
        WHEN 5 THEN 'Perfect for my needs as a senior.'
        WHEN 6 THEN 'Phone setup assistance was excellent.'
        WHEN 7 THEN 'Bill is always accurate and easy to understand.'
        WHEN 8 THEN 'Wish there were more phone options.'
        ELSE 'Recommended to all my friends!'
    END,
    UNIFORM(1, 100, RANDOM()) <= 20
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c
WHERE UNIFORM(1, 100, RANDOM()) <= 40;

INSERT INTO CHURN_PREDICTIONS (PREDICTION_ID, CUSTOMER_ID, PREDICTION_DATE, CHURN_PROBABILITY, CHURN_RISK_LEVEL, KEY_RISK_FACTORS, RECOMMENDED_ACTION, MODEL_VERSION)
SELECT 
    'CHN' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    c.CUSTOMER_ID,
    CURRENT_DATE(),
    ROUND(UNIFORM(0.01, 0.99, RANDOM())::NUMERIC, 4),
    CASE 
        WHEN UNIFORM(0.01, 0.99, RANDOM()) < 0.3 THEN 'Low'
        WHEN UNIFORM(0.01, 0.99, RANDOM()) < 0.7 THEN 'Medium'
        ELSE 'High'
    END,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Declining usage, multiple support tickets'
        WHEN 1 THEN 'Payment issues, late payments'
        WHEN 2 THEN 'Low engagement, no app usage'
        WHEN 3 THEN 'High overage charges, plan mismatch'
        ELSE 'Competitive offers, price sensitivity'
    END,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Proactive outreach, offer loyalty discount'
        WHEN 1 THEN 'Payment plan options, auto-pay enrollment'
        WHEN 2 THEN 'Feature education, app tutorial'
        WHEN 3 THEN 'Plan optimization review'
        ELSE 'Retention offer, match competitor pricing'
    END,
    'v2.1.0'
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c
WHERE UNIFORM(1, 100, RANDOM()) <= 100;

INSERT INTO CUSTOMER_LTV (LTV_ID, CUSTOMER_ID, CALCULATION_DATE, HISTORICAL_REVENUE, PREDICTED_LIFETIME_VALUE, TENURE_MONTHS, AVG_MONTHLY_REVENUE, LTV_SEGMENT, MODEL_VERSION)
SELECT 
    'LTV' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    c.CUSTOMER_ID,
    CURRENT_DATE(),
    ROUND(UNIFORM(100, 5000, RANDOM())::NUMERIC, 2),
    ROUND(UNIFORM(500, 15000, RANDOM())::NUMERIC, 2),
    DATEDIFF(MONTH, c.SIGNUP_DATE, CURRENT_DATE()),
    ROUND(UNIFORM(15, 75, RANDOM())::NUMERIC, 2),
    CASE 
        WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Platinum'
        WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Gold'
        WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Silver'
        ELSE 'Bronze'
    END,
    'v1.5.0'
FROM CCI_INTELLIGENCE.RAW.CUSTOMERS c;

CREATE OR ALTER VIEW gold_risk_bot_detection AS

WITH DailySignups AS (
    SELECT 
        location_id,
        CAST(signup_datetime AS DATE) AS signup_date,
        COUNT(member_id) AS daily_registrations
    FROM silver_members
    GROUP BY location_id, CAST(signup_datetime AS DATE)
),
RollingBaseline AS (
    SELECT 
        location_id,
        signup_date,
        daily_registrations,
        AVG(CAST(daily_registrations AS FLOAT)) OVER(
            PARTITION BY location_id 
            ORDER BY signup_date 
            ROWS BETWEEN 14 PRECEDING AND 1 PRECEDING
        ) AS prior_14d_avg
    FROM DailySignups
)
SELECT 
    location_id,
    signup_date,
    daily_registrations AS actual_registrations,
    ISNULL(prior_14d_avg, 0) AS expected_baseline_registrations,
    CASE 
        WHEN daily_registrations > (ISNULL(prior_14d_avg, 0) * 10) AND daily_registrations > 100 THEN 'CRITICAL RISK: BOT NETWORK'
        WHEN daily_registrations > (ISNULL(prior_14d_avg, 0) * 5) AND daily_registrations > 50 THEN 'WARNING: ABNORMAL SURGE'
        ELSE 'NORMAL'
    END AS risk_tier
FROM RollingBaseline
WHERE daily_registrations > (ISNULL(prior_14d_avg, 0) * 5) AND daily_registrations > 50;
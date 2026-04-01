-- 1. "Burner Account" Detection (Corrected Temporal Delta)
WITH FirstAction AS (
    SELECT 
        member_id,
        MIN(event_timestamp) AS first_event_time
    FROM silver_app_events
    GROUP BY member_id
)
SELECT TOP 50
    m.member_id,
    m.location_id,
    m.signup_datetime,
    f.first_event_time,
    DATEDIFF(SECOND, m.signup_datetime, f.first_event_time) AS seconds_to_first_action,
    'HIGH RISK: IMMEDIATE EXECUTION' AS fraud_flag
FROM silver_members m
INNER JOIN FirstAction f ON m.member_id = f.member_id
WHERE DATEDIFF(SECOND, m.signup_datetime, f.first_event_time) BETWEEN 0 AND 60
ORDER BY seconds_to_first_action ASC;

-- 2. "Rapid-Fire" Velocity Tracking
WITH EventVelocity AS (
    SELECT 
        member_id,
        event_type,
        event_timestamp,
        LAG(event_timestamp, 1) OVER (PARTITION BY member_id ORDER BY event_timestamp) AS previous_event_time
    FROM silver_app_events
)
SELECT 
    member_id,
    event_type,
    event_timestamp,
    DATEDIFF(SECOND, previous_event_time, event_timestamp) AS seconds_between_actions,
    'WARNING: NON-HUMAN VELOCITY' as velocity_flag
FROM EventVelocity
WHERE DATEDIFF(SECOND, previous_event_time, event_timestamp) < 2 
ORDER BY seconds_between_actions ASC;

-- 3. Geographic Behavioral Matrix
SELECT 
    m.location_id,
    COUNT(e.event_id) AS total_events,
    SUM(CASE WHEN e.event_type = 'DONATION' THEN 1 ELSE 0 END) AS total_donations,
    SUM(CASE WHEN e.event_type = 'SHARE_IMAGE' THEN 1 ELSE 0 END) AS total_shares,
    SUM(CASE WHEN e.event_type = 'VIEW_PROGRAM' THEN 1 ELSE 0 END) AS total_views,
    CAST(SUM(CASE WHEN e.event_type = 'DONATION' THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(COUNT(e.event_id), 0) AS financial_activity_ratio
FROM silver_members m
INNER JOIN silver_app_events e ON m.member_id = e.member_id
GROUP BY m.location_id
ORDER BY total_events DESC;
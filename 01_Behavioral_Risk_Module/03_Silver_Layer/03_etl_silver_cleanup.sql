DROP TABLE IF EXISTS silver_app_events;
DROP TABLE IF EXISTS silver_members;

CREATE TABLE silver_members (
    member_id VARCHAR(50) PRIMARY KEY,
    is_verified BIT NOT NULL, 
    onboarding_channel VARCHAR(50),
    membership_level VARCHAR(50),
    location_id VARCHAR(50),
    signup_datetime DATETIME
);

CREATE TABLE silver_app_events (
    event_id VARCHAR(50) PRIMARY KEY,
    member_id VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    session_id VARCHAR(50),
    event_timestamp DATETIME NOT NULL,
    os_type VARCHAR(50),
    CONSTRAINT FK_Silver_Member FOREIGN KEY (member_id) REFERENCES silver_members(member_id)
);

-- Deduplication and Casting
WITH DeduplicatedMembers AS (
    SELECT 
        member_id,
        CASE 
            WHEN UPPER(voter_id_verified) IN ('1', 'YES', 'TRUE', 'Y') THEN 1 
            ELSE 0 
        END AS is_verified,
        UPPER(TRIM(ISNULL(onboarding_channel, 'UNKNOWN'))) AS onboarding_channel,
        UPPER(TRIM(ISNULL(membership_level, 'UNASSIGNED'))) AS membership_level,
        location_id,
        CAST(signup_date AS DATETIME) AS signup_datetime,
        ROW_NUMBER() OVER (
            PARTITION BY member_id 
            ORDER BY CAST(signup_date AS DATETIME) DESC
        ) as row_num
    FROM bronze_members
    WHERE member_id IS NOT NULL 
)
INSERT INTO silver_members (member_id, is_verified, onboarding_channel, membership_level, location_id, signup_datetime)
SELECT 
    member_id, 
    is_verified, 
    onboarding_channel, 
    membership_level, 
    location_id, 
    signup_datetime
FROM DeduplicatedMembers
WHERE row_num = 1; 

-- Referential Integrity Filtering
INSERT INTO silver_app_events (event_id, member_id, event_type, session_id, event_timestamp, os_type)
SELECT 
    e.event_id,
    e.member_id,
    UPPER(TRIM(e.event_type)) AS event_type,
    e.session_id,
    CAST(e.timestamp AS DATETIME) AS event_timestamp,
    UPPER(TRIM(ISNULL(e.os_type, 'UNKNOWN'))) AS os_type
FROM bronze_app_events e
INNER JOIN silver_members m ON e.member_id = m.member_id
WHERE e.event_id IS NOT NULL;
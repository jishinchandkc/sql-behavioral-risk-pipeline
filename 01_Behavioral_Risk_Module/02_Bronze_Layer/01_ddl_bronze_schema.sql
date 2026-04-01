CREATE TABLE bronze_members (
    member_id VARCHAR(50),
    voter_id_verified VARCHAR(20),
    onboarding_channel VARCHAR(50),
    membership_level VARCHAR(50),
    location_id VARCHAR(50),
    signup_date VARCHAR(50)
);

CREATE TABLE bronze_app_events (
    event_id VARCHAR(50),
    member_id VARCHAR(50),
    event_type VARCHAR(50),
    session_id VARCHAR(50),
    timestamp VARCHAR(50),
    os_type VARCHAR(50)
);
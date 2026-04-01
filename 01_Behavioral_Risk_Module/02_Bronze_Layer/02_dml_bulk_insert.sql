-- Replaces OS-level line break conflicts with strict hex terminators
BULK INSERT bronze_members
FROM 'E:\SQL\bronze_members.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    TABLOCK
);

BULK INSERT bronze_app_events
FROM 'E:\SQL\bronze_app_events.csv'
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    TABLOCK
);
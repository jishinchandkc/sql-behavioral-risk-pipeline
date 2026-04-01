import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# 1. Generate 5,000 Bronze Members (Organic Traffic)
members = []
districts = ['Guntur', 'Krishna', 'Visakhapatnam', 'Prakasam', 'Nellore']
channels = ['Referral', 'Direct_Download', 'Field_Volunteer', 'UNKNOWN', 'referral', ' DIRECT ']
levels = ['Active_Member', 'Registered_Follower', 'Leader', 'active_member', None]

for i in range(1, 5001):
    members.append({
        'member_id': f'M{str(i).zfill(5)}',
        'voter_id_verified': random.choice(['1', '0', 'Yes', 'No', 'True', 'False']), 
        'onboarding_channel': random.choice(channels),
        'membership_level': random.choice(levels),
        'location_id': f'LOC_{random.choice(districts)}',
        'signup_date': (datetime(2025, 1, 1) + timedelta(days=random.randint(0, 300))).strftime('%Y-%m-%d %H:%M:%S')
    })

# INJECT ANOMALY: 500 Bots sign up in Visakhapatnam on the exact same day
for i in range(5001, 5501):
    members.append({
        'member_id': f'M{str(i).zfill(5)}',
        'voter_id_verified': '0',
        'onboarding_channel': 'Direct_Download',
        'membership_level': 'Registered_Follower',
        'location_id': 'LOC_Visakhapatnam',
        'signup_date': '2025-10-15 02:00:00' 
    })

df_members = pd.DataFrame(members)

# 2. Generate 50,000 Bronze App Events
events = []
event_types = ['View_Program', 'Share_Image', 'Verify_Status', 'Donation', ' share_image ', 'DONATION']
os_types = ['Android', 'iOS', 'Web', None]

for i in range(1, 50001):
    random_member = f'M{str(random.randint(1, 5500)).zfill(5)}'
    events.append({
        'event_id': f'EVT{str(i).zfill(6)}',
        'member_id': random_member,
        'event_type': random.choice(event_types),
        'session_id': f'SESS_{random.randint(1000, 9999)}',
        'timestamp': (datetime(2025, 1, 1) + timedelta(days=random.randint(0, 365), hours=random.randint(0, 23))).strftime('%Y-%m-%d %H:%M:%S'),
        'os_type': random.choice(os_types)
    })

df_events = pd.DataFrame(events)

# 3. Export to CSV
df_members.to_csv('bronze_members.csv', index=False)
df_events.to_csv('bronze_app_events.csv', index=False)
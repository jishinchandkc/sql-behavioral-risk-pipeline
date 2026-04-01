# Financial Analytics & Risk Portfolio

This repository contains two independent strategic analytics modules. These projects solve high-stakes financial challenges through advanced data modeling, pattern detection, and business intelligence.

---

## 🛡️ Project 1: Behavioral Risk & Anomaly Detection
**Objective:** Identify and mitigate coordinated bot networks and fraudulent activity within high-volume environments.

### Analytical Logic
* **Integrity Validation:** Standardized 55,000+ raw activity logs to ensure data accuracy for risk modeling.
* **Behavioral Baselines:** Established 14-day rolling historical averages using `AVG(...) OVER(...)` to identify "normal" user behavior.
* **Anomaly Detection:** Developed logic to automatically flag regional activity spikes exceeding 10x the norm, isolating coordinated bot attacks.
* **Velocity Tracking:** Identified "Rapid-Fire" actions and "Burner Accounts" that executed high-value tasks within 60 seconds of account creation.

---

## 💳 Project 2: Credit Card Transaction Intelligence
**Objective:** Extract actionable business insights from credit card usage patterns, focusing on market share, growth, and customer milestones.

### Key Business Use Cases
* **Market Share Analysis:** Identified top 5 cities by spend and calculated their percentage contribution to global revenue.
* **Milestone Tracking:** Engineered a cumulative spend model using `SUM(...) OVER(...)` to identify exactly when a cardholder reaches a **1,000,000 unit spend threshold**.
* **Growth Analytics:** Analyzed **Month-over-Month (MoM) growth** segments using `LAG()` functions to identify high-performing card tiers and expense categories.
* **Acquisition Velocity:** Measured the time taken for new markets to reach 500 transactions using `DATEDIFF` and `ROW_NUMBER()`.

---

## 📂 Repository Structure

```text
├── 01_Behavioral_Risk_Module       # Project 1: Anomaly Detection & Risk Suite
│   ├── 01_Data_Generation
│   ├── 02_Bronze_Layer
│   ├── 03_Silver_Layer
│   ├── 04_Gold_Layer
│   └── 05_Advanced_Analytics
└── 02_Credit_Card_Analytics_Module # Project 2: Financial Intelligence Suite
    ├── 01_table_definitions.sql
    └── 02_business_insight_queries.sql

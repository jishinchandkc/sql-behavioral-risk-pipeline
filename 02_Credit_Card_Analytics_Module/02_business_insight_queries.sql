/* PROJECT: Credit Card Transaction Intelligence
MODULE: Strategic Business Analysis
*/

-- 1. MARKET SHARE: Top 5 cities by spend and their % contribution to total revenue
SELECT TOP 5
    city, 
    SUM(amount) AS total_spend,
    ROUND(100.0 * SUM(amount) / (SELECT SUM(amount) FROM credit_card_transcations), 2) AS pct_of_total_spend
FROM credit_card_transcations
GROUP BY city
ORDER BY total_spend DESC;

-- 2. MILESTONE TRACKING: Identify the specific transaction that pushes a card type over 1,000,000 in spend
WITH CumulativeSpend AS (
    SELECT *,
        SUM(amount) OVER(PARTITION BY card_type ORDER BY transaction_date, transaction_id) AS running_total
    FROM credit_card_transcations
)
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY card_type ORDER BY running_total) AS milestone_rank
    FROM CumulativeSpend 
    WHERE running_total >= 1000000
) x 
WHERE milestone_rank = 1;

-- 3. GROWTH ANALYTICS: Identifying highest Month-over-Month (MoM) growth segments
WITH MonthlySpend AS (
    SELECT 
        card_type, 
        MONTH(transaction_date) AS mnt, 
        YEAR(transaction_date) AS yr, 
        SUM(amount) AS monthly_total
    FROM credit_card_transcations
    GROUP BY card_type, YEAR(transaction_date), MONTH(transaction_date)
),
GrowthCalc AS (
    SELECT *,
        LAG(monthly_total) OVER(PARTITION BY card_type ORDER BY yr, mnt) AS prev_month_spend
    FROM MonthlySpend
)
SELECT *, 
    ROUND(((monthly_total - prev_month_spend) / prev_month_spend) * 100, 2) AS mom_growth_pct
FROM GrowthCalc
WHERE prev_month_spend IS NOT NULL
ORDER BY mom_growth_pct DESC;

SELECT *
FROM `scaler-dsml-sql-387810.customer_analytics.bank_churn_clean` 
LIMIT 10;

/* Create Churn Metrics View */
CREATE OR REPLACE VIEW `customer_analytics.v_churn_metrics` AS
SELECT
  COUNT(*) AS total_customers,
  SUM(Exited) AS churned_customers,
  ROUND(SUM(Exited) / COUNT(*), 3) AS churn_rate
FROM `customer_analytics.bank_churn_clean`;
SELECT * FROM `customer_analytics.v_churn_metrics`;

/* Churn by Geography */
SELECT
  CASE
    WHEN Geography_Germany = TRUE THEN 'Germany'
    WHEN Geography_Spain = TRUE THEN 'Spain'
    ELSE 'France'
  END AS geography,
  COUNT(*) AS customers,
  SUM(Exited) AS churned,
  ROUND(SUM(Exited) / COUNT(*), 3) AS churn_rate
FROM `customer_analytics.bank_churn_clean`
GROUP BY geography
ORDER BY churn_rate DESC;

/*  Churn by ENgagement */
SELECT
  IsActiveMember,
  COUNT(*) AS customers,
  ROUND(SUM(Exited) / COUNT(*), 3) AS churn_rate
FROM `customer_analytics.bank_churn_clean`
GROUP BY IsActiveMember;

/* Churn by Tenure (Band-wise) */
SELECT
  CASE
    WHEN Tenure <= 2 THEN '0–2 years'
    WHEN Tenure <= 5 THEN '3–5 years'
    WHEN Tenure <= 8 THEN '6–8 years'
    ELSE '9–10 years'
  END AS tenure_band,
  COUNT(*) AS customers,
  ROUND(SUM(Exited) / COUNT(*), 3) AS churn_rate
FROM `customer_analytics.bank_churn_clean`
GROUP BY tenure_band
ORDER BY churn_rate DESC;
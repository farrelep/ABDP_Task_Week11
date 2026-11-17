-- Contoh query self-service di Metabase (Native Query)
-- DB: webappskuliah | tabel: metabase_*

-- 1) Ringkasan churn rate keseluruhan
SELECT
  COUNT(*) AS total_customers,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM webappskuliah.metabase_customers;

-- 2) Churn rate per jenis kontrak
SELECT
  contract,
  COUNT(*) AS total,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM webappskuliah.metabase_customers
GROUP BY contract
ORDER BY churn_rate_pct DESC;

-- 3) Churn rate per metode pembayaran
SELECT
  payment_method,
  COUNT(*) AS total,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(100 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM webappskuliah.metabase_customers
GROUP BY payment_method
ORDER BY churn_rate_pct DESC;

-- 4) Rata-rata tagihan bulanan: churn vs stay
SELECT
  churn,
  ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges,
  ROUND(AVG(tenure), 1) AS avg_tenure_months,
  COUNT(*) AS customers
FROM webappskuliah.metabase_customers
GROUP BY churn;

-- 5) Churn berdasarkan grup tenure
SELECT
  tenure_group,
  COUNT(*) AS total,
  SUM(is_churn) AS churned,
  ROUND(100 * SUM(is_churn) / COUNT(*), 2) AS churn_rate_pct
FROM webappskuliah.metabase_v_customer_churn_summary
GROUP BY tenure_group
ORDER BY
  FIELD(tenure_group, '0-12 bulan', '13-24 bulan', '25-48 bulan', '49+ bulan');

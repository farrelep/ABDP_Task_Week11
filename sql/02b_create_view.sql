USE webappskuliah;

-- Jalankan sebagai user yang punya hak DROP/CREATE VIEW.
-- Jika view lama dibuat oleh root, drop dulu sekali sebagai root:
--   DROP VIEW IF EXISTS webappskuliah.metabase_v_customer_churn_summary;

CREATE OR REPLACE
  ALGORITHM = UNDEFINED
  SQL SECURITY INVOKER
VIEW metabase_v_customer_churn_summary AS
SELECT
  customer_id,
  gender,
  CASE WHEN senior_citizen = 1 THEN 'Senior' ELSE 'Non-Senior' END AS customer_segment,
  partner,
  dependents,
  tenure,
  CASE
    WHEN tenure <= 12 THEN '0-12 bulan'
    WHEN tenure <= 24 THEN '13-24 bulan'
    WHEN tenure <= 48 THEN '25-48 bulan'
    ELSE '49+ bulan'
  END AS tenure_group,
  phone_service,
  internet_service,
  contract,
  payment_method,
  monthly_charges,
  total_charges,
  churn,
  CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END AS is_churn
FROM metabase_customers;

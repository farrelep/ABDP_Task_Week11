USE webappskuliah;

-- Aman untuk user terbatas: TANPA DROP
-- (DROP VIEW/TABLE milik root butuh privilege SYSTEM_USER)
CREATE TABLE IF NOT EXISTS metabase_customers (
  customer_id          VARCHAR(20)  NOT NULL,
  gender               VARCHAR(10)  NOT NULL,
  senior_citizen       TINYINT      NOT NULL COMMENT '0 = bukan senior, 1 = senior',
  partner              VARCHAR(5)   NOT NULL,
  dependents           VARCHAR(5)   NOT NULL,
  tenure               INT          NOT NULL COMMENT 'lama berlangganan (bulan)',
  phone_service        VARCHAR(5)   NOT NULL,
  multiple_lines       VARCHAR(30)  NOT NULL,
  internet_service     VARCHAR(20)  NOT NULL,
  online_security      VARCHAR(30)  NOT NULL,
  online_backup        VARCHAR(30)  NOT NULL,
  device_protection    VARCHAR(30)  NOT NULL,
  tech_support         VARCHAR(30)  NOT NULL,
  streaming_tv         VARCHAR(30)  NOT NULL,
  streaming_movies     VARCHAR(30)  NOT NULL,
  contract             VARCHAR(20)  NOT NULL,
  paperless_billing    VARCHAR(5)   NOT NULL,
  payment_method       VARCHAR(40)  NOT NULL,
  monthly_charges      DECIMAL(10,2) NOT NULL,
  total_charges        DECIMAL(12,2) NULL COMMENT 'bisa kosong untuk pelanggan baru',
  churn                VARCHAR(5)   NOT NULL COMMENT 'Yes = churn, No = stay',
  PRIMARY KEY (customer_id),
  INDEX idx_metabase_churn (churn),
  INDEX idx_metabase_contract (contract),
  INDEX idx_metabase_internet (internet_service),
  INDEX idx_metabase_tenure (tenure)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

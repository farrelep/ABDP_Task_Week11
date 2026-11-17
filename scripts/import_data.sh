#!/bin/bash
set -euo pipefail

HOST="${MYSQL_HOST:-mysql-server}"
USER="${MYSQL_USER:-webappskuliah}"
DB="${MYSQL_DATABASE:-webappskuliah}"
PREFIX="${TABLE_PREFIX:-metabase}"
TABLE="${PREFIX}_customers"

echo "==> Menunggu MySQL di ${HOST}..."
for i in $(seq 1 60); do
  if mysqladmin ping -h"$HOST" -u"$USER" --silent; then
    break
  fi
  sleep 2
done

echo "==> Siapkan tabel di ${DB}..."
mysql -h"$HOST" -u"$USER" < /sql/01_create_databases.sql
mysql -h"$HOST" -u"$USER" < /sql/02_create_table.sql

echo "==> Import CSV ke ${DB}.${TABLE}..."
mysql --local-infile=1 -h"$HOST" -u"$USER" "$DB" -e "
LOAD DATA LOCAL INFILE '/data/telco_customer_churn.csv'
INTO TABLE ${TABLE}
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
  customer_id,
  gender,
  senior_citizen,
  partner,
  dependents,
  tenure,
  phone_service,
  multiple_lines,
  internet_service,
  online_security,
  online_backup,
  device_protection,
  tech_support,
  streaming_tv,
  streaming_movies,
  contract,
  paperless_billing,
  payment_method,
  monthly_charges,
  @total_charges,
  churn
)
SET total_charges = NULLIF(TRIM(@total_charges), '');
"

echo "==> Verifikasi:"
mysql -h"$HOST" -u"$USER" -e "SELECT COUNT(*) AS total_rows FROM ${DB}.${TABLE}; SELECT churn, COUNT(*) AS cnt FROM ${DB}.${TABLE} GROUP BY churn;"

echo "==> Import selesai."

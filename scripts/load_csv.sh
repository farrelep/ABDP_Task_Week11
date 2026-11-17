#!/bin/bash
# =============================================================================
# load_csv.sh
# Load dataset Telco Churn ke MySQL.
#
# SYARAT : container mysql-server sudah running
# TIDAK PERLU : Metabase
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

MYSQL_CONTAINER="${MYSQL_CONTAINER:-mysql-server}"
MYSQL_USER="${MYSQL_USER:-webappskuliah}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-webappskuliah}"
MYSQL_DATABASE="${MYSQL_DATABASE:-webappskuliah}"
TABLE="metabase_customers"
REMOTE_CSV="/var/lib/mysql-files/telco_customer_churn.csv"

if [[ $# -ge 1 && -f "$1" ]]; then
  CSV_FILE="$1"
elif [[ -f "${ROOT_DIR}/WA_Fn-UseC_-Telco-Customer-Churn.csv" ]]; then
  CSV_FILE="${ROOT_DIR}/WA_Fn-UseC_-Telco-Customer-Churn.csv"
elif [[ -f "${ROOT_DIR}/data/telco_customer_churn.csv" ]]; then
  CSV_FILE="${ROOT_DIR}/data/telco_customer_churn.csv"
else
  echo "ERROR: File CSV tidak ditemukan."
  exit 1
fi

echo "==> CSV        : ${CSV_FILE}"
echo "==> Container  : ${MYSQL_CONTAINER}"
echo "==> Target     : ${MYSQL_DATABASE}.${TABLE}"
echo

if ! docker ps --format '{{.Names}}' | grep -qx "${MYSQL_CONTAINER}"; then
  echo "ERROR: Container '${MYSQL_CONTAINER}' belum running."
  exit 1
fi

mysql_exec() {
  docker exec -i "${MYSQL_CONTAINER}" \
    mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "$@"
}

echo "==> [1/4] Pastikan tabel ada (tanpa DROP)..."
mysql_exec < "${ROOT_DIR}/sql/02_create_table.sql"

echo "==> [2/4] Copy CSV ke MySQL container..."
docker exec "${MYSQL_CONTAINER}" mkdir -p /var/lib/mysql-files
docker cp "${CSV_FILE}" "${MYSQL_CONTAINER}:${REMOTE_CSV}"

echo "==> [3/4] Kosongkan tabel + LOAD DATA..."
mysql_exec "${MYSQL_DATABASE}" <<SQL
DELETE FROM ${TABLE};

LOAD DATA INFILE '${REMOTE_CSV}'
INTO TABLE ${TABLE}
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
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
SQL

echo "==> [4/4] Verifikasi..."
mysql_exec -e "
SELECT COUNT(*) AS total_rows FROM ${MYSQL_DATABASE}.${TABLE};
SELECT churn, COUNT(*) AS cnt FROM ${MYSQL_DATABASE}.${TABLE} GROUP BY churn;
"

# View opsional (boleh gagal kalau view lama milik root)
echo "==> (opsional) Buat/update view..."
if mysql_exec < "${ROOT_DIR}/sql/02b_create_view.sql"; then
  echo "View OK: metabase_v_customer_churn_summary"
else
  echo "WARN: View gagal dibuat (biasanya karena view lama dibuat root)."
  echo "      Minta admin sekali jalankan:"
  echo "      DROP VIEW IF EXISTS webappskuliah.metabase_v_customer_churn_summary;"
  echo "      lalu: bash scripts/load_csv.sh"
fi

docker exec "${MYSQL_CONTAINER}" rm -f "${REMOTE_CSV}" >/dev/null 2>&1 || true

echo
echo "Selesai load data ke ${MYSQL_DATABASE}.${TABLE}"

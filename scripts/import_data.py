#!/usr/bin/env python3
"""Import Telco Customer Churn CSV ke webappskuliah.metabase_customers."""

import csv
import os
import sys

try:
    import pymysql
except ImportError:
    print("Menginstall PyMySQL...")
    os.system(f"{sys.executable} -m pip install --quiet PyMySQL")
    import pymysql

HOST = os.getenv("MYSQL_HOST", "mysql-server")
USER = os.getenv("MYSQL_USER", "webappskuliah")
PASSWORD = os.getenv("MYSQL_PASSWORD", os.getenv("MYSQL_PWD", "webappskuliah"))
DATABASE = os.getenv("MYSQL_DATABASE", "webappskuliah")
PREFIX = os.getenv("TABLE_PREFIX", "metabase")
TABLE = f"{PREFIX}_customers"
CSV_PATH = os.getenv("CSV_PATH", "/data/telco_customer_churn.csv")

COLUMNS = [
    "customer_id", "gender", "senior_citizen", "partner", "dependents",
    "tenure", "phone_service", "multiple_lines", "internet_service",
    "online_security", "online_backup", "device_protection", "tech_support",
    "streaming_tv", "streaming_movies", "contract", "paperless_billing",
    "payment_method", "monthly_charges", "total_charges", "churn",
]


def parse_total(value: str):
    value = (value or "").strip()
    if value == "":
        return None
    return float(value)


def main():
    conn = pymysql.connect(
        host=HOST,
        user=USER,
        password=PASSWORD,
        database=DATABASE,
        charset="utf8mb4",
        autocommit=False,
    )
    cur = conn.cursor()
    cur.execute(f"TRUNCATE TABLE `{TABLE}`")

    placeholders = ", ".join(["%s"] * len(COLUMNS))
    sql = f"INSERT INTO `{TABLE}` ({', '.join(COLUMNS)}) VALUES ({placeholders})"

    rows = []
    with open(CSV_PATH, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append(
                (
                    r["customerID"],
                    r["gender"],
                    int(r["SeniorCitizen"]),
                    r["Partner"],
                    r["Dependents"],
                    int(r["tenure"]),
                    r["PhoneService"],
                    r["MultipleLines"],
                    r["InternetService"],
                    r["OnlineSecurity"],
                    r["OnlineBackup"],
                    r["DeviceProtection"],
                    r["TechSupport"],
                    r["StreamingTV"],
                    r["StreamingMovies"],
                    r["Contract"],
                    r["PaperlessBilling"],
                    r["PaymentMethod"],
                    float(r["MonthlyCharges"]),
                    parse_total(r["TotalCharges"]),
                    r["Churn"],
                )
            )

    batch = 500
    for i in range(0, len(rows), batch):
        cur.executemany(sql, rows[i : i + batch])
    conn.commit()

    cur.execute(f"SELECT COUNT(*) FROM `{TABLE}`")
    total = cur.fetchone()[0]
    cur.execute(f"SELECT churn, COUNT(*) FROM `{TABLE}` GROUP BY churn")
    print(f"Import selesai ke {DATABASE}.{TABLE}. Total rows: {total}")
    for churn, cnt in cur.fetchall():
        print(f"  churn={churn}: {cnt}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()

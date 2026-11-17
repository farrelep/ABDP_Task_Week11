# Self-Service Analytics dengan Metabase + MySQL (Docker)

Implementasi **self-service analytics** menggunakan **Metabase** (Docker) + **MySQL**, dengan dataset publik **Telco Customer Churn**.

## Ringkasan

| Item | Detail |
|------|--------|
| Tools | Metabase (Docker), MySQL |
| Dataset | IBM Telco Customer Churn (~7.043 baris) |
| Database | `webappskuliah` |
| Konvensi tabel | `{nama_project}_{nama_tabel}` → `metabase_customers` |
| UI Metabase | port `3030` |

Penjelasan konsep: [`docs/self-service-analytics.md`](docs/self-service-analytics.md).

---

## Struktur repositori

```text
Metabase/
├── README.md
├── docker-compose.yml
├── .env.example
├── .gitignore
├── data/
│   └── telco_customer_churn.csv
├── sql/
│   ├── 00_admin_once.sql
│   ├── 01_create_databases.sql
│   ├── 02_create_table.sql
│   └── 03_sample_queries.sql
├── scripts/
│   ├── load_csv.sh
│   ├── import_data.py
│   ├── import_data.sh
│   └── detect_network.sh
└── docs/
    ├── self-service-analytics.md
    └── tugas.md
```

---

## Konvensi naming

| Object | Nama |
|--------|------|
| Database | `webappskuliah` |
| User / Password | lihat `.env.example` |
| Tabel data | `metabase_customers` |
| View | `metabase_v_customer_churn_summary` |

Tidak membuat database baru. Prefix tabel mengikuti nama folder project: **Metabase** → `metabase_`.

> Kredensial nyata hanya di file `.env` (tidak di-commit). Salin dari `.env.example`.

---

## Persiapan

### 1) Konfigurasi environment

```bash
cp .env.example .env
# sesuaikan MYSQL_* dan DOCKER_NETWORK di .env
```

Pastikan container MySQL sudah running dan Docker network di `.env` sudah benar:

```bash
bash scripts/detect_network.sh
```

### 2) Import dataset (Metabase belum perlu jalan)

```bash
chmod +x scripts/load_csv.sh
bash scripts/load_csv.sh
# atau:
# bash scripts/load_csv.sh ./WA_Fn-UseC_-Telco-Customer-Churn.csv
```

Data masuk ke `webappskuliah.metabase_customers`.

### 3) Jalankan Metabase

```bash
docker compose up -d
docker compose logs -f metabase
```

Buka UI di port **3030**, lalu buat akun admin pada first launch.

---

## Koneksi MySQL di Metabase

1. **Admin** → **Databases** → **Add database**
2. Type: **MySQL**
3. Isi host / port / database / username / password sesuai `.env`
4. Save → Sync schema

Pakai tabel:

- `metabase_customers`
- `metabase_v_customer_churn_summary`

---

OKEY DI BAWAH INI TULISAN MANUSIA JGN OVERRIDE APAPUN DI BAWAH INI


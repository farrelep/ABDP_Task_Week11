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
│   ├── 02b_create_view.sql
│   └── 03_sample_queries.sql
├── scripts/
│   ├── load_csv.sh
│   ├── import_data.py
│   ├── import_data.sh
│   └── detect_network.sh
└── docs/
    ├── self-service-analytics.md
    ├── tugas.md
    └── (screenshot pendukung)
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

## Contoh dashboard

1. Total Customers & Churn Rate
2. Churn by Contract
3. Churn by Payment Method
4. Avg Monthly Charges: Churn vs Stay
5. Churn by Tenure Group (`metabase_v_customer_churn_summary`)

Query contoh: [`sql/03_sample_queries.sql`](sql/03_sample_queries.sql).

---

## Perintah operasional

```bash
docker compose up -d
docker compose down
bash scripts/load_csv.sh
docker compose logs -f metabase
```

---

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| Metabase tidak connect MySQL | Samakan `DOCKER_NETWORK` di `.env` dengan network container MySQL |
| Port 3030 bentrok | Ubah mapping di `docker-compose.yml` |
| Import gagal auth | Cek kredensial di `.env` |
| Access denied / SYSTEM_USER | Jangan pakai DROP; atau minta admin drop view lama sekali |
| Network not found | `bash scripts/detect_network.sh` lalu update `.env` |

---

## Keamanan repo publik

- Jangan commit file `.env` jika tidak perlu
- Jangan tulis IP server, daftar service internal, atau kredensial produksi di dokumentasi
- Gunakan `.env.example` sebagai template saja

---

OKEY DI BAWAH INI TULISAN MANUSIA JGN OVERRIDE APAPUN DI BAWAH INI

Penjelasan Penggunaan Tugas dalam kerangka self service analytics
Data yang kami gunakan adalah Telco Customer Churn IBM yang diperoleh dari database publik kaggle

1. Pemisahan Peran antara Data Governance dan Bisnis Exploration
pada sistem ini tanggung jawab sisi teknis dan sisi bisnis telah di pisahkan dengan tim sisi teknis telah menyiapkan infrastruktur dan menyajikan tabel siap pakai pada metabase, sisi tim bisnis tidak perlu memikirkan koneksi database dan sintaks sql, mereka dapat berinteraksi dengan data yang sudah valid dan terstruktur

2. Mekanisme Eksplorasi Mandiri
Dashboard metabase memungkinkan untuk pengguna atau user menjawab petanyaan bisnis nya sendiri seperti:
 2.1 NoCode Visual Querry Builder memungkinkan pengguna awam untuk mencari kebutuhan nya sendiri dengan drag and drop metrik contoh ingin mengetahui kelompok senior berapa minimal dan keluar 18.95 sebelum nya untuk mencari hal seperti ini harus mendapat bantuan dari tim teknis apa lagi saat membutuhkan berberapa kelompok namun dengan seperti ini tim bisnis dapat melakukan nya sendiri, pict di lampirkan di docks picture 2.1 dan picture 2.1-2

 2.2 Interactive Dashboard Filter yang memudahkan untuk slicing data seperti saya ingin mencari chrun customer based dari berapa lama dia langganan , atau dari metode bayar apa ini semua dapat di atur secara mandiri oleh user, sehingga dashboard yang di gunakan bisa di sesuaikan dengan kebutuhan tim bisnis , pict lampiran pun ada sesuai nama sub ini

 2.3 Drill Trough dan breakout atau penelusuran mendalam, pengguna dapat mengklik salah satu batang grafik tertentu dan melihat detail dari customer id nya , atau memecah nya lebih lanjut berdasarkan variable lain

 2.4 Self Service Export atau pengguna dapat menunduh data seara langsung dari hasil filter ke format csv atau xlsx untuk langsung di gunakan oleh tim operasional

3. Contoh Penggunaan Nyata 
Manajer mengetahui total churn sebesar 1869 dari total 7043 orang atau kurang lebih 25% sehingga manajer ingin tau segment mana sih yang sebenarnya rentan dan sering melakukan churn , dan melakukan drilling untuk count per contract dan terlihat bahwa presentase yang langganan month-to-month tinggi dalam melakukan churn dan manager membuthkan data lagi siapa sih paket yang sering melakukan churn ternyat terlihat dari kelompok fiber optic sehingga manager bisa lebih aware dan menyiapkan strategi untuk membuat pengguna dalam scale ini untuk menjadi lebih tertarik
foto contoh penggunaan ada dengan awalan 3.1

4. Tata Kelola dan keamanan data 
dengan dashboard ini pelaku bisnis bisa baca dan melakukan eksperimen pada level antar muka sehingga mereka bebas membuat grafik atau filter data tanpa takut resiko mengapus atau merusak table asli dalam database mysql

5. Evaluasi dampak
sebelum self service tim bisnis harus mengirim tiket atau permintaan ke tim ti setiap membtuuhkan potongan data baru , menunggu query dibuatkan dan mendapat laporan statis , namun sekarang tim bisnis dapat menjawab pertanyaan secara ad hoc dalam hitungan detik menggunakan browser merka dan mempercepat pengambilan keputusan retensi pelanggan dan mengurangi beban kerja operasional tim teknis
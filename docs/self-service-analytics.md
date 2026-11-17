# Kerangka Self-Service Analytics

## Apa itu Self-Service Analytics?

Pendekatan di mana pengguna bisnis dapat **mengakses data, membuat pertanyaan, visualisasi, dan dashboard sendiri** tanpa menunggu engineer menulis laporan setiap kali.

## Komponen dalam tugas ini

| Lapisan | Tools | Peran |
|---------|-------|-------|
| Data Source | Dataset publik Telco Customer Churn (CSV) | Sumber data mentah |
| Storage | MySQL DB `webappskuliah`, tabel `metabase_*` | Single source of truth |
| Analytics Platform | Metabase (Docker, port 3030) | Query builder, chart, dashboard |
| Delivery | Browser | Akses self-service |

## Alur kerja

```text
Dataset CSV
  → Import ke webappskuliah.metabase_customers
  → Metabase connect ke MySQL (DB webappskuliah)
  → User buat Question / Dashboard
  → Insight dibagikan ke stakeholder
```

## Konvensi naming DB shared

Karena MySQL dipakai banyak project:

- **Database:** `webappskuliah` (tidak create DB baru per project)
- **Tabel:** `{nama_folder}_{nama_tabel}`  
  Contoh folder `Metabase` → `metabase_customers`

## Contoh pertanyaan bisnis

1. Berapa churn rate keseluruhan?
2. Kontrak mana yang churn-nya tertinggi?
3. Apakah pelanggan Electronic check lebih mudah churn?
4. Bagaimana hubungan tenure dengan churn?
5. Apakah MonthlyCharges pelanggan churn lebih tinggi?

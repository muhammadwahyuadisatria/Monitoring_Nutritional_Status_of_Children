# MONAS (Monitoring Nutritional Status of Children)

MONAS adalah aplikasi monitoring status gizi balita berbasis pengolahan citra digital yang dikembangkan sebagai tugas akhir Program Studi S1 Teknik Telekomunikasi Universitas Telkom.

## Deskripsi

Aplikasi ini digunakan untuk membantu pemantauan status gizi balita melalui dua metode:

1. Input manual data antropometri.
2. Analisis foto tubuh balita menggunakan pengolahan citra digital.

Sistem melakukan estimasi tinggi badan, berat badan, dan klasifikasi status gizi berdasarkan standar WHO.

## Teknologi yang Digunakan

- Flutter
- FastAPI
- OpenCV
- SQLite
- Python

## Fitur

- Estimasi tinggi badan
- Estimasi berat badan
- Klasifikasi status gizi
- Riwayat pemeriksaan
- Export laporan PDF

## Struktur Repository

text
api.py                  -> REST API FastAPI
core.py                 -> Pengolahan citra digital
antropometri.py         -> Perhitungan antropometri

main.dart               -> Entry point aplikasi
data_loader.dart        -> Pengolahan data
database_helper.dart    -> Database SQLite
pdf_export.dart         -> Export PDF


## Tim Pengembang

- Muhammad Agus Athariq
- Muhammad Wahyu Adi Satria
- M. Safii Ma'arif

## Institusi

Program Studi S1 Teknik Telekomunikasi  
Fakultas Teknik Elektro  
Universitas Telkom

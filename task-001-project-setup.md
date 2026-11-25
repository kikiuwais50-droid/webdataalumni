# Task 001 — Project Setup & Database

**Tujuan:** Menyiapkan kerangka folder, database `db_alumni`, koneksi, dan aset SB Admin 2 sehingga task berikutnya dapat langsung membangun halaman.
**Dependensi:** —
**Referensi:** RPD §L, §M, §R · `architecture.md` · `database.md` · `deployment.md`

## Lingkup
- Membuat struktur folder sesuai `architecture.md`.
- Menulis `database/db_alumni.sql` (schema + 2 data contoh).
- Menulis `koneksi.php`.
- Menyalin aset SB Admin 2 ke `assets/` (lokal, tanpa CDN).

## Langkah
1. Buat folder: `pendataan-alumni/{includes,assets/{css,js,img,vendor},database}`.
2. Buat `database/db_alumni.sql` berisi `CREATE DATABASE`, `USE`, `CREATE TABLE alumni`, dan `INSERT` data contoh (salin dari `database.md`).
3. Import ke MySQL (phpMyAdmin) dan pastikan tabel terbentuk.
4. Buat `koneksi.php` sesuai pola di `coding-rules.md` (mysqli, `utf8mb4`, `$conn`, error ke log).
5. Salin ke `assets/`: `css/sb-admin-2.min.css`, `js/sb-admin-2.min.js`, dan `vendor/` (bootstrap, jquery, jquery-easing, fontawesome-free + `webfonts`).
6. Buat file kosong: `assets/css/custom.css`, `assets/js/app.js`.
7. Buat stub kosong `index.php` yang menulis "OK" dan menguji `require 'koneksi.php'`.

## Acceptance Criteria
- [ ] `http://localhost/pendataan-alumni/` terbuka tanpa error.
- [ ] `SELECT COUNT(*) FROM alumni` mengembalikan 2.
- [ ] `koneksi.php` memunculkan pesan umum (bukan stack trace) bila MySQL mati.
- [ ] Semua aset dapat dimuat offline (cek tab Network, tanpa request ke domain lain).
- [ ] `db_alumni.sql` dapat di-import ulang di database kosong tanpa error.

## Di luar lingkup
Layout, halaman CRUD, validasi.

## Definition of Done
Lihat `coding-rules.md` § Definition of Done.

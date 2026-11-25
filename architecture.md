# Architecture

## Gaya arsitektur

PHP native, **page-per-file**. Tidak ada framework, router, atau ORM. Logika dipisah secukupnya:

- **Halaman tampilan** (`index.php`, `tambah.php`, `edit.php`) — membaca data & merender HTML.
- **Skrip proses** (`proses_tambah.php`, `proses_edit.php`, `hapus.php`) — menerima POST, validasi, query, lalu redirect. Tidak mencetak HTML.
- **Include bersama** (`includes/`) — layout, helper, koneksi.

## Struktur folder

Berdasarkan RPD §R, dengan satu tambahan (`includes/`) agar layout SB Admin 2 tidak diduplikasi di tiap halaman (lihat ADR-003).

```
pendataan-alumni/
├── index.php              ← Data Alumni: tabel + pencarian
├── tambah.php             ← form tambah
├── edit.php               ← form edit (data lama terisi)
├── hapus.php              ← hapus (POST), lalu redirect
├── koneksi.php            ← koneksi mysqli ke db_alumni
├── proses_tambah.php      ← validasi + INSERT
├── proses_edit.php        ← validasi + UPDATE
├── includes/              ← [tambahan di luar RPD]
│   ├── header.php         ← <head>, CSS, buka wrapper, sidebar, topbar
│   ├── sidebar.php        ← sidebar SB Admin 2 (1 menu)
│   ├── footer.php         ← tutup wrapper, JS, modal hapus
│   └── functions.php      ← e(), flash(), validate_alumni(), konstanta
├── assets/
│   ├── css/               ← sb-admin-2.min.css, custom.css
│   ├── js/                ← sb-admin-2.min.js, app.js (konfirmasi hapus)
│   ├── img/
│   └── vendor/            ← bootstrap, jquery, fontawesome (dari SB Admin 2)
└── database/
    └── db_alumni.sql      ← CREATE DATABASE + TABLE (+ data contoh)
```

## Alur request

### Baca (GET)
```
Browser → index.php?q=kata
            ├─ require koneksi.php, includes/functions.php
            ├─ SELECT ... WHERE (LIKE ...) ORDER BY id_alumni  [prepared]
            └─ render includes/header + tabel + includes/footer
```

### Tulis (POST, pola PRG)
```
Browser → tambah.php (form)
        → POST proses_tambah.php
            ├─ validate_alumni($_POST)
            ├─ gagal  : simpan error + old input ke $_SESSION → redirect tambah.php
            └─ sukses : INSERT (prepared) → flash('success') → redirect index.php
```
Pola yang sama untuk `proses_edit.php` (UPDATE → redirect `index.php`) dan `hapus.php` (DELETE → redirect `index.php`).

## Middleware / cross-cutting

Tidak ada middleware. Hal lintas-halaman ditangani lewat include:

| Concern | Tempat |
|---|---|
| Koneksi DB | `koneksi.php` (di-`require_once` oleh tiap skrip yang butuh DB) |
| Session (hanya untuk flash & old input — **bukan auth**) | `session_start()` di `includes/functions.php` |
| Escape output | `e()` di `includes/functions.php` |
| Validasi | `validate_alumni()` di `includes/functions.php` |
| Layout | `includes/header.php`, `sidebar.php`, `footer.php` |
| Guard method | Skrip proses menolak non-POST dengan redirect ke `index.php` |

## Alur data

```
Form HTML ──POST──► proses_*.php ──validate──► mysqli prepared stmt ──► MySQL (tabel alumni)
                         │                                                   │
                         └──redirect + flash──► index.php ◄──SELECT──────────┘
```

## Batas tanggung jawab

- File proses tidak boleh `echo` HTML (kecuali pesan fatal singkat).
- Halaman tampilan tidak boleh melakukan INSERT/UPDATE/DELETE.
- Tidak ada logika bisnis di `assets/js/` selain interaksi UI (konfirmasi hapus, validasi ringan).

# UI Design

Template: **SB Admin 2** (Bootstrap 4). Gunakan struktur `#wrapper > #sidebar + #content-wrapper > #content (topbar + container-fluid) + footer`.

## Layout global

```
┌──────────────┬──────────────────────────────────────────┐
│ SIDEBAR      │ TOPBAR  (judul sistem, tanpa menu user)  │
│ (gelap)      ├──────────────────────────────────────────┤
│ ◉ Sistem     │                                          │
│   Pendataan  │   <konten halaman>                       │
│   Alumni     │                                          │
│ ──────────── │                                          │
│ ▸ Data Alumni│                                          │
│              ├──────────────────────────────────────────┤
│              │ Footer: © Sistem Pendataan Alumni 2026/27│
└──────────────┴──────────────────────────────────────────┘
```

- Sidebar: brand "Sistem Pendataan Alumni" + **satu** item menu "Data Alumni" (`fa-user-graduate`), aktif di `index.php`, `tambah.php`, `edit.php`.
- Topbar: tombol toggle sidebar (mobile) dan judul. **Jangan** menampilkan dropdown user/logout/notifikasi/pencarian bawaan template (tidak ada login).
- Hapus bagian template yang tidak dipakai (alerts, messages, charts).

## Halaman 1 — Data Alumni (`index.php`)

```
Data Alumni                                    [+ Tambah Alumni]
┌ card ──────────────────────────────────────────────────────┐
│ [ Cari NISN, nama, jurusan...        ] [Cari] [Reset]      │
│ ┌────┬────────┬────────┬──┬───────┬───────┬────────┬──────┬────────────┐
│ │ ID │ NISN   │ Nama   │JK│ Tahun │Jurusan│Pekerjaan│Status│ Aksi       │
│ ├────┼────────┼────────┼──┼───────┼───────┼────────┼──────┼────────────┤
│ │ 2  │1234... │Contoh 2│P │ 2025  │ TKJ   │Mahasiswa│Kuliah│[Edit][Hapus]│
│ │ 1  │1234... │Contoh  │L │ 2025  │ RPL   │Teknisi │Bekerja│[Edit][Hapus]│
│ └────┴────────┴────────┴──┴───────┴───────┴────────┴──────┴────────────┘
└────────────────────────────────────────────────────────────┘
```

| Komponen | Spesifikasi |
|---|---|
| Flash alert | `alert alert-success/danger alert-dismissible` di atas card |
| Judul | `h1.h3 text-gray-800` "Data Alumni" |
| Tombol tambah | `btn btn-primary btn-icon-split` ke `tambah.php` |
| Form cari | `GET`, input `name="q"` `form-control`, nilai diisi ulang (`e($q)`), tombol Cari `btn-primary`, Reset `btn-secondary` (link ke `index.php`) |
| Tabel | `table table-bordered table-hover` dalam `.table-responsive`; header 9 kolom (RPD §Q) |
| Kolom JK | `L` / `P` |
| Tombol Edit | `btn btn-sm btn-warning` → `edit.php?id=…` |
| Tombol Hapus | `btn btn-sm btn-danger` → membuka modal (`data-id`, `data-nama`) |
| Badge Status | Bekerja=`success`, Kuliah=`info`, Wirausaha=`warning`, Lainnya=`secondary` |
| Kosong | satu baris `colspan=9` teks tengah |

## Halaman 2 — Form Tambah (`tambah.php`) & Edit (`edit.php`)

Satu partial form dipakai bersama (mis. `includes/form_alumni.php`) agar tidak duplikat; hanya `action`, judul, dan nilai awal yang berbeda.

```
Tambah Alumni  /  Edit Alumni
┌ card ──────────────────────────────────────────────┐
│ [alert error ringkasan, jika ada]                  │
│ NISN *            [__________]                     │
│ Nama Lengkap *    [______________________]         │
│ Jenis Kelamin *   (•) Laki-laki  ( ) Perempuan     │
│ Tempat Lahir      [__________]  Tanggal Lahir [date]│
│ Tahun Lulus *     [____]   Jurusan [__________]    │
│ Alamat            [textarea                    ]   │
│ No. HP            [__________]                     │
│ Pekerjaan         [__________]                     │
│ Status            [ Pilih ▾ ]                      │
│                         [Batal]  [Simpan]          │
└────────────────────────────────────────────────────┘
```

| Field | Elemen | Catatan |
|---|---|---|
| nisn | `input text` `inputmode="numeric"` `maxlength=20` | wajib `*` |
| nama_lengkap | `input text` `maxlength=100` | wajib |
| jenis_kelamin | `radio` ×2 (atau `select`) | wajib |
| tempat_lahir | `input text` | |
| tanggal_lahir | `input date` | `max` = hari ini |
| tahun_lulus | `input number` `min=1950` `max=tahun+1` | wajib |
| jurusan | `input text` | |
| alamat | `textarea rows=3` | |
| no_hp | `input tel` `maxlength=20` | |
| pekerjaan | `input text` | |
| status | `select` (Bekerja/Kuliah/Wirausaha/Lainnya) | opsi kosong "— Pilih —" |

- Label wajib ditandai `*` merah. Error per field: `is-invalid` + `<div class="invalid-feedback">`.
- Tombol: **Simpan** (`btn-primary`, submit), **Batal** (`btn-secondary`, link ke `index.php`).
- Layout responsif: `row` + `col-md-6` untuk pasangan field; satu kolom di layar kecil.
- Edit: tambahkan `<input type="hidden" name="id_alumni">`.

## Halaman 3 — Konfirmasi Hapus (modal di `index.php`)

```
┌ Hapus data alumni ─────────────────────────[x]┐
│ Yakin ingin menghapus "Contoh Alumni"?        │
│ Tindakan ini tidak dapat dibatalkan.          │
│                      [Batal]  [Ya, Hapus]     │
└───────────────────────────────────────────────┘
```
Satu modal bersama; `app.js` mengisi nama & `id_alumni` dari atribut `data-*` tombol Hapus. **Ya, Hapus** = `btn-danger` submit form POST ke `hapus.php`.

## Kebijakan teks UI

Bahasa Indonesia, nada sederhana. Pesan standar ada di `routes-spec.md`.

## Responsif

Mengandalkan grid Bootstrap 4 + sidebar collapse SB Admin 2. Uji di lebar ≈ 360px, 768px, 1366px.

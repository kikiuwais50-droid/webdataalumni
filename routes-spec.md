# Routes Spec

Aplikasi tidak memiliki REST API/JSON. "Endpoint" = file PHP. Ada 3 halaman tampilan (GET) dan 3 skrip proses (POST). Tidak ada autentikasi di semua endpoint.

Ringkasan:

| # | Method | Path | Tipe | Fungsi |
|---|---|---|---|---|
| 1 | GET | `/index.php` | Halaman | Daftar alumni + pencarian |
| 2 | GET | `/tambah.php` | Halaman | Form tambah |
| 3 | POST | `/proses_tambah.php` | Proses | Validasi + INSERT |
| 4 | GET | `/edit.php?id=N` | Halaman | Form edit |
| 5 | POST | `/proses_edit.php` | Proses | Validasi + UPDATE |
| 6 | POST | `/hapus.php` | Proses | DELETE |

---

## 1. GET `/index.php` — Data Alumni

| Parameter | Lokasi | Wajib | Keterangan |
|---|---|---|---|
| `q` | query string | – | Kata kunci pencarian; di-`trim()`. Kosong = tampilkan semua |

**Respons:** HTML 200.
- Judul "Data Alumni", tombol **Tambah Alumni**, form pencarian (`GET`, input `q`), tabel data.
- Kolom: ID, NISN, Nama, JK, Tahun Lulus, Jurusan, Pekerjaan, Status, Aksi (Edit | Hapus).
- JK ditampilkan `L`/`P`.
- Jika kosong: baris "Data alumni tidak ditemukan." (saat `q` terisi) atau "Belum ada data alumni." (tanpa `q`).
- Menampilkan flash message bila ada.

## 2. GET `/tambah.php`

**Respons:** HTML 200 — form dengan 10 input (lihat `ui-design.md`).
Jika datang dari redirect validasi gagal: tampilkan `$_SESSION['errors']` dan isi ulang dari `$_SESSION['old']`, lalu hapus keduanya.

## 3. POST `/proses_tambah.php`

| Field | Wajib | Aturan |
|---|---|---|
| `nisn` | ✅ | tidak kosong, digit, ≤ 20 |
| `nama_lengkap` | ✅ | tidak kosong, ≤ 100 |
| `jenis_kelamin` | ✅ | ∈ `JENIS_KELAMIN` |
| `tempat_lahir` | – | ≤ 100 |
| `tanggal_lahir` | – | `YYYY-MM-DD` valid, tidak di masa depan |
| `tahun_lulus` | ✅ | integer 1950..(tahun ini + 1) |
| `jurusan` | – | ≤ 100 |
| `alamat` | – | teks bebas |
| `no_hp` | – | `/^[0-9+\-\s()]{8,20}$/` bila diisi |
| `pekerjaan` | – | ≤ 100 |
| `status` | – | ∈ `STATUS_ALUMNI` bila diisi |

**Respons (tanpa body, redirect 302):**

| Kondisi | Redirect | Efek session |
|---|---|---|
| Bukan POST | `index.php` | – |
| Validasi gagal | `tambah.php` | `errors[]` (per field) + `old` (input) |
| Sukses | `index.php` | flash `success`: "Data alumni berhasil ditambahkan." |
| Error DB | `tambah.php` | flash `danger`: "Gagal menyimpan data." (detail ke `error_log`, bukan ke user) |

## 4. GET `/edit.php?id=N`

| Parameter | Wajib | Aturan |
|---|---|---|
| `id` | ✅ | integer > 0, ada di tabel |

**Respons:**
- 200: form yang sama dengan tambah, terisi data lama + hidden input `id_alumni`.
- `id` tidak valid / tidak ditemukan → flash `danger` "Data alumni tidak ditemukan." + redirect `index.php`.
- Setelah validasi gagal, `old` dari session menggantikan data DB.

## 5. POST `/proses_edit.php`

Field sama dengan `proses_tambah.php` + `id_alumni` (hidden, wajib, integer > 0).

| Kondisi | Redirect | Pesan |
|---|---|---|
| Bukan POST | `index.php` | – |
| `id_alumni` tidak valid / tidak ada | `index.php` | flash `danger` "Data alumni tidak ditemukan." |
| Validasi gagal | `edit.php?id=N` | `errors[]` + `old` |
| Sukses | `index.php` | flash `success` "Data alumni berhasil diperbarui." |
| Error DB | `edit.php?id=N` | flash `danger` "Gagal memperbarui data." |

## 6. POST `/hapus.php`

| Field | Wajib | Aturan |
|---|---|---|
| `id_alumni` | ✅ | integer > 0 |

Dipanggil dari modal konfirmasi di `index.php` (form kecil POST). Menghapus lewat GET **tidak didukung** (ADR-005).

| Kondisi | Redirect | Pesan |
|---|---|---|
| Bukan POST / id tidak valid | `index.php` | flash `danger` "Permintaan tidak valid." |
| `affected_rows = 0` | `index.php` | flash `danger` "Data alumni tidak ditemukan." |
| Sukses | `index.php` | flash `success` "Data alumni berhasil dihapus." |

---

## Format flash message

```php
$_SESSION['flash'] = ['type' => 'success'|'danger', 'message' => '...'];
```
Dirender sebagai `alert alert-{type}` (Bootstrap) dengan tombol tutup; dihapus dari session setelah ditampilkan.

## Format error validasi

```php
$_SESSION['errors'] = [
  'nisn'         => 'NISN tidak boleh kosong.',
  'tahun_lulus'  => 'Tahun lulus harus berupa angka 4 digit.',
];
```
Pesan di bawah field terkait (`invalid-feedback`) + ringkasan alert di atas form.

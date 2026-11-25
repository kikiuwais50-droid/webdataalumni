# Task 004 — Tambah Alumni (Create)

**Tujuan:** Admin dapat menambah data alumni lewat form dan data tersimpan di MySQL.
**Dependensi:** 003
**Referensi:** RPD §I.2, §K, §P, §S · `routes-spec.md` #2, #3 · `workflow.md` W2 · `ui-design.md` Halaman 2

## Lingkup
`tambah.php`, `proses_tambah.php`, partial form bersama `includes/form_alumni.php`. Validasi lengkap dikerjakan di task 007; di task ini cukup validasi minimum (field wajib tidak kosong) agar alur berfungsi.

## Langkah
1. Buat `includes/form_alumni.php`: menerima `$action`, `$values` (array nilai awal), `$errors`; merender 10 input sesuai `ui-design.md`, tombol Simpan & Batal.
2. `tambah.php`: ambil `old`/`errors` dari session (lalu hapus), render form dalam layout, `action="proses_tambah.php"`.
3. `proses_tambah.php`:
   a. Tolak non-POST → redirect `index.php`.
   b. Ambil & `trim` input; ubah field opsional kosong → `null`.
   c. Validasi (pakai `validate_alumni()` bila sudah ada dari task 007; sementara cek wajib).
   d. `INSERT` dengan prepared statement (11 kolom, tipe `ssssssssss` + `tahun_lulus` sebagai `i`).
   e. Sukses → `flash('success', …)` + redirect `index.php`; gagal DB → `error_log` + flash `danger` + redirect `tambah.php`.
4. Pastikan tombol **Tambah Alumni** di `index.php` menuju `tambah.php`.

## Acceptance Criteria
- [ ] Data lengkap tersimpan; muncul di tabel paling atas dengan flash sukses.
- [ ] Field opsional kosong tersimpan `NULL` (cek di phpMyAdmin), `tanggal_lahir` tidak menjadi `0000-00-00`.
- [ ] Refresh setelah simpan tidak menambah data lagi (PRG).
- [ ] Membuka `proses_tambah.php` via URL langsung tidak menambah data.
- [ ] Karakter khusus (`'`, `"`, `<`, `&`) tersimpan dan tampil benar.
- [ ] Skenario uji #2 lulus.

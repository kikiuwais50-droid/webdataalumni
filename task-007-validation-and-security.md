# Task 007 — Validasi & Keamanan

**Tujuan:** Memusatkan validasi server, menambah bantuan validasi klien, dan memastikan pengamanan SQL Injection/XSS merata.
**Dependensi:** 004, 005
**Referensi:** RPD §I.6, §J, §T · `routes-spec.md` (tabel aturan field) · `database.md` · ADR-007, ADR-009, ADR-011

## Lingkup
- `validate_alumni(array $in, ?int $exclude_id = null): array` di `includes/functions.php`.
- Tampilan error pada form (ringkasan + per field).
- Atribut HTML5 & audit keamanan.

## Langkah
1. Implementasikan `validate_alumni()` → `[$errors, $clean]` dengan aturan:
   - `nisn`: wajib, `ctype_digit`, ≤ 20
   - `nama_lengkap`: wajib, ≤ 100
   - `jenis_kelamin`: ∈ `JENIS_KELAMIN`
   - `tahun_lulus`: wajib, integer 1950..(tahun ini + 1)
   - `tanggal_lahir`: bila diisi, valid `Y-m-d` (`DateTime::createFromFormat`) dan ≤ hari ini
   - `no_hp`: bila diisi, `/^[0-9+\-\s()]{8,20}$/`
   - `status`: bila diisi, ∈ `STATUS_ALUMNI`
   - Panjang maksimum untuk `tempat_lahir`, `jurusan`, `pekerjaan` (≤ 100)
   - Field opsional kosong → `null` di `$clean`
2. Ganti validasi sementara di `proses_tambah.php` & `proses_edit.php` dengan fungsi ini.
3. Pastikan form menampilkan alert ringkasan + `is-invalid`/`invalid-feedback` per field dan mengisi ulang `old`.
4. Tambahkan `required`, `maxlength`, `min/max`, `pattern` HTML5 pada form (bantuan UX saja).
5. **(Bila ADR-009 disetujui)** Cek NISN ganda: `SELECT 1 FROM alumni WHERE nisn = ? AND id_alumni <> ?` → error "NISN sudah terdaftar."
6. Audit: `grep` semua `*.php` untuk `->query(` dengan variabel, dan `echo`/`<?=` tanpa `e()`.

## Acceptance Criteria
- [ ] Kasus V1–V11 di `testing.md` bagian B lulus (V10 hanya jika ADR-009 disetujui).
- [ ] Kasus keamanan S1, S2 lulus.
- [ ] Input yang dimanipulasi lewat DevTools (menghapus `required`, mengubah nilai radio) tetap ditolak server.
- [ ] Tidak ada query yang menggabungkan input pengguna ke string SQL.
- [ ] Skenario uji #3 lulus.

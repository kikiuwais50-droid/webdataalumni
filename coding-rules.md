# Coding Rules

Konvensi untuk PHP native + HTML + JS. (Proyek ini **bukan** Laravel/React.)

## Umum

- PHP ≥ 7.4 (kompatibel dengan XAMPP umum). Tag pembuka `<?php`; file murni PHP tanpa tag penutup `?>`.
- Indentasi 4 spasi, UTF-8 tanpa BOM, akhir baris LF.
- Nama file `snake_case.php`; variabel & fungsi `snake_case`; konstanta `UPPER_SNAKE`.
- Bahasa: identifier (variabel/fungsi/kolom) dalam konvensi RPD (Indonesia untuk kolom DB), komentar singkat dalam bahasa Indonesia; teks UI bahasa Indonesia.
- Satu file = satu tanggung jawab (lihat batas di `architecture.md`).

## Koneksi database (`koneksi.php`)

```php
<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$host = 'localhost'; $user = 'root'; $pass = ''; $db = 'db_alumni';
try {
    $conn = new mysqli($host, $user, $pass, $db);
    $conn->set_charset('utf8mb4');
} catch (mysqli_sql_exception $e) {
    error_log($e->getMessage());
    http_response_code(500);
    exit('Tidak dapat terhubung ke database.');
}
```
Variabel koneksi selalu `$conn`.

## Query — WAJIB prepared statement

```php
$stmt = $conn->prepare('SELECT * FROM alumni WHERE id_alumni = ?');
$stmt->bind_param('i', $id);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();
$stmt->close();
```
- Dilarang: `"... WHERE id = $_GET[id]"`, `mysqli_query` dengan variabel user, `real_escape_string` sebagai pengganti prepared statement.
- Tipe bind: `i` integer, `s` string. `NULL` boleh di-bind lewat `s`.
- Wildcard LIKE dibuat di PHP (`'%'.$q.'%'`) lalu di-bind; escape `%` dan `_` dari input bila perlu.

## Output — WAJIB escape

```php
function e(?string $v): string { return htmlspecialchars($v ?? '', ENT_QUOTES, 'UTF-8'); }
```
Gunakan `<?= e($row['nama_lengkap']) ?>` untuk semua data dari DB/user, termasuk atribut `value=""` dan teks pencarian yang ditampilkan ulang.

## Input & validasi

- Ambil input hanya dari `$_POST`/`$_GET` yang dikenal; `trim()` semua string.
- Validasi di server **selalu** (validasi JS hanya kenyamanan). Satu fungsi `validate_alumni(array $in): array` mengembalikan `[$errors, $clean]`.
- Field opsional kosong → `null`.
- Jangan percaya `required` HTML5 sebagai satu-satunya proteksi.

## Pola alur tulis

1. Cek `$_SERVER['REQUEST_METHOD'] === 'POST'`, kalau tidak → redirect.
2. Validasi → bila gagal, simpan `errors` + `old` di session lalu `header('Location: ...'); exit;`.
3. Eksekusi query → flash → redirect (PRG). **Selalu `exit` setelah `header('Location')`.**
4. Jangan menampilkan pesan error MySQL ke pengguna; catat ke `error_log`.

## Session

`session_start()` hanya untuk flash message & old input. Jangan menyimpan data user/auth.

## HTML / UI

- Pakai komponen Bootstrap 4 bawaan SB Admin 2 (card, table, form-control, btn, alert, modal). Jangan menambah framework CSS lain.
- CSS kustom hanya di `assets/css/custom.css`; JS kustom hanya di `assets/js/app.js`.
- Semua `<form>` POST memakai `method="post"` dan `action` eksplisit; tombol submit `btn btn-primary`.
- Aset dipanggil dengan path relatif ke `assets/` (tanpa CDN agar bisa jalan offline di XAMPP).
- Tabel dibungkus `.table-responsive`.

## JavaScript

- Vanilla JS atau jQuery bawaan SB Admin 2; tanpa bundler/npm.
- Konfirmasi hapus: tombol Hapus membuka modal Bootstrap, mengisi hidden `id_alumni` & nama alumni; submit form POST ke `hapus.php`.
- Jangan membuat request AJAX di versi ini (tidak ada di RPD).

## Keamanan minimum

- Prepared statement di semua query.
- `e()` di semua output.
- Hapus hanya via POST.
- Tidak ada kredensial DB di luar `koneksi.php`.
- `display_errors` boleh aktif di dev; di produksi nonaktif.

## Git & commit (bila dipakai)

Satu commit per sub-tugas task. Format: `task-004: tambah form & proses simpan alumni`.

## Definition of Done (berlaku untuk setiap task)

- [ ] Semua acceptance criteria task terpenuhi
- [ ] Mengikuti rules di atas (prepared statement, `e()`, PRG)
- [ ] Tidak ada warning/notice PHP saat dijalankan
- [ ] Skenario uji terkait di `testing.md` lulus

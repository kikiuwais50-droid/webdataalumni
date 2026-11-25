# Deployment — Instalasi & Troubleshooting

Target: komputer lokal (Windows/Linux/macOS) dengan XAMPP. Tidak ada deployment cloud dalam RPD.

## Prasyarat

| Item | Minimal |
|---|---|
| Perangkat | Laptop/PC, RAM 4 GB |
| XAMPP | Apache + MySQL/MariaDB, PHP ≥ 7.4 |
| Browser | Chrome / Edge / Firefox |
| Editor | VS Code |

## Instalasi

1. **Install XAMPP**, lalu jalankan **Apache** dan **MySQL** dari XAMPP Control Panel.
2. **Salin proyek** ke folder `htdocs`:
   - Windows: `C:\xampp\htdocs\pendataan-alumni\`
   - Linux: `/opt/lampp/htdocs/pendataan-alumni/`
   - macOS: `/Applications/XAMPP/htdocs/pendataan-alumni/`
3. **Buat database:**
   - Buka `http://localhost/phpmyadmin` → tab **Import** → pilih `database/db_alumni.sql` → **Go**.
   - (Alternatif CLI) `mysql -u root < database/db_alumni.sql`
4. **Cek `koneksi.php`:** host `localhost`, user `root`, password kosong (default XAMPP), database `db_alumni`.
5. **Buka aplikasi:** `http://localhost/pendataan-alumni/`
6. Jalankan checklist di `testing.md`.

## Konfigurasi yang disarankan

| Lingkungan | `display_errors` | Catatan |
|---|---|---|
| Pengembangan | On, `E_ALL` | Aktifkan di `php.ini` atau awal `functions.php` |
| Demo/produksi | Off | Error hanya ke log (`error_log`) |

Bila di luar jaringan lokal, **ganti password user MySQL** dan jangan memakai `root` tanpa password — ingat sistem ini tidak memiliki login (ADR-002).

## Troubleshooting

| Gejala | Penyebab umum | Solusi |
|---|---|---|
| Apache tidak mau start | Port 80 dipakai (Skype/IIS/aplikasi lain) | Ubah port di `httpd.conf` (`Listen 8080`) lalu akses `localhost:8080` |
| MySQL tidak mau start | Port 3306 bentrok / data korup | Hentikan MySQL lain; cek log XAMPP |
| "Tidak dapat terhubung ke database." | MySQL mati, kredensial salah, DB belum diimport | Start MySQL; cek `koneksi.php`; import `db_alumni.sql` |
| `Unknown database 'db_alumni'` | SQL belum diimport | Import ulang `db_alumni.sql` |
| Halaman putih | Error PHP tersembunyi | Aktifkan `display_errors` di dev / lihat `php_error_log` |
| Tampilan berantakan, tanpa CSS | Path `assets/` salah / aset SB Admin 2 belum disalin | Periksa path relatif & isi `assets/vendor`, `assets/css` |
| Ikon tidak muncul | Folder `webfonts` Font Awesome tidak ikut | Salin `assets/vendor/fontawesome-free/webfonts` |
| Karakter aneh (é, ’) | Charset | Pastikan `utf8mb4` di DB dan `set_charset` di `koneksi.php` |
| Flash tidak muncul / selalu muncul | `session_start()` tidak terpanggil | Pastikan `functions.php` ter-include sebelum output |
| Modal hapus tidak terbuka | jQuery/Bootstrap JS belum dimuat | Periksa urutan script di `footer.php`, console browser |
| `Call to undefined function mysqli_...` | Ekstensi mysqli mati | Aktifkan `extension=mysqli` di `php.ini`, restart Apache |

## Backup manual (sementara, sebelum fitur backup §W)

phpMyAdmin → pilih `db_alumni` → **Export** → simpan `.sql`.

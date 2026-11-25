# Project Overview

## Identitas

| Komponen | Nilai |
|---|---|
| Nama sistem | Sistem Pendataan Alumni |
| Jenis | Aplikasi berbasis web |
| Konsep | CRUD (Create, Read, Update, Delete) + Search |
| Template UI | SB Admin 2 |
| Database | MySQL / MariaDB (`db_alumni`) |
| Pengguna | Admin / petugas sekolah |
| Login | **Tidak ada** |
| Menu | Satu menu utama: **Data Alumni** |
| Tahun pelajaran | 2026/2027 |

## Tujuan

Mengelola data alumni sekolah secara terstruktur dan mudah dicari, menggantikan pencatatan manual yang lambat, rawan duplikasi, dan sulit diubah.

## Masalah yang diselesaikan

- Data alumni belum berada dalam satu sistem terstruktur.
- Pencarian manual memakan waktu.
- Perubahan data sulit; rawan duplikasi dan salah catat.
- Belum ada tampilan sederhana untuk mengelola data.

## Scope (WAJIB — RPD §Y)

1. Website Sistem Pendataan Alumni
2. Database MySQL
3. CRUD Alumni (tampil, tambah, edit, hapus)
4. Template SB Admin 2
5. Pencarian data
6. Validasi form
7. Dokumentasi RPD

## Di luar scope (JANGAN dikerjakan)

| Item | Sumber RPD | Status |
|---|---|---|
| Login & hak akses | §G, §W, §Y.8 | Tidak digunakan |
| Ekspor Excel/PDF | §W | Pengembangan lanjutan |
| Foto alumni | §W | Pengembangan lanjutan |
| Filter tahun lulus/jurusan | §W | Pengembangan lanjutan |
| Statistik jumlah alumni | §W | Pengembangan lanjutan |
| Backup database | §W | Pengembangan lanjutan |
| Halaman profil alumni | §W | Pengembangan lanjutan |
| Nilai, absensi, data siswa aktif | §G | Tidak dibahas |

## Stack

| Lapisan | Teknologi |
|---|---|
| Bahasa server | PHP (native, tanpa framework) |
| Database | MySQL/MariaDB via ekstensi `mysqli` |
| Frontend | HTML, CSS, JavaScript, Bootstrap 4 (bawaan SB Admin 2), jQuery (bawaan SB Admin 2) |
| Web server lokal | XAMPP (Apache + MySQL) |
| Editor | VS Code atau sejenis |
| Browser | Chrome / Edge / Firefox |

## Routing (ringkas)

Tidak ada router — setiap halaman adalah file PHP langsung (`index.php`, `tambah.php`, ...). Detail di `routes-spec.md`.

| URL | Fungsi |
|---|---|
| `/index.php` | Data Alumni (tabel + pencarian) |
| `/tambah.php` | Form tambah |
| `/proses_tambah.php` | Simpan data baru (POST) |
| `/edit.php?id=N` | Form edit |
| `/proses_edit.php` | Simpan perubahan (POST) |
| `/hapus.php` | Hapus data (POST) |

## Persyaratan nonfungsional

- Antarmuka mudah dipahami; responsif pada ukuran layar umum (bawaan SB Admin 2).
- Data tersimpan terstruktur di database.
- Validasi form untuk mengurangi kesalahan input.
- Struktur folder rapi dan mudah dikembangkan.

## Glosarium

| Istilah | Arti |
|---|---|
| RPD | Rencana Pengembangan Desain — dokumen sumber proyek |
| NISN | Nomor Induk Siswa Nasional |
| Flash message | Pesan sekali tampil (sukses/gagal) setelah redirect |
| PRG | Post-Redirect-Get: POST → redirect → GET, mencegah submit ganda saat refresh |

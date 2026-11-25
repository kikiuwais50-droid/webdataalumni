# Testing

Pengujian manual (tanpa framework test) sesuai RPD §U, diperluas dengan kasus validasi & keamanan.

## A. Skenario uji RPD (wajib lulus)

| No | Skenario | Langkah | Hasil diharapkan | Task |
|---|---|---|---|---|
| 1 | Membuka halaman | Buka `/pendataan-alumni/` | Halaman Data Alumni tampil, tabel/pesan kosong, tanpa error PHP | 003 |
| 2 | Tambah data lengkap | Isi semua field valid → Simpan | Redirect ke tabel, flash sukses, data baru muncul | 004 |
| 3 | Tambah data kosong | Kirim form tanpa isian | Tidak tersimpan; pesan validasi muncul | 007 |
| 4 | Edit data | Klik Edit → ubah nama → Simpan | Data diperbarui, flash sukses | 005 |
| 5 | Hapus data | Klik Hapus → konfirmasi Ya | Data hilang dari tabel setelah konfirmasi | 006 |
| 6 | Cari data | Ketik kata kunci → Cari | Hanya data sesuai yang tampil | 003 |
| 7 | Muat ulang | Tambah data → F5 / tutup-buka browser | Data tetap ada; tidak terjadi insert ganda | 008 |

## B. Kasus validasi

| ID | Input | Hasil diharapkan |
|---|---|---|
| V1 | NISN kosong | Error "NISN tidak boleh kosong." |
| V2 | Nama lengkap kosong / hanya spasi | Error nama |
| V3 | Jenis kelamin tidak dipilih | Error JK |
| V4 | Jenis kelamin dimanipulasi jadi `X` (via DevTools) | Ditolak server |
| V5 | Tahun lulus `abc`, `20`, `3000` | Error tahun lulus |
| V6 | No HP `08abc` | Error no HP |
| V7 | No HP kosong | Diterima (opsional) |
| V8 | Tanggal lahir di masa depan | Error tanggal |
| V9 | Status di luar daftar | Ditolak |
| V10 | NISN sudah ada (jika ADR-009 disetujui) | Error "NISN sudah terdaftar." |
| V11 | Setelah error, isian lama tetap terisi | ✔ |

## C. Kasus keamanan

| ID | Aksi | Hasil diharapkan |
|---|---|---|
| S1 | Cari dengan `' OR '1'='1` | Dianggap teks biasa; tidak ada error SQL |
| S2 | Nama diisi `<script>alert(1)</script>` | Tersimpan, tampil sebagai teks (ter-escape), script tidak jalan |
| S3 | Akses `hapus.php?id=1` via GET | Tidak menghapus; redirect dengan pesan |
| S4 | `edit.php?id=99999` / `id=abc` | Redirect `index.php` + pesan tidak ditemukan |
| S5 | Buka `proses_tambah.php` langsung via URL | Redirect `index.php`, tidak insert |
| S6 | Matikan MySQL lalu buka halaman | Pesan umum, tanpa detail kredensial/stack trace |

## D. Checklist manual akhir

**Fungsional**
- [ ] Tabel menampilkan 9 kolom sesuai RPD §Q
- [ ] Tambah / edit / hapus / cari berjalan
- [ ] Konfirmasi hapus selalu muncul; Batal tidak menghapus
- [ ] Flash message muncul sekali, hilang setelah refresh

**Tampilan**
- [ ] Template SB Admin 2 tampil benar (sidebar, topbar, card)
- [ ] Sidebar hanya berisi "Data Alumni"
- [ ] Tidak ada elemen login/user/notifikasi sisa template
- [ ] Responsif di 360px / 768px / 1366px; tabel bisa di-scroll horizontal di layar kecil
- [ ] Chrome, Edge, dan Firefox

**Data & kode**
- [ ] Data tetap setelah restart Apache/MySQL
- [ ] Field opsional kosong tersimpan `NULL`
- [ ] Tidak ada query tanpa prepared statement (`grep -n "query(" *.php`)
- [ ] Tidak ada `echo $row[...]` tanpa `e()`
- [ ] Tidak ada notice/warning PHP (`error_reporting(E_ALL)` di dev)

**Dokumentasi**
- [ ] `database/db_alumni.sql` dapat di-import bersih di DB kosong
- [ ] Panduan `deployment.md` berhasil diikuti dari nol

## E. Format laporan uji

```
Tanggal: ...   Penguji: ...   Browser: ...
No | Skenario | Hasil (Lulus/Gagal) | Catatan
```

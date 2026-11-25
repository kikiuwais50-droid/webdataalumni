# Task 009 — Implementasi Fitur Master Program Studi (Prodi)

**Tujuan:** Mengimplementasikan modul Master Program Studi untuk Admin (CRUD prodi lengkap) serta mengintegrasikan pilihan prodi pada formulir alumni.
**Dependensi:** 001–008
**Referensi:** `feature-master-prodi.md` · `database/schema_master_prodi.sql` · `decisions.md` (ADR-012)

---

## Lingkup Pekerjaan

1. Eksekusi migrasi tabel `prodi` dan relasi `id_prodi` pada tabel `alumni`.
2. Pembuatan halaman CRUD Admin:
   - `prodi.php` (Read & Search daftar prodi)
   - `tambah_prodi.php` & `proses_tambah_prodi.php` (Create)
   - `edit_prodi.php` & `proses_edit_prodi.php` (Update)
   - `hapus_prodi.php` (Delete dengan proteksi relasi data alumni)
3. Integrasi Dropdown pada `includes/form_alumni.php` dan tampilan nama prodi pada `index.php`.
4. Penambahan menu navigasi "Master Prodi" di `includes/sidebar.php`.

---

## Langkah Pelaksanaan

1. **Database & Helper**:
   - Impor / jalankan `database/schema_master_prodi.sql`.
   - Tambahkan konstanta `JENJANG_PRODI` dan `AKREDITASI_PRODI` serta fungsi `get_active_prodi($conn)` di `includes/functions.php`.
2. **Halaman & Proses Admin**:
   - Bangun antarmuka `prodi.php` menggunakan styling card dan table SB Admin 2.
   - Sediakan validasi duplikasi `kode_prodi` pada `proses_tambah_prodi.php` dan `proses_edit_prodi.php`.
   - Tambahkan modal konfirmasi hapus pada `prodi.php`.
3. **Form Alumni**:
   - Ubah elemen input teks prodi di `includes/form_alumni.php` menjadi `<select>` dengan opsi dari master prodi.
   - Perbarui `validate_alumni()` untuk memvalidasi `id_prodi`.
4. **Verifikasi**:
   - Jalankan uji kelayakan sesuai tabel skenario di `feature-master-prodi.md`.

---

## Acceptance Criteria

- [x] Tabel `prodi` berhasil dibuat dan terhubung ke tabel `alumni`.
- [x] Admin dapat melihat, menambah, mengubah, dan menghapus data program studi.
- [x] Validasi kode prodi unik berfungsi optimal (tidak mengizinkan duplikasi kode).
- [x] Form Tambah & Edit Alumni menampilkan pilihan program studi dari master prodi yang aktif.
- [x] Data alumni lama tidak rusak dan tetap dapat dibuka/diedit dengan lancar.


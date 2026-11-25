# Workflow — Alur Kerja End-to-End

Tujuh alur, diturunkan dari RPD §N, §S, §U. Pelaku selalu **Admin/Petugas** (tanpa login).

## W1. Membuka sistem & melihat data (Read)
1. Admin membuka `http://localhost/pendataan-alumni/`.
2. `index.php` menjalankan `SELECT` semua alumni (urut `id_alumni DESC`).
3. Sistem menampilkan layout SB Admin 2 + tabel. Jika tabel kosong → pesan "Belum ada data alumni."
4. **Hasil:** halaman Data Alumni tampil.

## W2. Menambah data (Create)
1. Admin klik **Tambah Alumni** → `tambah.php`.
2. Admin mengisi form → **Simpan** → POST `proses_tambah.php`.
3. Server memvalidasi.
   - Gagal → kembali ke `tambah.php` dengan pesan error + isian lama (lihat W6).
   - Lulus → `INSERT` ke MySQL.
4. Redirect `index.php` + flash "Data alumni berhasil ditambahkan." Data baru muncul di tabel.

## W3. Mengubah data (Update)
1. Admin klik **Edit** pada baris → `edit.php?id=N`.
2. Form terisi data lama dari `SELECT ... WHERE id_alumni = ?`.
3. Admin mengubah → **Simpan Perubahan** → POST `proses_edit.php`.
4. Validasi → `UPDATE` → redirect `index.php` + flash "Data alumni berhasil diperbarui."
5. ID tidak valid/tidak ada → flash error + redirect `index.php`.

## W4. Menghapus data (Delete)
1. Admin klik **Hapus** → modal konfirmasi menampilkan nama alumni.
2. **Batal** → modal tertutup, tidak ada perubahan.
3. **Ya, Hapus** → POST `hapus.php` dengan `id_alumni`.
4. `DELETE` → redirect `index.php` + flash "Data alumni berhasil dihapus."

## W5. Mencari data (Search)
1. Admin mengetik kata kunci di kolom pencarian → **Cari** → `index.php?q=kata`.
2. Server menjalankan `SELECT ... WHERE kolom LIKE ?` (NISN, nama, jurusan, pekerjaan, status, tahun lulus).
3. Tabel menampilkan hanya data yang cocok; kata kunci tetap terisi di kolom pencarian.
4. Tidak ada hasil → "Data alumni tidak ditemukan." Tombol **Reset** mengosongkan `q`.

## W6. Validasi gagal
1. Input wajib kosong / format salah (NISN kosong, nama kosong, JK belum dipilih, tahun lulus bukan angka, no HP berisi huruf).
2. Server **tidak** menyimpan; kembali ke form sebelumnya (tambah/edit).
3. Form menampilkan ringkasan error + pesan per field; isian lama tetap terisi.
4. Admin memperbaiki lalu mengirim ulang.

## W7. Persistensi data
1. Setelah data dimasukkan, Admin memuat ulang halaman / menutup & membuka browser.
2. Data tetap tampil karena tersimpan di MySQL (bukan di session/browser).
3. Refresh setelah POST tidak mengirim ulang data (berkat pola PRG).

## Diagram alur utama (RPD §N)

```
Mulai → Buka Sistem Pendataan Alumni → Tampil tabel data
      → Pilih aksi: Tambah | Edit | Hapus | Cari
      → Validasi & proses → Simpan ke MySQL
      → Tampil data terbaru → Selesai
```

## Pemetaan alur → task

| Alur | Task |
|---|---|
| W1, W5 | 003 |
| W2 | 004 |
| W3 | 005 |
| W4 | 006 |
| W6 | 007 |
| W7 | 008 (uji) |

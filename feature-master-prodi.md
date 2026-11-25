# Dokumen Perancangan Fitur Tambahan: Master Program Studi (Prodi)

Dokumen ini merupakan spesifikasi teknis dan acuan perancangan untuk pengembangan **Fitur Master Program Studi (Prodi)** pada Sistem Pendataan Alumni.

---

## 1. Latar Belakang & Tujuan

Sebelumnya, data program studi alumni diinputkan secara manual sebagai teks bebas (`VARCHAR(100)`). Hal ini berpotensi menyebabkan ketidakkonsistenan data (misal: "Teknik Informatika", "TI", "teknik informatika", dan "T. Informatika" tersimpan sebagai variasi berbeda).

**Tujuan Fitur Master Prodi:**
1. Menyediakan entitas master terpusat untuk mengelola seluruh Program Studi di institusi.
2. Memfasilitasi atribut lengkap prodi: **Fakultas / Jurusan**, **Kode Prodi**, **Nama Prodi**, **Jenjang Pendidikan**, dan **Status Akreditasi**.
3. Mengubah pengisian prodi pada form alumni menjadi dropdown `<select>` dinamis berbasis master data.
4. Menjaga integritas data alumni sekaligus mempertahankan kompatibilitas terhadap data yang sudah ada sebelumnya (*backward compatibility*).

---

## 2. Struktur Data & Kamus Data

### 2.1 Tabel `prodi`

| No | Nama Kolom | Tipe Data | Nullable | Default | Keterangan / Aturan Validasi |
|:--:|---|---|:---:|---|---|
| 1 | `id_prodi` | `INT AUTO_INCREMENT` | No | PK | Primary Key, pengenal unik otomatis |
| 2 | `kode_prodi` | `VARCHAR(20)` | No | – | Unik (UNIQUE), alfanumerik kapital (contoh: `TI`, `RPL`, `SI`, `TKJ`). Wajib diisi, maks 20 karakter. |
| 3 | `nama_prodi` | `VARCHAR(100)` | No | – | Nama resmi program studi. Wajib diisi, maks 100 karakter. |
| 4 | `fakultas` | `VARCHAR(100)` | No | – | Fakultas atau jurusan induk naungan prodi. Wajib diisi, maks 100 karakter. |
| 5 | `jenjang` | `ENUM('D3','D4','S1','S2','SMK')` | No | `'S1'` | Jenjang pendidikan akademik / vokasi. Wajib dipilih. |
| 6 | `akreditasi` | `ENUM('Unggul','Baik Sekali','Baik','A','B','C','Belum Terakreditasi')` | No | `'Baik'` | Status akreditasi resmi BAN-PT / LAM. Wajib dipilih. |
| 7 | `status_aktif` | `TINYINT(1)` | No | `1` | Status keaktifan: `1` = Aktif (ditampilkan di form input alumni), `0` = Nonaktif (diarsip). |
| 8 | `created_at` | `TIMESTAMP` | Yes | `CURRENT_TIMESTAMP` | Waktu pencatatan data. |
| 9 | `updated_at` | `TIMESTAMP` | Yes | `CURRENT_TIMESTAMP ON UPDATE` | Waktu pembaruan data terakhir. |

### 2.2 Relasi dengan Tabel `alumni`

```text
+---------------------+              +-----------------------+
|        prodi        |              |        alumni         |
+---------------------+              +-----------------------+
| PK  id_prodi        | 1          * | PK  id_alumni         |
|     kode_prodi (UQ) |<-------------| FK  id_prodi (NULL)   |
|     nama_prodi      |              |     nim               |
|     fakultas        |              |     nama_lengkap      |
|     jenjang         |              |     prodi (legacy)    |
|     akreditasi      |              |     tahun_lulus       |
|     status_aktif    |              +-----------------------+
+---------------------+
```

- Kolom `id_prodi` ditambahkan ke tabel `alumni` sebagai **Foreign Key** opsional (`NULL` diizinkan).
- `ON DELETE SET NULL`: Jika sebuah prodi dihapus, riwayat data alumni tidak hilang, melainkan nilai `id_prodi` menjadi `NULL`.
- Kolom teks `prodi` lama tetap dipertahankan sebagai cadangan (fallback label).

---

## 3. Skema SQL (DDL & DML)

File skrip siap eksekusi tersimpan di [`database/schema_master_prodi.sql`](file:///c:/Users/ASUS/Downloads/pendataan-alumni-docs/pendataan-alumni/database/schema_master_prodi.sql).

```sql
CREATE TABLE IF NOT EXISTS prodi (
  id_prodi      INT AUTO_INCREMENT PRIMARY KEY,
  kode_prodi    VARCHAR(20)  NOT NULL UNIQUE,
  nama_prodi    VARCHAR(100) NOT NULL,
  fakultas      VARCHAR(100) NOT NULL,
  jenjang       ENUM('D3', 'D4', 'S1', 'S2', 'SMK') NOT NULL DEFAULT 'S1',
  akreditasi    ENUM('Unggul', 'Baik Sekali', 'Baik', 'A', 'B', 'C', 'Belum Terakreditasi') NOT NULL DEFAULT 'Baik',
  status_aktif  TINYINT(1)   NOT NULL DEFAULT 1,
  created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_kode_prodi (kode_prodi),
  INDEX idx_fakultas (fakultas),
  INDEX idx_status_aktif (status_aktif)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Relasi ke tabel alumni
ALTER TABLE alumni 
  ADD COLUMN id_prodi INT DEFAULT NULL AFTER tahun_lulus,
  ADD CONSTRAINT fk_alumni_prodi 
    FOREIGN KEY (id_prodi) REFERENCES prodi(id_prodi) 
    ON DELETE SET NULL ON UPDATE CASCADE;
```

### Data Awal / Seeder:
```sql
INSERT INTO prodi (kode_prodi, nama_prodi, fakultas, jenjang, akreditasi, status_aktif) VALUES
('RPL',  'Rekayasa Perangkat Lunak', 'Fakultas Ilmu Komputer & Rekayasa', 'S1', 'Unggul', 1),
('TI',   'Teknik Informatika',       'Fakultas Ilmu Komputer & Rekayasa', 'S1', 'Unggul', 1),
('SI',   'Sistem Informasi',         'Fakultas Ilmu Komputer & Rekayasa', 'S1', 'Baik Sekali', 1),
('TKJ',  'Teknik Komputer & Jaringan', 'Fakultas Teknik Komputer',        'D4', 'Baik Sekali', 1),
('BD',   'Bisnis Digital',           'Fakultas Ekonomi & Bisnis',         'S1', 'Baik', 1),
('MI',   'Manajemen Informatika',    'Fakultas Ilmu Komputer & Rekayasa', 'D3', 'Baik', 1);
```

---

## 4. Aturan Bisnis & Validasi Data

1. **Hak Akses**:
   - Menu Master Prodi hanya dapat diakses oleh user berkedudukan **Super Admin** (`require_admin()`).
   - User bertipe Alumni hanya dapat melihat nama prodi mereka dan memilih prodi yang aktif saat pembaruan profil.
2. **Keunikan Kode Prodi**:
   - `kode_prodi` bersifat sensitif dan harus unik di seluruh sistem (dicek via database `UNIQUE` dan validasi query PHP sebelum simpan).
   - Format kode prodi otomatis diubah menjadi huruf besar (`strtoupper(trim($in['kode_prodi']))`).
3. **Integritas Penghapusan (Safe Delete)**:
   - Jika prodi masih digunakan oleh 1 atau lebih data alumni, sistem **memberikan peringatan** atau menghitung jumlah alumni terkait (`SELECT COUNT(*) FROM alumni WHERE id_prodi = ?`).
   - Pilihan: Menolak penghapusan secara langsung dengan pesan peringatan edukatif, atau opsi ubah `status_aktif = 0` (soft toggle nonaktif) agar data referensi tetap terjaga rapi.
4. **Dropdown Dinamis Form Alumni**:
   - Form alumni hanya memuat daftar prodi dengan `status_aktif = 1`.
   - Format tampilan label dropdown: `[Jenjang] Nama Prodi (Kode) - Akreditasi: [Nilai]`. Contoh: `[S1] Teknik Informatika (TI) - Akreditasi: Unggul`.

---

## 5. Spesifikasi Routing & File Kerja

| No | File | Metode | Akses | Fungsi & Perilaku |
|:--:|---|:---:|:---:|---|
| 1 | `prodi.php` | GET | Admin | Menampilkan tabel master data prodi, tombol tambah, pencarian, dan badge akreditasi. |
| 2 | `tambah_prodi.php` | GET | Admin | Halaman form input data program studi baru. |
| 3 | `proses_tambah_prodi.php` | POST | Admin | Memvalidasi input, mengecek kode prodi unik, lalu melakukan `INSERT INTO prodi`. |
| 4 | `edit_prodi.php?id=N` | GET | Admin | Form edit program studi sesuai ID yang dipilih. |
| 5 | `proses_edit_prodi.php` | POST | Admin | Memvalidasi input dan melakukan `UPDATE prodi WHERE id_prodi = ?`. |
| 6 | `hapus_prodi.php` | POST | Admin | Memeriksa keterkaitan data alumni, lalu menghapus data prodi jika aman. |

---

## 6. Desain Antarmuka (UI/UX SB Admin 2)

### 6.1 Menu Navigasi Sidebar Admin (`includes/sidebar.php`)
```html
<!-- Nav Item - Master Data (Dropdown atau Single Item) -->
<li class="nav-item <?= in_array(basename($_SERVER['PHP_SELF']), ['prodi.php','tambah_prodi.php','edit_prodi.php']) ? 'active' : '' ?>">
    <a class="nav-link" href="prodi.php">
        <i class="fas fa-fw fa-university"></i>
        <span>Master Prodi</span>
    </a>
</li>
```

### 6.2 Visualisasi Badge Akreditasi
Untuk memperkaya tampilan tabel prodi, status akreditasi ditampilkan dengan badge warna kontekstual:
- **Unggul / A**: `<span class="badge badge-success"><i class="fas fa-award mr-1"></i>Unggul</span>`
- **Baik Sekali / B**: `<span class="badge badge-primary"><i class="fas fa-check-circle mr-1"></i>Baik Sekali</span>`
- **Baik / C**: `<span class="badge badge-info"><i class="fas fa-check mr-1"></i>Baik</span>`
- **Belum Terakreditasi**: `<span class="badge badge-secondary">Belum Terakreditasi</span>`

### 6.3 Pengintegrasian Form Alumni (`includes/form_alumni.php`)
Kolom input teks prodi lama digantikan dengan elemen select dinamis:
```html
<label for="id_prodi" class="font-weight-bold text-dark">Program Studi</label>
<select class="form-control" id="id_prodi" name="id_prodi">
    <option value="">-- Pilih Program Studi --</option>
    <?php while ($p = $daftar_prodi->fetch_assoc()): ?>
        <option value="<?= $p['id_prodi'] ?>" <?= ($values['id_prodi'] ?? '') == $p['id_prodi'] ? 'selected' : '' ?>>
            [<?= e($p['jenjang']) ?>] <?= e($p['nama_prodi']) ?> (<?= e($p['kode_prodi']) ?>) - <?= e($p['akreditasi']) ?>
        </option>
    <?php endwhile; ?>
</select>
```

---

## 7. Matriks Skenario Pengujian (Testing Plan)

| ID Uji | Kasus Pengujian | Aksi Input | Ekspektasi Hasil |
|:---:|---|---|---|
| TC-PR-01 | Akses tanpa otorisasi | User non-admin / belum login membuka `prodi.php` | Sistem me-redirect ke login/index dengan flash danger akses ditolak. |
| TC-PR-02 | Tambah prodi sukses | Input: `TI`, `Teknik Informatika`, `Fakultas Teknik`, `S1`, `Unggul` | Data tersimpan, dialihkan ke `prodi.php` dengan alert sukses. |
| TC-PR-03 | Validasi kode unik | Input kode prodi yang sudah terdaftar | Muncul pesan error "Kode Prodi sudah digunakan." dan form tidak tersimpan. |
| TC-PR-04 | Edit prodi | Ubah akreditasi dari `Baik` menjadi `Baik Sekali` | Data diperbarui di database dan tercermin di daftar prodi. |
| TC-PR-05 | Hapus prodi berelasi | Hapus prodi yang memiliki alumni terdaftar | Sistem menampilkan konfirmasi/peringatan relasi data. |
| TC-PR-06 | Dropdown di form alumni | Membuka `tambah.php` atau `edit.php` | Pilihan prodi tampil terurut abjad sesuai master prodi yang aktif. |

---

## 8. Langkah Penerapan Selanjutnya

Ketika siap melanjutkan implementasi teknis:
1. Jalankan migrasi SQL pada database MySQL menggunakan file [`database/schema_master_prodi.sql`](file:///c:/Users/ASUS/Downloads/pendataan-alumni-docs/pendataan-alumni/database/schema_master_prodi.sql).
2. Tambahkan helper functions prodi di [`includes/functions.php`](file:///c:/Users/ASUS/Downloads/pendataan-alumni-docs/pendataan-alumni/includes/functions.php).
3. Buat file views & controller: `prodi.php`, `tambah_prodi.php`, `proses_tambah_prodi.php`, `edit_prodi.php`, `proses_edit_prodi.php`, dan `hapus_prodi.php`.
4. Perbarui [`includes/sidebar.php`](file:///c:/Users/ASUS/Downloads/pendataan-alumni-docs/pendataan-alumni/includes/sidebar.php) untuk menu navigasi admin.
5. Perbarui [`includes/form_alumni.php`](file:///c:/Users/ASUS/Downloads/pendataan-alumni-docs/pendataan-alumni/includes/form_alumni.php) dengan `<select>` dinamis.

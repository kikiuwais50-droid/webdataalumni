# Database

- Database: `db_alumni`
- Tabel: `alumni` (satu-satunya)
- Relasi: **tidak ada** (RPD §L)
- Engine/charset yang disarankan: InnoDB, `utf8mb4`

## Schema

Identik dengan RPD §M (tambahan hanya engine & charset).

```sql
CREATE DATABASE IF NOT EXISTS db_alumni
  CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE db_alumni;

CREATE TABLE alumni (
  id_alumni     INT AUTO_INCREMENT PRIMARY KEY,
  nisn          VARCHAR(20)  NOT NULL,
  nama_lengkap  VARCHAR(100) NOT NULL,
  jenis_kelamin VARCHAR(20)  NOT NULL,
  tempat_lahir  VARCHAR(100),
  tanggal_lahir DATE,
  tahun_lulus   INT          NOT NULL,
  jurusan       VARCHAR(100),
  alamat        TEXT,
  no_hp         VARCHAR(20),
  pekerjaan     VARCHAR(100),
  status        VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Kamus field

| # | Field | Tipe | Wajib | Aturan / nilai |
|---|---|---|---|---|
| 1 | `id_alumni` | INT AI PK | auto | Tidak diinput user |
| 2 | `nisn` | VARCHAR(20) | ✅ | Tidak kosong; disarankan hanya digit, maks 20 |
| 3 | `nama_lengkap` | VARCHAR(100) | ✅ | Tidak kosong, maks 100 |
| 4 | `jenis_kelamin` | VARCHAR(20) | ✅ | `Laki-laki` atau `Perempuan` |
| 5 | `tempat_lahir` | VARCHAR(100) | – | Opsional |
| 6 | `tanggal_lahir` | DATE | – | Format `YYYY-MM-DD`; kosong → `NULL` |
| 7 | `tahun_lulus` | INT | ✅ | 4 digit angka, rentang 1950 s.d. tahun berjalan + 1 |
| 8 | `jurusan` | VARCHAR(100) | – | Opsional (contoh: RPL, TKJ) |
| 9 | `alamat` | TEXT | – | Opsional |
| 10 | `no_hp` | VARCHAR(20) | – | Bila diisi: hanya digit, spasi, `+`, `-`, `(`, `)` |
| 11 | `pekerjaan` | VARCHAR(100) | – | Opsional |
| 12 | `status` | VARCHAR(50) | – | `Bekerja` / `Kuliah` / `Wirausaha` / `Lainnya` |

Catatan: field opsional kosong disimpan sebagai `NULL` (bukan string kosong), terutama `tanggal_lahir`.

## Nilai enumerasi (satu sumber, di `functions.php`)

```php
const JENIS_KELAMIN = ['Laki-laki', 'Perempuan'];
const STATUS_ALUMNI = ['Bekerja', 'Kuliah', 'Wirausaha', 'Lainnya'];
```

## Query standar

```sql
-- Read (daftar)
SELECT id_alumni, nisn, nama_lengkap, jenis_kelamin, tahun_lulus, jurusan, pekerjaan, status
FROM alumni ORDER BY id_alumni DESC;

-- Search (satu keyword, kolom dicocokkan dengan LIKE)
SELECT ... FROM alumni
WHERE nisn LIKE ? OR nama_lengkap LIKE ? OR jurusan LIKE ?
   OR pekerjaan LIKE ? OR status LIKE ? OR CAST(tahun_lulus AS CHAR) LIKE ?
ORDER BY id_alumni DESC;          -- param: "%kata%" × 6

-- Detail untuk edit
SELECT * FROM alumni WHERE id_alumni = ?;

-- Create
INSERT INTO alumni (nisn, nama_lengkap, jenis_kelamin, tempat_lahir, tanggal_lahir,
                    tahun_lulus, jurusan, alamat, no_hp, pekerjaan, status)
VALUES (?,?,?,?,?,?,?,?,?,?,?);

-- Update
UPDATE alumni SET nisn=?, nama_lengkap=?, jenis_kelamin=?, tempat_lahir=?, tanggal_lahir=?,
  tahun_lulus=?, jurusan=?, alamat=?, no_hp=?, pekerjaan=?, status=?
WHERE id_alumni = ?;

-- Delete
DELETE FROM alumni WHERE id_alumni = ?;
```

Semua dijalankan via prepared statement `mysqli` (lihat `coding-rules.md`).

## Data contoh (`database/db_alumni.sql`, sesuai RPD §Q)

```sql
INSERT INTO alumni (nisn, nama_lengkap, jenis_kelamin, tahun_lulus, jurusan, pekerjaan, status) VALUES
('1234567890', 'Contoh Alumni',   'Laki-laki', 2025, 'RPL', 'Teknisi',   'Bekerja'),
('1234567891', 'Contoh Alumni 2', 'Perempuan', 2025, 'TKJ', 'Mahasiswa', 'Kuliah');
```

## Catatan / usulan (di luar RPD — butuh konfirmasi)

- RPD tidak mendefinisikan `UNIQUE` pada `nisn`, padahal masalah "duplikasi data" disebut di §C. Lihat ADR-009 (cek NISN ganda di level aplikasi).
- Tidak ada kolom `created_at`/`updated_at` karena tidak ada di RPD.

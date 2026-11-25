-- Database: db_alumni
-- Sistem Pendataan Alumni

CREATE DATABASE IF NOT EXISTS db_alumni
  CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE db_alumni;

-- 1. Tabel Master Program Studi (Prodi)
CREATE TABLE IF NOT EXISTS prodi (
  id_prodi      INT AUTO_INCREMENT PRIMARY KEY,
  kode_prodi    VARCHAR(20)  NOT NULL UNIQUE,
  nama_prodi    VARCHAR(100) NOT NULL,
  fakultas      VARCHAR(100) NOT NULL,
  jenjang       ENUM('D3', 'D4', 'S1', 'S2', 'SMK') NOT NULL DEFAULT 'S1',
  akreditasi    ENUM('Unggul', 'Baik Sekali', 'Baik', 'A', 'B', 'C', 'Belum Terakreditasi') NOT NULL DEFAULT 'Baik',
  status_aktif  TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '1 = Aktif, 0 = Nonaktif',
  created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_kode_prodi (kode_prodi),
  INDEX idx_status_aktif (status_aktif)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. Tabel Alumni
CREATE TABLE IF NOT EXISTS alumni (
  id_alumni     INT AUTO_INCREMENT PRIMARY KEY,
  nim           VARCHAR(20)  NOT NULL,
  nama_lengkap  VARCHAR(100) NOT NULL,
  jenis_kelamin VARCHAR(20)  NOT NULL,
  tempat_lahir  VARCHAR(100),
  tanggal_lahir DATE,
  tahun_lulus   INT          NOT NULL,
  id_prodi      INT DEFAULT NULL,
  prodi         VARCHAR(100),
  alamat        TEXT,
  no_hp         VARCHAR(20),
  email         VARCHAR(100) DEFAULT NULL,
  foto          VARCHAR(255) DEFAULT NULL,
  FOREIGN KEY (id_prodi) REFERENCES prodi(id_prodi) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3. Tabel Users
CREATE TABLE IF NOT EXISTS users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  username      VARCHAR(50)  NOT NULL UNIQUE,
  password      VARCHAR(255) NOT NULL,
  nama          VARCHAR(100) NOT NULL,
  role          ENUM('admin', 'alumni') NOT NULL DEFAULT 'alumni',
  foto          VARCHAR(255) DEFAULT NULL,
  id_alumni     INT DEFAULT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_alumni) REFERENCES alumni(id_alumni) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data Awal Program Studi
INSERT INTO prodi (kode_prodi, nama_prodi, fakultas, jenjang, akreditasi, status_aktif) VALUES
('RPL',  'Rekayasa Perangkat Lunak', 'Fakultas Ilmu Komputer & Rekayasa', 'S1', 'Unggul', 1),
('TI',   'Teknik Informatika',       'Fakultas Ilmu Komputer & Rekayasa', 'S1', 'Unggul', 1),
('SI',   'Sistem Informasi',         'Fakultas Ilmu Komputer & Rekayasa', 'S1', 'Baik Sekali', 1),
('TKJ',  'Teknik Komputer & Jaringan', 'Fakultas Teknik Komputer',        'D4', 'Baik Sekali', 1),
('BD',   'Bisnis Digital',           'Fakultas Ekonomi & Bisnis',         'S1', 'Baik', 1),
('MI',   'Manajemen Informatika',    'Fakultas Ilmu Komputer & Rekayasa', 'D3', 'Baik', 1)
ON DUPLICATE KEY UPDATE id_prodi=id_prodi;

-- Data Awal / Contoh Alumni
INSERT INTO alumni (nim, nama_lengkap, jenis_kelamin, tahun_lulus, id_prodi, prodi) VALUES
('1234567890', 'Contoh Alumni',   'Laki-laki', 2025, 1, 'Rekayasa Perangkat Lunak'),
('1234567891', 'Contoh Alumni 2', 'Perempuan', 2025, 4, 'Teknik Komputer & Jaringan');

-- Akun Super Admin default: username 'admin', password 'admin123'
INSERT INTO users (username, password, nama, role) VALUES
('admin', '$2y$10$3rgdnG4WmuF5XP4rrBfZ8.QCPUEX9fah1dEpH3pOV6re02Jrdnh/y', 'Super Admin', 'admin')
ON DUPLICATE KEY UPDATE id=id;

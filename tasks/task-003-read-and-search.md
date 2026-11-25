# Task 003 — Tampilkan Data & Pencarian (Read + Search)

**Tujuan:** Halaman Data Alumni dengan tabel dan pencarian.
**Dependensi:** 002
**Referensi:** RPD §I.1, §I.5, §Q, §S · `routes-spec.md` #1 · `workflow.md` W1, W5 · `ui-design.md` Halaman 1 · ADR-008

## Lingkup
`index.php` saja (tombol Tambah/Edit/Hapus hanya berupa tautan/tombol menuju task 004–006).

## Langkah
1. Ambil `$q = trim($_GET['q'] ?? '')`.
2. Bila `$q === ''`: `SELECT` kolom tabel `ORDER BY id_alumni DESC` (prepared/`query` tanpa input user boleh).
3. Bila `$q !== ''`: prepared statement dengan 6 kondisi `LIKE` (lihat `database.md`), bind `"%$q%"` ×6.
4. Render card: judul, tombol **Tambah Alumni**, form cari (`GET`, `name="q"`, value `e($q)`, tombol Cari & Reset), `render_flash()`.
5. Render tabel 9 kolom sesuai RPD §Q; JK → `L`/`P`; Status → badge berwarna; kolom Aksi: **Edit** (`edit.php?id=`) & **Hapus** (membuka modal dengan `data-id`/`data-nama`).
6. Kondisi kosong: pesan "Belum ada data alumni." atau "Data alumni tidak ditemukan." sesuai ada/tidaknya `q`.
7. Semua nilai di-escape dengan `e()`.

## Acceptance Criteria
- [ ] Dua data contoh tampil di tabel dengan 9 kolom benar.
- [ ] Pencarian "RPL", "Contoh", "2025", "Kuliah" mengembalikan baris yang sesuai.
- [ ] Kata kunci tetap terisi di kolom pencarian setelah dicari; Reset menampilkan semua.
- [ ] Pencarian tanpa hasil menampilkan pesan yang tepat.
- [ ] Input `' OR '1'='1` dan `<script>` tidak menyebabkan error SQL/XSS.
- [ ] Tabel dapat di-scroll horizontal di layar sempit.
- [ ] Skenario uji #1 dan #6 lulus.

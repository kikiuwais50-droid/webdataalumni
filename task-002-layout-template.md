# Task 002 — Layout Template & Helper Bersama

**Tujuan:** Membuat kerangka tampilan SB Admin 2 yang dipakai semua halaman, plus helper inti (escape, flash, enum).
**Dependensi:** 001
**Referensi:** RPD §A.4, §O, §P · `ui-design.md` (Layout global) · `coding-rules.md`

## Lingkup
- `includes/header.php`, `sidebar.php`, `footer.php`, `functions.php`.
- Helper: `e()`, `flash()` (set), `render_flash()` (tampil & hapus), `redirect($url)`, konstanta `JENIS_KELAMIN`, `STATUS_ALUMNI`.
- Modal konfirmasi hapus (markup di `footer.php`) dan `assets/js/app.js`.

## Langkah
1. `functions.php`: `session_start()` (bila belum aktif), definisikan helper & konstanta di atas. `redirect()` memanggil `header('Location: …')` lalu `exit`.
2. `header.php`: `<head>` (meta viewport, judul dinamis lewat `$page_title`, CSS lokal), buka `#wrapper`, `include sidebar.php`, buka `#content-wrapper`, topbar sederhana.
3. `sidebar.php`: brand "Sistem Pendataan Alumni", **satu** item "Data Alumni" (aktif untuk `index/tambah/edit`).
4. `footer.php`: footer teks, tutup wrapper, script jQuery → Bootstrap → sb-admin-2 → `app.js`, markup modal hapus.
5. `app.js`: saat modal `show.bs.modal`, isi nama & hidden `id_alumni` dari `data-*` tombol pemicu.
6. Hapus elemen template yang tak dipakai (user dropdown, notifikasi, search topbar, logout modal).
7. Uji dengan halaman percobaan yang memanggil `render_flash()`.

## Acceptance Criteria
- [ ] Layout SB Admin 2 tampil benar (sidebar, topbar, footer) di desktop dan mobile (sidebar collapse).
- [ ] Sidebar hanya memiliki satu menu: Data Alumni.
- [ ] Tidak ada elemen login/user/logout/notifikasi.
- [ ] `flash('success','x')` + redirect menampilkan alert hijau **sekali** saja.
- [ ] `e(null)` mengembalikan string kosong; `e('<b>')` menghasilkan `&lt;b&gt;`.
- [ ] Tidak ada warning "headers already sent".

## Di luar lingkup
Query database, form, tabel.

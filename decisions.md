# Decisions (ADR)

Format: Konteks → Keputusan → Alasan → Konsekuensi. Status: **Diterima** (sesuai RPD) atau **Diusulkan** (di luar RPD, butuh konfirmasi).

---

## ADR-001 — PHP native tanpa framework
**Status:** Diterima
- **Konteks:** RPD §H menetapkan HTML, CSS, PHP, JavaScript di atas XAMPP; proyek bertujuan latihan CRUD.
- **Keputusan:** PHP prosedural, tanpa Laravel/Composer/build step.
- **Alasan:** Sesuai RPD, mudah dijalankan di XAMPP, mudah dipahami siswa.
- **Konsekuensi:** Validasi, flash, dan layout ditulis manual di `includes/`.

## ADR-002 — Tanpa login dan satu menu
**Status:** Diterima
- **Konteks:** RPD §A.7, §A.8, §G, §Y.8.
- **Keputusan:** Tidak ada autentikasi; sidebar hanya "Data Alumni".
- **Alasan:** Menjaga kesederhanaan; login ditandai sebagai pengembangan lanjutan.
- **Konsekuensi:** Siapa pun yang dapat mengakses URL dapat mengubah data → sistem dimaksudkan untuk jaringan lokal/demonstrasi. Session hanya untuk flash message.

## ADR-003 — Folder `includes/` ditambahkan di luar RPD §R
**Status:** Diusulkan
- **Konteks:** Struktur RPD hanya berisi file halaman + `assets/` + `database/`. Layout SB Admin 2 (sidebar, topbar, footer) terlalu panjang untuk diduplikasi di 3 halaman.
- **Keputusan:** Tambah `includes/header.php`, `sidebar.php`, `footer.php`, `functions.php`.
- **Alasan:** Menghindari duplikasi; tetap selaras dengan nonfungsional "struktur folder rapi dan mudah dikembangkan" (§J).
- **Konsekuensi:** Struktur sedikit menyimpang dari RPD; semua file RPD asli tetap ada dengan nama yang sama.

## ADR-004 — `mysqli` dengan prepared statement
**Status:** Diterima (arah), implementasi diusulkan
- **Konteks:** RPD §T mewajibkan pemrosesan input aman terhadap SQL Injection tetapi tidak menyebut library.
- **Keputusan:** `mysqli` + prepared statement (`bind_param`).
- **Alasan:** Bawaan XAMPP, paling umum dipelajari di SMK, cukup untuk kebutuhan.
- **Alternatif:** PDO (lebih portabel, tidak dipilih agar sederhana).
- **Konsekuensi:** Dilarang menggabungkan input ke string SQL.

## ADR-005 — Hapus via POST + modal konfirmasi
**Status:** Diterima (konfirmasi dari RPD §O/§T), metode diusulkan
- **Konteks:** RPD mewajibkan konfirmasi sebelum hapus; file `hapus.php` ada di struktur.
- **Keputusan:** Tombol Hapus membuka modal; konfirmasi mengirim POST ke `hapus.php`.
- **Alasan:** Link GET `hapus.php?id=` dapat terpicu tak sengaja (prefetch, crawler); POST lebih aman.
- **Konsekuensi:** Perlu form tersembunyi + JS kecil di `app.js`.

## ADR-006 — Pola Post-Redirect-Get + flash message
**Status:** Diusulkan
- **Konteks:** RPD §N menyebut "sistem menampilkan data terbaru" setelah proses.
- **Keputusan:** Skrip proses selalu redirect ke halaman tampilan; pesan lewat `$_SESSION['flash']`.
- **Alasan:** Mencegah submit ganda saat refresh (relevan dengan skenario uji 7).
- **Konsekuensi:** Wajib `session_start()`; session tidak dipakai untuk hal lain.

## ADR-007 — Validasi ganda (server wajib, klien opsional)
**Status:** Diterima
- **Konteks:** RPD §I.6, §T.
- **Keputusan:** Validasi utama di PHP (`validate_alumni`); atribut HTML5 (`required`, `maxlength`, `type`) sebagai bantuan UX.
- **Alasan:** Validasi klien mudah dilewati.
- **Konsekuensi:** Aturan didefinisikan sekali di server; pesan error per field.

## ADR-008 — Pencarian satu kolom input, banyak kolom `LIKE`
**Status:** Diterima (fitur), cakupan kolom diusulkan
- **Konteks:** RPD §I.5 "berdasarkan data yang tersedia"; §S "SELECT dengan pencarian".
- **Keputusan:** Satu input `q`; cocokkan ke `nisn`, `nama_lengkap`, `jurusan`, `pekerjaan`, `status`, `tahun_lulus`.
- **Alasan:** Sederhana, memenuhi "mudah dicari". Filter terpisah ditunda (§W).
- **Konsekuensi:** `LIKE '%…%'` tidak memakai index — dapat diterima untuk skala sekolah.

## ADR-009 — Cek NISN ganda di level aplikasi
**Status:** Diusulkan (di luar RPD)
- **Konteks:** RPD §C menyebut masalah duplikasi, tetapi schema §M tidak memiliki `UNIQUE` pada `nisn`.
- **Keputusan (usulan):** Sebelum INSERT/UPDATE, cek `SELECT 1 FROM alumni WHERE nisn=? AND id_alumni<>?`; bila ada, tolak dengan error "NISN sudah terdaftar." Schema tetap sesuai RPD.
- **Alasan:** Menjawab masalah duplikasi tanpa mengubah schema resmi.
- **Alternatif:** `UNIQUE KEY` di DB (lebih kuat, tetapi mengubah schema RPD).
- **Konsekuensi:** Bila tidak disetujui, hapus aturan ini dari task-007.

## ADR-010 — Aset lokal, tanpa CDN
**Status:** Diusulkan
- **Konteks:** Dijalankan di lab/sekolah yang internetnya tidak pasti; RPD §R menyediakan `assets/vendor/`.
- **Keputusan:** Seluruh CSS/JS/font (SB Admin 2, Bootstrap, jQuery, Font Awesome) disimpan lokal di `assets/`.
- **Alasan:** Berjalan offline.
- **Konsekuensi:** Ukuran repo lebih besar; versi aset dikunci.

## ADR-011 — Nilai kosong disimpan sebagai NULL
**Status:** Diusulkan
- **Konteks:** `tanggal_lahir` bertipe DATE; string kosong menyebabkan error/`0000-00-00` pada mode strict.
- **Keputusan:** Semua field opsional kosong → `NULL`.
- **Konsekuensi:** Tampilan memakai `e($v)` yang menangani `NULL` menjadi string kosong atau "-".

## ADR-012 — Master Data Program Studi (Prodi)
**Status:** Diterima
- **Konteks:** Program studi sebelumnya diinput manual sebagai teks bebas di tabel `alumni`, menyebabkan inkonsistensi penamaan dan ketiadaan metadata akademik.
- **Keputusan:** Membuat tabel master `prodi` yang menyimpan `kode_prodi` (UNIQUE), `nama_prodi`, `fakultas`, `jenjang` (D3/D4/S1/S2/SMK), `akreditasi`, dan `status_aktif`. Tabel `alumni` dihubungkan via Foreign Key `id_prodi` opsional (`NULL` diizinkan dengan `ON DELETE SET NULL`) untuk menjaga kompatibilitas mundur.
- **Alasan:** Menstandarkan data program studi, mempermudah pelaporan, dan menjaga integritas referensial data alumni.
- **Konsekuensi:** Penambahan modul CRUD Master Prodi untuk Admin dan penyesuaian dropdown di form alumni.



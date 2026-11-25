# Task 006 — Hapus Alumni (Delete)

**Tujuan:** Admin dapat menghapus data alumni setelah konfirmasi.
**Dependensi:** 003 (tombol Hapus & modal dari task 002/003)
**Referensi:** RPD §I.4, §O, §P, §T · `routes-spec.md` #6 · `workflow.md` W4 · ADR-005

## Lingkup
`hapus.php` dan perilaku modal konfirmasi.

## Langkah
1. Pastikan modal di `footer.php` berisi form `method="post" action="hapus.php"` dengan hidden `id_alumni`, tombol **Batal** (`data-dismiss`) dan **Ya, Hapus**.
2. `app.js`: saat tombol Hapus diklik, isi nama alumni (via `.text()`, bukan `.html()`) dan nilai `id_alumni` pada modal.
3. `hapus.php`:
   a. Hanya terima POST; selain itu flash `danger` "Permintaan tidak valid." + redirect.
   b. Validasi `id_alumni` integer > 0.
   c. `DELETE FROM alumni WHERE id_alumni = ?` (prepared); cek `affected_rows`.
   d. Redirect `index.php` dengan flash sesuai hasil (lihat `routes-spec.md`).

## Acceptance Criteria
- [ ] Klik Hapus selalu memunculkan modal berisi nama alumni yang benar.
- [ ] **Batal**/tutup modal tidak menghapus apa pun.
- [ ] **Ya, Hapus** menghapus baris dan menampilkan flash sukses.
- [ ] `hapus.php?id=1` lewat GET **tidak** menghapus.
- [ ] Nama beralamat/berkarakter khusus (mis. `<b>x</b>`) tampil aman di modal.
- [ ] Menghapus ID yang sudah tidak ada menampilkan pesan "tidak ditemukan".
- [ ] Skenario uji #5 lulus.

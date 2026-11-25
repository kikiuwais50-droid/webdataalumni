# Task 005 — Edit Alumni (Update)

**Tujuan:** Admin dapat memperbarui data alumni yang sudah ada.
**Dependensi:** 004 (memakai partial form yang sama)
**Referensi:** RPD §I.3, §P, §S · `routes-spec.md` #4, #5 · `workflow.md` W3

## Lingkup
`edit.php`, `proses_edit.php`.

## Langkah
1. `edit.php`: validasi `id` (`filter_var` int > 0). Ambil data via prepared `SELECT`. Tidak ditemukan → flash `danger` + redirect `index.php`.
2. Nilai awal form = `old` dari session bila ada (setelah validasi gagal), selain itu data DB. Tambahkan `<input type="hidden" name="id_alumni">`.
3. `proses_edit.php`:
   a. Tolak non-POST; validasi `id_alumni`.
   b. Validasi field (sama dengan tambah). Gagal → simpan `errors`+`old`, redirect `edit.php?id=N`.
   c. `UPDATE … WHERE id_alumni = ?` (prepared).
   d. Sukses → flash "Data alumni berhasil diperbarui." + redirect `index.php`.
4. Pastikan tombol **Edit** di tabel menuju `edit.php?id=…`.

## Acceptance Criteria
- [ ] Form edit menampilkan data lama dengan benar (termasuk radio JK, select status, tanggal).
- [ ] Perubahan tersimpan dan terlihat di tabel; flash sukses muncul.
- [ ] Mengosongkan field opsional menyimpan `NULL`.
- [ ] `edit.php?id=abc` dan `edit.php?id=99999` → redirect dengan pesan, tanpa error PHP.
- [ ] Error validasi kembali ke form edit dengan isian lama dan ID yang sama.
- [ ] Skenario uji #4 lulus.

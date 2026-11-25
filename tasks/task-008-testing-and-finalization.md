# Task 008 — Pengujian, Polish & Finalisasi

**Tujuan:** Memverifikasi seluruh sistem terhadap RPD, merapikan tampilan, dan melengkapi deliverable.
**Dependensi:** 001–007
**Referensi:** RPD §U, §V, §Y · `testing.md` · `deployment.md`

## Lingkup
Uji end-to-end, perbaikan akhir, dan kelengkapan produk (RPD §Y).

## Langkah
1. Jalankan seluruh skenario di `testing.md` bagian A, B, C; catat hasil pada format laporan uji (bagian E).
2. Jalankan checklist manual bagian D di Chrome, Edge, Firefox dan 3 lebar layar (360/768/1366px).
3. Polish UI: konsistensi judul halaman (`$page_title`), badge status, spacing card, teks pesan, favicon/judul tab.
4. Bersihkan: hapus file/aset template yang tak terpakai, komentar debug, `var_dump`, data uji liar.
5. Pastikan `database/db_alumni.sql` bersih (schema + 2 data contoh) dan berhasil di-import dari nol sesuai `deployment.md`.
6. Verifikasi daftar produk akhir RPD §Y:

   | Produk | Terpenuhi |
   |---|---|
   | Website Sistem Pendataan Alumni | ☐ |
   | Database MySQL | ☐ |
   | CRUD Alumni | ☐ |
   | Template SB Admin 2 | ☐ |
   | Pencarian Data | ☐ |
   | Validasi Form | ☐ |
   | Dokumentasi RPD | ☐ |
   | Login — **tidak ada** (sengaja) | ☐ |

7. Tinjau `decisions.md`: ubah status ADR "Diusulkan" menjadi "Diterima"/"Ditolak" sesuai keputusan akhir.

## Acceptance Criteria
- [ ] 7 skenario uji RPD lulus semuanya (skenario #7: tidak ada insert ganda saat refresh).
- [ ] Tidak ada notice/warning PHP maupun error di console browser.
- [ ] Instalasi dari nol mengikuti `deployment.md` berhasil.
- [ ] Seluruh item produk akhir RPD §Y terpenuhi; tidak ada fitur di luar scope (login, ekspor, foto, filter, statistik).
- [ ] Semua ADR memiliki status final.

## Definition of Done
Sistem siap didemonstrasikan: admin dapat melihat, menambah, mengubah, menghapus, dan mencari data alumni dari satu menu Data Alumni (RPD §V).

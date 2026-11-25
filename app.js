/**
 * Sistem Pendataan Alumni
 * Script client-side untuk interaksi antarmuka dan modal konfirmasi hapus
 */
$(document).ready(function () {
    // Handler Modal Konfirmasi Hapus Data Alumni
    $('#deleteModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var id = button.data('id');
        var nama = button.data('nama');

        var modal = $(this);
        modal.find('#deleteAlumniId').val(id);
        // Gunakan .text() untuk pengisian nama yang aman terhadap potensi XSS
        modal.find('#deleteAlumniName').text('"' + (nama || 'ini') + '"');
    });
});

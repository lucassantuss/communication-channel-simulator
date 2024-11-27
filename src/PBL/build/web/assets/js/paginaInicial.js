$(document).ready(function () {
    $('#tipo_canal').on('change', function () {
        var selectedOption = this.value;

        $('#passa_baixas_content').hide();
        $('#passa_faixas_content').hide();

        if (selectedOption === 'passa_baixas') {
            $('#passa_baixas_content').show();
        } else if (selectedOption === 'passa_faixas') {
            $('#passa_faixas_content').show();
        }
    });
});
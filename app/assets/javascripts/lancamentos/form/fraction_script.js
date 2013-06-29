$(document).ready(function () {

    var freqRepeticoes = $("#frequencia_agendamentos");
    var freqParcelas = $("#frequencia_parcelas");

    var numeroRepeticoes = $("#numero_agendamentos");
    var numeroParcelas = $("#numero_parcelas");

    $("#frequencia_agendamentos_hidden").val(freqRepeticoes.val());
    $("#frequencia_parcelas_hidden").val(freqParcelas.val());

    $("#numero_agendamentos_hidden").val(numeroRepeticoes.val());
    $("#numero_parcelas_hidden").val(numeroParcelas.val());

    numeroParcelas.blur(function () {
/// Calculo da parcela
        var dataVencimento = $("#datepicker").val();
        var valorParcelas = $.fn.autoNumeric.Strip('lancamento_valor');
        var agendamentoBox = $("#numero_agendamentos");
        var agendamentoFreq = $("#frequencia_agendamentos");
        if (numeroParcelas.val() > 0) {
            var matematics = Math;
            $("#total_parcela").text(matematics.abs(valorParcelas) / numeroParcelas.val());


            if (numeroParcelas.val() > 1) {
                numeroRepeticoes.prop('disabled', true);
                freqRepeticoes.select2('disable');

                numeroParcelas.prop('disabled', false);
                freqParcelas.select2('enable');
            }
            else {
                numeroRepeticoes.prop('disabled', false);
                freqRepeticoes.select2('enable');

                numeroParcelas.prop('disabled', false);
                freqParcelas.select2('enable');
            }

            $("#numero_agendamentos_hidden").val(numeroRepeticoes.val());
            $("#frequencia_agendamentos_hidden").val(freqRepeticoes.val());

            $("#numero_parcelas_hidden").val(numeroParcelas.val());
            $("#frequencia_parcelas_hidden").val(freqParcelas.val());
        }

    });
    freqParcelas.change(function () {
        $("#frequencia_agendamentos_hidden").val(freqRepeticoes.val());
        $("#numero_agendamentos_hidden").val(numeroRepeticoes.val());
        $("#frequencia_parcelas_hidden").val(freqParcelas.val());
        $("#numero_parcelas_hidden").val(numeroParcelas.val());
    });

    numeroParcelas.keydown(function (event) {
        // Allow: backspace, delete, tab, escape, and enter
        if (event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 || event.keyCode == 13 ||
            // Allow: Ctrl+A
            (event.keyCode == 65 && event.ctrlKey === true) ||
            // Allow: home, end, left, right
            (event.keyCode >= 35 && event.keyCode <= 39)) {
            // let it happen, don't do anything
            return;
        }
        else {
            // Ensure that it is a number and stop the keypress
            if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
                event.preventDefault();
            }
        }
    });
});

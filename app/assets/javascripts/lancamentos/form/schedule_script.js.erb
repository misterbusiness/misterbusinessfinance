$(document).ready(function () {

    var freqRepeticoes = $("#frequencia_agendamentos");
    var freqParcelas = $("#frequencia_parcelas");

    var numeroRepeticoes = $("#numero_agendamentos");
    var numeroParcelas = $("#numero_parcelas");

    $("#frequencia_agendamentos_hidden").val(freqRepeticoes.val());
    $("#frequencia_parcelas_hidden").val(freqParcelas.val());

    $("#numero_agendamentos_hidden").val(numeroRepeticoes.val());
    $("#numero_parcelas_hidden").val(numeroParcelas.val());

    numeroRepeticoes.blur(function () {
        var dataVencimento = $("#data_vencimento_picker").datepicker('getDate');
        var numeroRepeticoes = $("#numero_agendamentos");
        var freqRepeticoes = $("#frequencia_agendamentos");
        var numeroParcelas = $("#numero_parcelas");
        var freqParcelas = $("#frequencia_parcelas");
        var valorRepeticao = $.fn.autoNumeric.Strip('lancamento_valor');

        $("#total_agendamento").text(dataVencimento);
//        var selectedDate = new Date((new Date).getFullYear(), (new Date).getMonth(), response.diavencimento);
        /*           if (dataVencimento != null) {
         switch (freqRepeticoes) {
         case 'Semanal':
         {
         dataRepeticao = new Date((dataVencimento).getFullYear(), (dataVencimento).getMonth(), (dataVencimento).getDay() + 7);
         break;
         }
         case 'Mensal':
         {
         dataRepeticao = new Date((dataVencimento).getFullYear(), (dataVencimento).getMonth() + 1, (dataVencimento).getDay());
         break;
         }
         case 'Semestral':
         {
         dataRepeticao = new Date((dataVencimento).getFullYear(), (dataVencimento).getMonth() + 6, (dataVencimento).getDay());
         break;
         }
         case 'Anual':
         {
         dataRepeticao = new Date((dataVencimento).getFullYear() + 1, (dataVencimento).getMonth(), (dataVencimento).getDay());
         break;
         }
         default :
         {
         dataRepeticao = new Date((dataVencimento).getFullYear(), (dataVencimento).getMonth(), (dataVencimento).getDay());
         break;
         }
         }
         }
         $("#total_agendamento").text(dataRepeticao);*/

        if (numeroRepeticoes.val() > 1) {
            numeroParcelas.prop('disabled', true);
            freqParcelas.select2('disable');

            numeroRepeticoes.prop('disabled', false);
            freqRepeticoes.select2('enable');
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
    });

    freqRepeticoes.change(function () {

        $("#frequencia_agendamentos_hidden").val(freqRepeticoes.val());
        $("#numero_agendamentos_hidden").val(numeroRepeticoes.val());
        $("#frequencia_parcelas_hidden").val(freqParcelas.val());
        $("#numero_parcelas_hidden").val(numeroParcelas.val());
    });

    numeroRepeticoes.keydown(function (event) {
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

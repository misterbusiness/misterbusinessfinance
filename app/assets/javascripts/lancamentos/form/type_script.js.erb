$(document).ready(function(){
// Inicializa os tipos -> o valor padrão é receita
    var radio_receita = $('#lancamento_tipo_receita');
    var radio_despesa = $('#lancamento_tipo_despesa');
    var label_receita = $("#receita_label");
    var label_despesa = $("#despesa_label");
    radio_receita.prop("checked",true);

    label_receita.click(function(){
        radio_receita.prop("checked",true);
        label_receita.removeClass('label-default').addClass('label-success');
        label_despesa.removeClass('label-important').addClass('label-default');
    });

    label_despesa.click(function(){
        radio_despesa.prop("checked",true);
        label_despesa.removeClass('label-default').addClass('label-important');
        label_receita.removeClass('label-success').addClass('label-default');
    });
});

$(document).ready( function()
{
    $('#lancamento_valor').blur(function(){
        var valor = $.fn.autoNumeric.Strip('lancamento_valor');
        var valor_input = $('#lancamento_valor');
        var radio_receita = $('#lancamento_tipo_receita');
        var radio_despesa = $('#lancamento_tipo_despesa');
// Adicionados labels para fazer a troca de cores na seleção
        var label_receita = $("#receita_label");
        var label_despesa = $("#despesa_label");

        // Altera a indicação das parcelas
        var input_parcela = $("#total_parcela");
        var numero_parcelas = $("#numero_parcelas");
        if (numero_parcelas.val() < 2)
        {
            input_parcela.text(valor);
        }
        else
        {
            input_parcela.text(valor/numero_parcelas.val())
        }

        if (valor < 0)
        {
            radio_despesa.prop("checked",true);
            label_despesa.removeClass('label-default').addClass('label-important');
            label_receita.removeClass('label-success').addClass('label-default');
            valor_input.val($.fn.autoNumeric.Format('lancamento_valor', Math.abs(valor)));
        }
        if (radio_despesa.is(":checked") == false && radio_receita.is(":checked") == false )
        {
            radio_receita.prop("checked",true);
            label_receita.removeClass('label-default').addClass('label-success');
            label_despesa.removeClass('label-important').addClass('label-default');
        }
    });
});
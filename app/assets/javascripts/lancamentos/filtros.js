/**
 * Created with JetBrains RubyMine.
 * User: administrator
 * Date: 25/06/13
 * Time: 20:59
 * To change this template use File | Settings | File Templates.
 */
function buildfilter() {
    //alert("we are here!");
    var href = "/filter?"

    $('.filtro_parametro').each(function () {

        if (typeof($(this).data('valorparametro')) !== "undefined") {
        href += $(this).data('nomeparametro') + "=" + $(this).data('valorparametro') + "&"
        }
    }
    );

    $('#grid_results').html('Aguarde...');

    $.get(href, function (data)
                {
                    $('#grid_results').html(data);
                    insertPaginationEvent();
                }

        );

}

function insertPaginationEvent()
{

    $('.pagination a').click(function ()
    {
        $(this).data('nomeparametro','page');
        $(this).data('valorparametro',(RegExp('page=' + '(.+?)(&|$)').exec($(this).prop('href'))||[,null])[1]);
        $(this).addClass('filtro_parametro');
        buildfilter();
        return false;
    });



}

$(document).ready(function ()
    {
        $('#filtro_descricao').data('nomeparametro','descricao');
        $('#filtro_datavencimento').data('nomeparametro','datavencimento');
        $('#filtro_dataacao').data('nomeparametro','dataacao');
        $('#filtro_status').data('nomeparametro','status');
        $('#filtro_valor').data('nomeparametro','valor');
        $('#filtro_categoria').data('nomeparametro','categoria');
        $('#filtro_centrodecusto').data('nomeparametro','centrodecusto');
        $('#seletor_valor').data('nomeparametro','seletorvalor');
        $('#hiddenReceita').data('nomeparametro','receita');
        $('#hiddenDespesa').data('nomeparametro','despesa');
        $('#hiddenReceita').data('valorparametro','S');
        $('#hiddenDespesa').data('valorparametro','S');

        $('#botaoGrid').click
        (
            function()
            {
                $('.filtro_parametro').each
                (function()
                    {
                        $(this).removeData('valorparametro');
                        $(this).val('');
                    }
                );

                $('#hiddenReceita').data('valorparametro','S');
                $('#hiddenDespesa').data('valorparametro','S');
                $('#inputReceitas').prop('checked',true);
                $('#inputDespesas').prop('checked',true);
                buildfilter.call(this);
            }
        );

        $('#inputReceitas').click
        (
            function()
            {
                var receitasChecked;
                var despesasChecked;

                receitasChecked = $('#inputReceitas').is(':checked') ;
                despesasChecked = $('#inputDespesas').is(':checked')  ;

                if (receitasChecked)
                {
                    $('#hiddenReceita').data('valorparametro','S');
                    buildfilter();
                }
                else
                {
                    if (!despesasChecked)
                    {
                        //alert('Você precisa selecionar ao menos um tipo de valor.');
                        $('#inputReceitas').prop('checked',true);
                    }
                    else
                    {
                        $('#hiddenReceita').data('valorparametro','N');
                        buildfilter();
                    }

                }

            }
        );

        $('#inputDespesas').click
        (
            function()
            {
                var receitasChecked;
                var despesasChecked;

                receitasChecked = $('#inputReceitas').is(':checked') ;
                despesasChecked = $('#inputDespesas').is(':checked')  ;

                if (despesasChecked)
                {
                    $('#hiddenDespesa').data('valorparametro','S');
                    buildfilter();

                }
                else
                {
                    if (!receitasChecked)
                    {
                        //alert('Você precisa selecionar ao menos um tipo de valor.');
                        $('#inputDespesas').prop('checked',true);

                    }
                    else
                    {
                        $('#hiddenDespesa').data('valorparametro','N');
                        buildfilter();

                    }

                }

            }
        );

        $('.filtro_parametro').change(function()
            {
                if ($(this).prop('id') == 'filtro_valor')
                {
                    $('#seletor_valor').data('valorparametro',$('#seletor_valor').val());
                }

                if ($(this).prop('id') == 'seletor_valor')
                {
                    $('#filtro_valor').focus();
                }
                else
                {
                    if ($.trim($(this).val()) != "")
                    {
                        $(this).data('valorparametro', $.trim($(this).val()));
                    }
                    else
                    {
                        $(this).removeData('valorparametro');
                    }
                        buildfilter.call(this);
                }
            }
        )


});

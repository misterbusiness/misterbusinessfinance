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
        //execScript("/assets/paginate.js");
        //$.get(this.href, null, null, 'script');
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
        $('#botaoReceitas').data('nomeparametro','receitas');

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

                }
                else
                {
                    if (!despesasChecked)
                    {
                        //alert('Você precisa selecionar ao menos um tipo de valor.');
                        $('#inputReceitas').prop('checked',true);
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

                if (receitasChecked)
                {

                }
                else
                {
                    if (!receitasChecked)
                    {
                        //alert('Você precisa selecionar ao menos um tipo de valor.');
                        $('#inputDespesas').prop('checked',true);
                    }

                }

            }
        );

        $('.filtro_parametro').change(function()
            {
                $(this).data('valorparametro', $(this).val());
                buildfilter.call(this);
            }
        )


});

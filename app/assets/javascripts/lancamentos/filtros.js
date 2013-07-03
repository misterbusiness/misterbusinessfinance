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
					insertQuitarEstornarCancelarEvent();
                }

        );

}

function updateRowTable(id)
{
   //Essa função localiza pela row que contém o ID e obtém da base de dados o valor.
   //Obter o valor usando ajax

   //Obter os dados do banco utilizando JSON. Preciso criar um controller para isso, para retornar o meu JSON

   alert(id);
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

function insertQuitarEstornarCancelarEvent()
{
	$('.quitar_button').click(function()
	{
		td = $(this).parent();
		tr = td.parent();
		alert(tr.prop('id'));
	
	});

	$('.estornar_button').click(function()
	{
		td = $(this).parent();
		tr = td.parent();
		alert(tr.prop('id'));
		
	
	});
	
	$('.cancelar_button').click(function()
	{
		td = $(this).parent();
		tr = td.parent();
		alert(tr.prop('id'));
		
	
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
        $('#filtro_DataVencimentoDe').data('nomeparametro','datavencimentode');
        $('#filtro_DataVencimentoAte').data('nomeparametro','datavencimentoate');

        $('#seletor_valor').data('nomeparametro','seletorvalor');
        $('#hiddenReceita').data('nomeparametro','receita');
        $('#hiddenDespesa').data('nomeparametro','despesa');
        $('#hiddenReceita').data('valorparametro','S');
        $('#hiddenDespesa').data('valorparametro','S');

        $('#filtro_DataVencimentoDe').datepicker({
            format: 'dd-mm-yyyy',
            autoclose: true,
            todaybtn: true,
            showButtonPanel:true,
            changeMonth:true,
            changeYear:true
        });

        $('#filtro_DataVencimentoAte').datepicker({
            format: 'dd-mm-yyyy',
            autoclose: true,
            todaybtn: true,
            showButtonPanel:true,
            changeMonth:true,
            changeYear:true
        });




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
                    if ($.trim($('#filtro_valor').val()) == "")
                    {
                        $('#filtro_valor').focus();
                        return;
                    }
                }

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
        )


});

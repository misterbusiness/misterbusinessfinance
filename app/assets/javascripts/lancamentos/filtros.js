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

$.get(href, function (data) {$('#grid_results').html(data);});

//$.getScript("/assets/paginate.js");
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

        $('#botaoGrid').click(function()
        {
        $('.filtro_parametro').each(function ()
        {
        $(this).removeData('valorparametro');
        $(this).val('');
        }
);

buildfilter.call(this);


}
);

$('.filtro_parametro').change(function()
            {
                //alert('Teste?');
                $(this).data('valorparametro', $(this).val());
                buildfilter.call(this);
                }
)

$('#botaoReceitas').click(function()
                {
                    $(this).data('valorparametro','S');
                    buildfilter.call(this);
                    }
)

$('#botaoDespesas').click(function()
                {
                    $(this).data('valorparametro','S');
                    buildfilter.call(this);
                    }
)





});

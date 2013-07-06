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
    $.get(href, function (data) {
            $('#grid_results').html(data);
            insertPaginationEvent();
            insertQuitarEstornarCancelarEvent();
            insertOnClickResultEvent();
            $('#tableResults').dataTable({
                'aaSorting': [[2,'asc'] ]
                ,'bJQueryUI':true
                ,'oLanguage' :{
                    "sLengthMenu": "Exibir _MENU_ lançamentos por página",
                    "sZeroRecords": "Nenhum registro encontrado",
                    "sInfo": "Exibindo _START_ de _END_. Total: _TOTAL_ lançamentos.",
                    "sInfoEmpty": "Exibindo 0 de 0. Total: 0 lançamentos",
                    "sInfoFiltered": "(filtrado de um total de _MAX_ lançamentos)",
                    "sSearch": "Refinar busca:"
                }
            });
        }

    );

}

function insertOnClickResultEvent()
{

    $('.resultsRow').click(

        function () {

            if ($(this).hasClass("info"))
            {
                $(this).removeClass("info");
                //$("#lancamento_form").html("<%= escape_javascript(render(:partial => "form"))%>");

                // O ajax causa a "perda" do efeito autoNumeric, por isso o mesmo deve ser refreshed
                $("#lancamento_valor").autoNumeric();
                $("#lancamento_valor").blur();
            }
            else
            {
                $(this).addClass("info");
                //$.ajax({
                //    url: "<%= edit_lancamento_path(@current_lancamento) %>",
                //    data: {}
                //});
            }


        }
    );

}

function insertPaginationEventNotif(link) {

    $('.pagination a').click(

        function () {
            var pagenumber = (RegExp('page=' + '(.+?)(&|$)').exec($(this).prop('href')) || [, null])[1];
            link += '&page=' + pagenumber;
            notification_build_filter(link);
            return false;
        }
    );
}

function notification_build_filter(link) {
    var href = "/filter?"

    href += link

    $('#grid_results').html('Aguarde...');
    $.get(href, function (data) {
            $('#grid_results').html(data);
            insertPaginationEventNotif(link);
        }

    );

}

function updateRowTable(id) {
    //Essa função localiza pela row que contém o ID e obtém da base de dados o valor.
    //Obter o valor usando ajax

    //Obter os dados do banco utilizando JSON. Preciso criar um controller para isso, para retornar o meu JSON

    alert(id);
}

function insertPaginationEvent() {

    $('.pagination a').click(function () {
        $(this).data('nomeparametro', 'page');
        $(this).data('valorparametro', (RegExp('page=' + '(.+?)(&|$)').exec($(this).prop('href')) || [, null])[1]);
        $(this).addClass('filtro_parametro');
        buildfilter();
        return false;
    });


}


function buildDataTable()
{
  var tableData = new google.visualization.DataTable();

    /*data.addColumn('string', '');
    data.addColumn('string', 'Descrição');
    data.addColumn('string', 'Data de Vencimento');
    data.addColumn('string', 'Data da Ação');
    data.addColumn('number', 'Valor');
    data.addColumn('string', 'Categoria');
    data.addColumn('string', 'Centro de Custo');
    data.addColumn('string', 'Status');
    */

    $.getJSON('filter', function(data) {

        //tableData.addRows(data.rows);

        $.each(data,function(index,rows) {

            $.each(rows,function(key,value) {
               //alert(this);

            });


        });

    });

     /*
    data.addRows([
        ['','Teste', '123','123',502,'teste','teste','teste'],
        ['','Teste2', '123','123',502,'teste','teste','teste'],
        ['','Teste3', '123','123',502,'teste','teste','teste'],
        ['','Teste4', '123','123',502,'teste','teste','teste'],
        ['','Teste5', '123','123',502,'teste','teste','teste']
    ]);

       */
   var table = new google.visualization.Table(document.getElementById("table_div"));


   table.draw(tableData);
}


function insertQuitarEstornarCancelarEvent() {
    $('.quitar_button').click(function () {
        td = $(this).parent();
        tr = td.parent();
        alert(tr.prop('id'));

    });

    $('.estornar_button').click(function () {
        td = $(this).parent();
        tr = td.parent();
        alert(tr.prop('id'));


    });

    $('.cancelar_button').click(function () {
        td = $(this).parent();
        tr = td.parent();
        alert(tr.prop('id'));


    });


}

$(document).ready(function () {
    $('#filtro_descricao').data('nomeparametro', 'descricao');
    $('#filtro_datavencimento').data('nomeparametro', 'datavencimento');
    $('#filtro_dataacao').data('nomeparametro', 'dataacao');
    $('#filtro_status').data('nomeparametro', 'status');
    $('#filtro_valor').data('nomeparametro', 'valor');
    $('#filtro_categoria').data('nomeparametro', 'categoria');
    $('#filtro_centrodecusto').data('nomeparametro', 'centrodecusto');
    $('#filtro_DataVencimentoDe').data('nomeparametro', 'datavencimentode');
    $('#filtro_DataVencimentoAte').data('nomeparametro', 'datavencimentoate');

    $('#seletor_valor').data('nomeparametro', 'seletorvalor');
    $('#hiddenReceita').data('nomeparametro', 'receita');
    $('#hiddenDespesa').data('nomeparametro', 'despesa');
    $('#hiddenReceita').data('valorparametro', 'S');
    $('#hiddenDespesa').data('valorparametro', 'S');

    $('#filtro_DataVencimentoDe').datepicker({
        format: 'dd-mm-yyyy',
        autoclose: true,
        todaybtn: true,
        showButtonPanel: true,
        changeMonth: true,
        changeYear: true
    });

    buildDataTable();

    $('#filtro_DataVencimentoAte').datepicker({
        format: 'dd-mm-yyyy',
        autoclose: true,
        todaybtn: true,
        showButtonPanel: true,
        changeMonth: true,
        changeYear: true
    });


    $('#botaoGrid').click
    (
        function () {
            $('.filtro_parametro').each
            (function () {
                    $(this).removeData('valorparametro');
                    $(this).val('');
                }
            );

            $('#hiddenReceita').data('valorparametro', 'S');
            $('#hiddenDespesa').data('valorparametro', 'S');
            $('#inputReceitas').prop('checked', true);
            $('#inputDespesas').prop('checked', true);
            buildfilter.call(this);
        }
    );

    $('#inputReceitas').click
    (
        function () {
            var receitasChecked;
            var despesasChecked;

            receitasChecked = $('#inputReceitas').is(':checked');
            despesasChecked = $('#inputDespesas').is(':checked');

            if (receitasChecked) {
                $('#hiddenReceita').data('valorparametro', 'S');
                buildfilter();
            }
            else {
                if (!despesasChecked) {
                    //alert('Você precisa selecionar ao menos um tipo de valor.');
                    $('#inputReceitas').prop('checked', true);
                }
                else {
                    $('#hiddenReceita').data('valorparametro', 'N');
                    buildfilter();
                }

            }

        }
    );

    $('#inputDespesas').click
    (
        function () {
            var receitasChecked;
            var despesasChecked;

            receitasChecked = $('#inputReceitas').is(':checked');
            despesasChecked = $('#inputDespesas').is(':checked');

            if (despesasChecked) {
                $('#hiddenDespesa').data('valorparametro', 'S');
                buildfilter();

            }
            else {
                if (!receitasChecked) {
                    //alert('Você precisa selecionar ao menos um tipo de valor.');
                    $('#inputDespesas').prop('checked', true);

                }
                else {
                    $('#hiddenDespesa').data('valorparametro', 'N');
                    buildfilter();

                }

            }

        }
    );

    $('.filtro_parametro').change(function () {
            if ($(this).prop('id') == 'filtro_valor') {
                $('#seletor_valor').data('valorparametro', $('#seletor_valor').val());
            }

            if ($(this).prop('id') == 'seletor_valor') {
                if ($.trim($('#filtro_valor').val()) == "") {
                    $('#filtro_valor').focus();
                    return;
                }
            }

            if ($.trim($(this).val()) != "") {
                $(this).data('valorparametro', $.trim($(this).val()));
            }
            else {
                $(this).removeData('valorparametro');
            }
            buildfilter.call(this);

        }
    )


});

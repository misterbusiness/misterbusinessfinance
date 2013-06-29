/**
 * Created with JetBrains RubyMine.
 * User: administrator
 * Date: 29/06/13
 * Time: 11:06
 * To change this template use File | Settings | File Templates.
 */
    // **********************************************************************************************
    // To-do List
    // TODO: Tradudiz as mensagens do Select2
    // TODO: Comentar código
    // TODO: Ao clicar permite o usuário selecionar outro lançamento rápido
    //
    // **********************************************************************************************

$(document).ready(function () {
    var lancamentoDescricao = $("#lancamento_descricao");

    $("#<%= @page_item_id %>").select2({
        width: "resolve",
        maximumSelectionSize: 1,
        placeholder: "<%= @placeholder_value %>",
        /// TODO: No código abaixo o render estava sendo chamado, encontrar uma forma de utilizá-lo aqui no assets
        tags: [
            <% if not @iterator.nil? then %>
                <% @iterator.each do |iteration| %>
                {
                    id:<%= iteration.id %>,
                    text:'<%= iteration.descricao%>'
                },
                <% end %>
            <% end %>
        ]
        });

        lancamentoDescricao.on("open", function () {
            if (lancamentoDescricao.val() != "") {
                lancamentoDescricao.val("").trigger("change");
                lancamentoDescricao.select2("open");
            }
        });

        lancamentoDescricao.change(function () {
            var selectedValue = $("#lancamento_descricao").val();
            if (selectedValue != "") {
                var jqxhr =
                        $.ajax({
                            url: "<%= Rails.application.routes.url_helpers.lancamentorapidos_path %>/" + selectedValue,
            dataType: 'json',
            data: {}
            })
            .success(function (response) {
                lancamentoDescricao.val(response.descricao);

                var radio_receita = $('#lancamento_tipo_receita');
                var radio_despesa = $('#lancamento_tipo_despesa');
                // Adicionados labels para fazer a troca de cores na seleção
                var label_receita = $("#receita_label");
                var label_despesa = $("#despesa_label");

                if (response.tipo_cd == 1) {
                radio_despesa.prop("checked", true);
                label_despesa.removeClass('label-default').addClass('label-important');
                label_receita.removeClass('label-success').addClass('label-default');
                }
            else {
                radio_receita.prop("checked", true);
                label_receita.removeClass('label-default').addClass('label-success');
                label_despesa.removeClass('label-important').addClass('label-default');
                }
            var valor = $.fn.autoNumeric.Format('lancamento_valor', response.valor + '');
                                    $("#lancamento_valor").val(valor);

                                    var selectedDate = new Date((new Date).getFullYear(), (new Date).getMonth(), response.diavencimento);
                                    $("#data_vencimento_picker").datepicker("setDate", selectedDate);
                                    $("#data_vencimento_picker").datepicker({ format: 'dd-mm-yyyy' });

                                    $("#categoria_place").val(response.category_id).trigger("change");
                                    $("#centrodecusto_place").val(response.centrodecusto_id).trigger("change");
                                })
                                .error(function () {
                                    // Erro ocorre quando não encontra nenhum registro
                                })
            }
        });

    });

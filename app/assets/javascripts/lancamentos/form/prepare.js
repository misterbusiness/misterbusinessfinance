/**
 * Created with JetBrains RubyMine.
 * User: administrator
 * Date: 08/07/13
 * Time: 18:24
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function(){
    prepareForm();
});

function prepareForm()
{
    prepareTipo();
    prepareDescricao();
    prepareDatavencimento();
    //prepareValor();
    prepareCategory();
    prepareCentrodecusto();
    prepareAgendamento();
    prepareParcelamento();
    //prepareQuitado();
}

$(document).ready(function () {
    $('#quitado_hidden').val($('#quitado_checkbox').is(':checked'));
    $('#quitado_checkbox').click(function () {
        if ($(this).is(':checked')) {
            $('#quitado_hidden').val(true);
        }
        else {
            $('#quitado_hidden').val(false);
        }
    });
});

/**
 * Created with JetBrains RubyMine.
 * User: administrator
 * Date: 29/06/13
 * Time: 13:29
 * To change this template use File | Settings | File Templates.
 */

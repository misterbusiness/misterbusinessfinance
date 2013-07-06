/**
 * Created with JetBrains RubyMine.
 * User: administrator
 * Date: 06/07/13
 * Time: 14:19
 * To change this template use File | Settings | File Templates.
 */

function buildSelect2(elementId, placeHolderValue, contentUrl)
{
    alert("aquiiii")
    var element = $("#"+ elementId +"");

    var tagArray = "{";
    $.getJSON(contentUrl, function (data)
    {
        $.each(function(){
            tagArray += {id: this.id, descricao: this.descriao}
        });
        tagArray += ","
    });
    tagArray += "}"

    alert(tagArray);
    $("#" + elementId + "").select2({
        width: "resolve",
        maximumSelectionSize: 1,
        placeholder: "" + placeHolderValue + "",
        tags: [tagArray]
    });
}

function MakeSelect2(item_id, placeholder_value, tags)
{
    $("#"+ item_id + "").select2({
        width: "resolve",
        maximumSelectionSize: 1,
        placeholder: placeholder_value,
        tags: [tags]
        });
}

function GetTags()
//Javascript para tratar a paginação do componente

jQuery(

    $('.pagination a').each(function () {

            $(this).data('nomeparametro','page');
            $(this).data('valorparametro',(RegExp('page=' + '(.+?)(&|$)').exec($(this).prop('href'))||[,null])[1]);

        }


    )
);


jQuery(

    $('.pagination a').prop('href',"javascript:void(0)")
);



jQuery(
    $(function () {
        $('.pagination a').click(function () {

            $(this).addClass('filtro_parametro');
            buildfilter.call(this);
            //execScript("/assets/paginate.js");
            return false;
        });
    })


);


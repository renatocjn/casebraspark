
$(document).on "turbolinks:load", () ->
    $('.collapse').collapse()

    $("#filter_modal").on 'shown.bs.modal', ()->
        $('.collapse').collapse('hide')

    $("select.collapse_selecter").on "change", ()->
        if $(this).attr('data-collapse-container')
            container = $(this).attr('data-collapse-container')
        else
            container = "body"
        $(container).find(".collapse").collapse('hide')
        target = $(this).val().toLowerCase().trim()
        $(container).find('#collapse_'+target).collapse('show')
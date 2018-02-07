
$(document).on "turbolinks:load", () ->
    $('[data-toggle="tooltip"]').tooltip()

$(document).on 'cocoon:after-insert', (e, insertedItem) ->
    console.log(insertedItem)
    $(insertedItem).find('[data-toggle="tooltip"]').tooltip()
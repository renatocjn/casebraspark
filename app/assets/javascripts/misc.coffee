
$(document).on "turbolinks:load", () ->
    $('[data-toggle="tooltip"]').tooltip()

$(document).on 'cocoon:after-insert', (e, insertedItem) ->
    $(insertedItem).find('[data-toggle="tooltip"]').tooltip()

#$(document).on 'turbolinks:request-start', ->
#    $('body').css('cursor', 'wait');

#$(document).on 'turbolinks:request-end', ->
#    $('body').css('cursor', 'default');
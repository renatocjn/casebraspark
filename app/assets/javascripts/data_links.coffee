
$(document).on "turbolinks:load", () ->
    $("[data-link]").click ->
        Turbolinks.visit $(this).data("link")
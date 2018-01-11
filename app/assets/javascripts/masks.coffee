
$(document).on "turbolinks:load", () ->
    $('.date-input').inputmask("99/99/9999")
    $('.cpf-input').inputmask("999.999.999-99")
    $('.cnpj-input').inputmask("99.999.999/9999-99")
    #$('.multiple-phone-input').inputmask("* (99) [9]9999-9999")
    #Inputmask( {regex: "[:alpha:]+@[:alpha:]+\.[:alpha:]+"} ).mask("input[type=email]")
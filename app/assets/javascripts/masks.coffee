
setupInputs = ->
    $('.date-input').inputmask("99/99/9999")
    $('.cpf-input').inputmask("999.999.999-99")
    $('.cnpj-input').inputmask("99.999.999/9999-99")
    #$('.money-input').maskMoney({prefix:'R$ ', allowNegative: false, thousands:'.', decimal:',', affixesStay: false})

$(document).on 'turbolinks:load', setupInputs
$(document).on 'cocoon:after-insert', setupInputs
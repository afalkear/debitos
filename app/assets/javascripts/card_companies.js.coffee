jQuery ->
  $('#cancel_new_card_company_form').click ->
    $('.new_card_company_form').toggle()
    $('#new_card_company_form_button').toggle()

  $('#new_card_company_form_button').click ->
    $('#new_card_company_form_button').toggle()
    $('.new_card_company_form').toggle()
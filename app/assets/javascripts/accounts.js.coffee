$(document).ready ->
  $('#cancel_new_responsible_form').click ->
    $('.new_responsible_form').toggle()
    $('#new_responsible_form_button').toggle()

  $('#new_responsible_form_button').click ->
    $('#new_responsible_form_button').toggle()
    $('.new_responsible_form').toggle()

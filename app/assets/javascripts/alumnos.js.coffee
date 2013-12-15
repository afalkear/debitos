# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.best_in_place').best_in_place()
  $('.forum').hover ->
    $(this).toggleClass('forum_hover')

  # $('.alumno_secret .form_in_place input').payment('formatCardNumber')
  $('.alumno_secret').payment('formatCardNumber')
  $('#alumno_secret').keyup ->
    if ($('.visa')[0])
      $('#card_image').addClass('visa_thumb')
    else if ($('.mastercard')[0])
      $('#card_image').addClass('mastercard_thumb')
    else if ($('.amex')[0])
      $('#card_image').addClass('amex_thumb')
    else
      $('#card_image').removeClass()
#   if(!$.payment.validateCardNumber($('#alumno_secret').val()))
#     $('#cc-group').toggleClass('error')




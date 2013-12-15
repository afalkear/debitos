# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.best_in_place').best_in_place()
  $('.forum').hover ->
    $(this).toggleClass('forum_hover')

  $('#alumno_secret').payment('formatCardNumber')
  # $('#alumno_secret').keyup ->
  #   if(!$.payment.validateCardNumber($('#alumno_secret').val()))
  #     $('#cc-group').toggleClass('error')


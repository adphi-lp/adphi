# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  if $('#brothers_index').length > 0
    show_form = (a, kind, change, message) ->
      entry = a.parents('.entry')
      entry.find('.balance_form').hide()
      entry.find('.result').hide()

      form = entry.find(kind)
      form.find('input[name=change]').val(change)
      form.find('input[name=message]').val(message)

      if change > 0
        form.find('input[type=submit]').val('+' + change)
      else
        form.find('input[type=submit]').val(change)

      form.show()

    $('.kitchen_plus').click ->
      show_form($(this), '.kitchen_form', 1, 'making up kitchen crew')

    $('.kitchen_plus_one_half').click ->
      show_form($(this), '.kitchen_form', 1.5, 'unspecified reason')

    $('.kitchen_plus_quarter').click ->
      show_form($(this), '.kitchen_form', 0.25, 'putting away Sysco order')

    $('.kitchen_plus_half').click ->
      show_form($(this), '.kitchen_form', 0.5, 'unspecified reason')

    $('.kitchen_minus').click ->
      show_form($(this), '.kitchen_form', -1, 'missing kitchen crew with replacement')

    $('.kitchen_minus_one_half').click ->
      show_form($(this), '.kitchen_form', -1.5, 'missing kitchen crew without replacement')

    $('.kitchen_minus_quarter').click ->
      show_form($(this), '.kitchen_form', -0.25, 'unspecified reason')

    $('.kitchen_minus_half').click ->
      show_form($(this), '.kitchen_form', -0.5, 'unspecified reason')

    $('.house_plus').click ->
      show_form($(this), '.house_form', 1, 'making up')

    $('.house_minus').click ->
      show_form($(this), '.house_form', -1, 'missing house job')

    $('.social_plus').click ->
      show_form($(this), '.social_form', 1, 'making up')

    $('.social_minus').click ->
      show_form($(this), '.social_form', -1, 'missing social job')


$(document).ready(ready)
$(document).on('page:load', ready)
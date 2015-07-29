# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  if $('body#vouchers_show').length > 0
    $('input[name=line_item\\\[purchase_date\\\]]').fdatepicker(format: 'yyyy-mm-dd')

$(document).ready(ready)
$(document).on('page:load', ready)

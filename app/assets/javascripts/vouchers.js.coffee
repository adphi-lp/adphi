# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

nowTemp = new Date()
now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)

ready = ->
  if $('body#vouchers_show, body#vouchers_edit, body#vouchers_update').length > 0
    console.log("hello")
    $('input[name=line_item\\\[purchase_date\\\]], input.purchase_date_input').fdatepicker({
    	format: 'yyyy-mm-dd',
    	onRender: (date) ->
        	# Disable dates that are past the current date (no future purchases)
        	'disabled' if date.valueOf() > now.valueOf()
    })

$(document).ready(ready)
$(document).on('page:load', ready)

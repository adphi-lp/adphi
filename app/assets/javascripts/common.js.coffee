$.prepareEmbeddedFileFields = ->
  $('.embedded-file-field').each (ind, el) ->
    text = $(el).find('input[type=text]')
    file = $(el).find('input[type=file]')
    unless text.data('embedded-file-field-bound')
      text.click ->
        $(this).parent().find('input[type=file]').click()
        $(this).data('embedded-file-field-bound', true)
    unless file.data('embedded-file-field-bound')
      file.change ->
        $(this).parent().find('input[type=text]').val($(this).val().split(/[\\/]/).pop())
        $(this).data('embedded-file-field-bound', true)

ready = ->
  $.prepareEmbeddedFileFields()

$(document).ready(ready)
$(document).on('page:load', ready)

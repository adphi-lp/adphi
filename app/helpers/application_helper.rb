module ApplicationHelper
  def newline_format(str)
    str.split("\n").join("<br/>").html_safe
  end

  class ExtendedFormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::FormTagHelper

    def embedded_file_field(method, options = {})
      input = text_field_tag("#{@object_name}_#{method}_facade", @object.send("#{method}_file_name".to_s), {
        readonly: true,
        placeholder: options[:placeholder],
        name: nil
      })

      file = @template.file_field(@object_name, method, options)

      content_tag(:div, (input + file), {
        class: 'embedded-file-field'
      })
    end
  end
end

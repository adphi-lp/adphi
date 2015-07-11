module ApplicationHelper
  def newline_format(str)
    str.split("\n").join("<br/>").html_safe
  end
end

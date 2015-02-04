module ApplicationHelper
  def flash_messages
    flash.map do |type, message|
      next if message.blank?

      content_tag(:div, message, class: "alert alert-#{type}")
    end.join("\n").html_safe
  end
end

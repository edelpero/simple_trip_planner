module ApplicationHelper
  def navbar_active?(item, section)
    "active" if item == section
  end

  def resource_error_messages(resource)
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div id="error_explanation" class="ui error message">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end

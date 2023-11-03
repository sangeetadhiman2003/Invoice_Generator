module ApplicationHelper
  include Pagy::Frontend

  def highlight(text, query)
    return text if query.blank?

    text.gsub(/(#{Regexp.escape(query)})/i, '<mark>\1</mark>').html_safe
  end
end

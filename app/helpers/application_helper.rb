module ApplicationHelper
  def nav_link(name, url, activator = '')
    opts = {}

    if (activator.is_a?(String) && request.path.start_with?(activator)) ||
      (activator.is_a?(Regexp) && request.path =~ activator)
      opts.merge!({ class: 'active' })
    end

    content_tag :li, opts do
      link_to name, url
    end
  end
end

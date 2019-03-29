module ApplicationHelper
  def nav_link(name, url, activator = '')
    opts = {}

    if (activator.is_a?(String) && request.path.start_with?(activator)) ||
        (activator.is_a?(Regexp) && request.path =~ activator)
      opts[:class] = 'active'
    end

    content_tag :li, opts do
      link_to name, url
    end
  end

  def sortable(column, title, options = nil)
    css_class = column.to_s == params[:sort_by].to_s ? "current #{params[:sort_dir]}" : nil
    direction = column.to_s == params[:sort_by].to_s && params[:sort_dir].to_s == "asc" ? "desc" : "asc"

    if column.to_s == params[:sort_by].to_s
      title = (title + (direction == "desc" ? "<arrow-up></arrow-up>" : "<arrow-down></arrow-down>")).html_safe
    end

    options ||= {}
    options[:sort_by] = column
    options[:sort_dir] = direction

    link_to title, options, class: css_class
  end

  def application_version_identifier
    ENV["GIT_TAG"] || ENV["GIT_COMMIT"]&.slice(0..6)
  end
end

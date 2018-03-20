module CommoditiesHelper
  def leaf_position(commodity)
    if commodity.last_child?
      " last-child"
    else
      ""
    end
  end

  def commodity_level(commodity)
    "level-#{commodity.number_indents}"
  end

  def commodity_tree(main_commodity, commodities)
    if commodities.any?
      content_tag(:ul, class: 'commodities') do
        content_tag(:li, commodities.first.to_s.html_safe + tree_node(main_commodity, commodities, commodities.first.number_indents))
      end
    else
      content_tag(:ul, class: 'commodities') do
        content_tag(:li, commodity_heading(main_commodity))
      end
    end
  end

  def format_commodity_code(commodity)
    code = commodity.display_short_code.to_s
    "#{code[0..1]}&nbsp;#{code[2..3]}&nbsp;#{code[4..-1]}".html_safe
  end

  def format_full_code(commodity)
    code = commodity.code.to_s
    "#{chapter_and_heading_codes(code)}
    <div class='commodity-code'>
      <div class='code-text'>#{code[4..5]}</div>
      <div class='code-text'>#{code[6..7]}</div>
      <div class='code-text'>#{code[8..9]}</div>
    </div>".html_safe
  end

  def format_commodity_code_based_on_level(commodity)
    code = commodity.code.to_s

    if commodity.number_indents > 1
      code = if code[6..9] == "0000"
        code[0..5]
      elsif code[8..9] == "00"
        code[0..7]
      else
        code
      end

      "#{chapter_and_heading_codes(code)}
      <div class='commodity-code'>
        <div class='code-text pull-left'>#{code[4..5]}</div>
        #{code_text(code[6..7])}
        #{code_text(code[8..9])}
      </div>".html_safe
    end
  end

  private

  def chapter_and_heading_codes(code)
    "<div class='chapter-code'>
      <div class='code-text'>#{code[0..1]}</div>
    </div>
    <div class='heading-code'>
      <div class='code-text'>#{code[2..3]}</div>
    </div>"
  end

  def code_text(code)
    "<div class='code-text pull-left'>#{code}</div>" if code.present?
  end

  def tree_node(main_commodity, commodities, depth)
    deeper_node = commodities.select{ |c| c.number_indents == depth + 1 }.first
    if deeper_node.present? && deeper_node.number_indents < main_commodity.number_indents
      content_tag(:ul) do
        content_tag(:li) do
          content_tag(:span, deeper_node.to_s.html_safe) +
          tree_node(main_commodity, commodities, deeper_node.number_indents)
        end
      end
    else
      content_tag(:ul) do
        commodity_heading(main_commodity)
      end
    end
  end

  def commodity_heading(commodity)
    content_tag(:li, class: 'commodity-li') do
      content_tag(:div,
                  title: "Full tariff code: #{commodity.code}",
                  class: 'commodity-code',
                  'aria-describedby' => "commodity-#{commodity.code}") do
        content_tag(:div, format_commodity_code(commodity), class: 'code-text')
      end
      content_tag(:h1, commodity.to_s.html_safe) +
      content_tag(:div, class: 'feed') do
        link_to('Changes', commodity_changes_path(commodity.declarable, format: :atom), rel: "nofollow")
      end
    end
  end

  def commodity_heading_full(commodity)
    content_tag(:li, class: 'commodity-li') do
      content_tag(:div,
                  title: "Full tariff code: #{commodity.code}",
                  class: 'full-code',
                  'aria-describedby' => "commodity-#{commodity.code}") do
        content_tag(:div, format_full_code(commodity), class: 'code-text')
      end
      content_tag(:h1, commodity.to_s.html_safe) +
      content_tag(:div, class: 'feed') do
        link_to('Changes', commodity_changes_path(commodity.declarable, format: :atom), rel: "nofollow")
      end
    end
  end

  def declarable_heading(commodity)
    content_tag(:h1) do
      content_tag(:span, commodity.formatted_description.html_safe,
                          class: 'description',
                          id: "commodity-#{commodity.code}")
    end
  end

  def declarable_heading_full(commodity)
    content_tag(:li, class: 'commodity-li') do
      content_tag(:span, format_full_code(commodity),
                         title: "Full tariff code: #{commodity.code}",
                         class: 'full-code',
                         'aria-describedby' => "commodity-#{commodity.code}") +
      content_tag(:h1, commodity.to_s.html_safe)
    end
  end
end

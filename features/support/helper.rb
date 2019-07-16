
module Helper

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def format_summary_date(date)
    date.strftime("%d %B %Y")
  end

  def format_item_date(date)
    date.strftime("%d %b %Y")
  end

  def random_future_date
    number = rand(2..365)
    number.days.from_now
  end

  def random_past_date
    number = rand(60..90)
    number.days.ago
  end

  def periods(key)
    periods = {"Annual" => 1, "Bi-annual" => 2, "Quarterly" => 4, "Monthly" => 12, "Custom" => 1}
    periods[key]
  end

  def number_of_codes(commodity_codes)
    to_array(commodity_codes).size
  end

  def current_year
    Date.today.year
  end

  def random_workbasket_name
    number = random_number(8)
    "ATT #{number}"
  end

  def random_number(number)
    number.times.map{rand(9)}.join
  end

  def to_array(codes)
    all_codes = codes.split(",")
    all_codes.collect {|code| code.strip}
  end

  def format_regulation(regulation)
    year = regulation.slice(1..2)
    reg_id = regulation.slice(3..6)
    "20#{year}/#{reg_id}"
  end

  def format_footnote(footnote)
    "#{footnote['type']} - #{footnote['id']}"
    end

  def format_conditions(condition)
    "#{condition['type']} - #{condition['action']}"
  end

  def random_quota_number
    "09#{random_number(4)}"
  end

  def format_order_number(order_number)
    "#{order_number.slice(0..1)}.#{order_number.slice(2..5)}"
  end

  def search_for_value(select_value)
    find(".selectize-control input").click.send_keys(select_value)
    find(".selectize-dropdown-content .selection", text: select_value).click
  end

  def select_dropdown(value)
    find(".selectize-control").click
    find(".selectize-dropdown-content .option", text: value).click
  end
end
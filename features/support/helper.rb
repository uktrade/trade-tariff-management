
module Helper

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end

  def random_future_date
    number = rand(1..365)
    number.days.from_now
  end

  def random_past_date
    number = rand(1..365)
    number.days.ago
  end

  def random_workbasket_name
    number = random_number(6)
    "ATT #{number}"
  end

  def random_number(number)
    number.times.map{rand(9)}.join
  end

  def to_array(codes)
    all_codes = codes.split(",")
    all_codes.collect {|code| code.strip}
  end

# def format_date(mdate)
#   date = Date.parse(mdate)
#   date.strftime("%m %B %Y")
# end

  def format_regulation(regulation)
    year = regulation.slice(1..2)
    reg_id = regulation.slice(3..6)
    "20#{year}/#{reg_id}"
  end

  def format_footnote(footnote)
    "#{footnote['type']} - #{footnote['id']}"
    end

  def format_conditions(condition)
    "#{condition['type']}1 - #{condition['action']}"
  end

  def random_quota_number
    "09#{random_number(4)}"
  end
end
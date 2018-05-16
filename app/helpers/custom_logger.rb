module CustomLogger
  def log_it(message)
    if Rails.env.development?
      p ""
      p "-" * 100
      p ""
      p " #{message}"
      p ""
      p "-" * 100
      p ""
    end
  end
end

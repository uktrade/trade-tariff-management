class BaseRegulationDecorator < ApplicationDecorator

  def legal_id
    information_text.split(/\|/)[0]
  end

  def description
    information_text.split(/\|/)[1]
  end

  def reference_url
    information_text.split(/\|/)[2]
  end

end

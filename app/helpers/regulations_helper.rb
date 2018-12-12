module RegulationsHelper
  def regulation_title(regulation)
    base = regulation.class.name

    advanced_info = case regulation.public_send(regulation.primary_key[1]).to_s
                    when "2"
                      "Provisional anti-dumping/countervailing duty"
                    when "3"
                      "Definitive anti-dumping/countervailing duty"
    end

    base += " (#{advanced_info})" if advanced_info.present?

    base
  end

  def antidumping_regulation?
    ::RegulationSaver::ABROGATION_MODELS.include?(regulation.class.name)
  end
end

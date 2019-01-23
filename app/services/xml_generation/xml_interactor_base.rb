module XmlGeneration
  class XmlInteractorBase
    class << self
      def base_partial_path
        "#{Rails.root}/app/views/xml_generation/templates"
      end
    end

  private

    def xml_builder
      Builder::XmlMarkup.new
    end

    def renderer
      Tilt.new("#{self.class.base_partial_path}/#{template_name}.builder")
    end
  end
end

module XmlGeneration
  class TaricExport

    attr_accessor :record,
                  :mode,
                  :data,
                  :data_in_xml,
                  :tmp_file

    def initialize(record, mode)
      @record = record
      @mode = mode
    end

    def run
      mark_export_process_as_started!
      fetch_relevant_data
      generate_xml
      put_xml_data_into_tempfile!
      save_xml!
      clean_up_tmp_file!
    end

    class << self
      def base_partial_path
        "#{Rails.root}/app/views/xml_generation/templates"
      end
    end

    private

      def mark_export_process_as_started!
        record.update(state: "G")
      end

      def fetch_relevant_data
        @data = ::XmlGeneration::Search.new(
          record.relevant_date,
          mode
        ).result
      end

      def generate_xml
        @data_in_xml = renderer.render(data, xml: xml_builder)
      end

      def put_xml_data_into_tempfile!
        @tmp_file = Tempfile.new(["#{Time.now.to_i}_xml_export", ".xml"])
        tmp_file.binmode
        tmp_file.write(data_in_xml)
        tmp_file.rewind
      end

      def save_xml!
        record.xml = File.open(tmp_file)
        record.update(state: "C")
      end

      def clean_up_tmp_file!
        tmp_file.close
        tmp_file.unlink
      end

      def xml_builder
        Builder::XmlMarkup.new
      end

      def renderer
        Tilt.new("#{self.class.base_partial_path}/main.builder")
      end
  end
end

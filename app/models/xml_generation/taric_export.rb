require 'zip'

module XmlGeneration
  class TaricExport

    attr_accessor :record,
                  :data,
                  :data_in_xml,
                  :tmp_xml_file,
                  :tmp_base_64_file,
                  :tmp_zip_file

    def initialize(record)
      @record = record
    end

    def run
      mark_export_process_as_started!
      fetch_relevant_data
      generate_xml
      attach_xml_file!
      attach_base_64_version!
      attach_zip_version!
      persist!

      clean_up_tmp_files!
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
          record.date_filters
        ).result
      end

      def generate_xml
        @data_in_xml = renderer.render(data, xml: xml_builder)
      end

      def attach_xml_file!
        @tmp_xml_file = put_data_into_tempfile!(:xml, data_in_xml)
        save_xml!(:xml, tmp_xml_file)
      end

      def attach_base_64_version!
        @tmp_base_64_file = put_data_into_tempfile!(:base_64, base_64_version)
        save_xml!(:base_64, tmp_base_64_file)
      end

      def attach_zip_version!(tmp_file)
        @tmp_zip_file = generate_zip_file(tmp_file)
        save_xml!(:zip, tmp_zip_file)
      end

      def persist!
        record.update(state: "C")
      end

      def clean_up_tmp_files!
        clean_up_tmp_file!(tmp_xml_file)
        clean_up_tmp_file!(tmp_base_64_file)
        clean_up_tmp_file!(tmp_zip_file)
      end

      def base_64_version
        Base64.encode64(data_in_xml)
      end

      def put_data_into_tempfile!(version_name, content)
        tmp_file = Tempfile.new([tmp_file_name(version_name), ".xml"])

        tmp_file.binmode
        tmp_file.write(content)
        tmp_file.rewind

        tmp_file
      end

      def generate_zip_file(file_to_include)
        Zip::File.open("#{tmp_file_name(:zip)}.zip", Zip::File::CREATE) do |zipfile|
          zipfile.add(name_of_xml_file_in_zip_archieve, file_to_include.path)
        end
      end

      def save_xml!(uploader_name, tmp_file)
        record.public_send("#{uploader_name}=", File.open(tmp_file))
      end

      def tmp_file_name(version_name)
        "#{Time.now.to_i}_xml_export_#{version_name}_version"
      end

      def name_of_xml_file_in_zip_archieve
        "#{Time.now.to_i}_xml_export.xml"
      end

      def clean_up_tmp_file!(tmp_file)
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

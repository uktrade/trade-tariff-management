require 'zip'

module XmlGeneration
  class TaricExport < ::XmlGeneration::XmlInteractorBase

    attr_accessor :record,
                  :extract_start_date_time,
                  :extract_end_date_time,
                  :extract_database_date_time,
                  :xml_data,
                  :tmp_xml_file,
                  :tmp_base_64_file,
                  :tmp_zip_file,
                  :tmp_metadata_file

    def initialize(record)
      @record = record
    end

    def run
      mark_export_process_as_started!

      fetch_relevant_data_and_generate_xml
      attach_files!
      clean_up_tmp_files!

      mark_export_process_as_completed!
    end

    private

      def mark_export_process_as_started!
        @extract_start_date_time = Time.now.utc
        record.update(state: "G")
      end

      def mark_export_process_as_completed!
        @extract_end_date_time = Time.now.utc
        record.update(state: "C")
      end

      def fetch_relevant_data_and_generate_xml
        data = ::XmlGeneration::Search.new(
          record.date_filters
        ).result
        @extract_database_date_time = Time.now.utc

        @xml_data = renderer.render(data, xml: xml_builder)
      end

      def attach_files!
        attach_xml_file!
        attach_base_64_version!
        attach_zip_version!
        attach_metadata_file!
      end

      def attach_xml_file!
        @tmp_xml_file = put_data_into_tempfile!(:xml, xml_data)
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

      def attach_metadata_file!
        @tmp_metadata_file = put_data_into_tempfile!(:meta, metadata)
        save_xml!(:meta, tmp_metadata_file)
      end

      def clean_up_tmp_files!
        clean_up_tmp_file!(tmp_xml_file)
        clean_up_tmp_file!(tmp_base_64_file)
        clean_up_tmp_file!(tmp_zip_file)
        clean_up_tmp_file!(tmp_metadata_file)
      end

      def base_64_version
        Base64.encode64(xml_data)
      end

      def metadata
        ::XmlGeneration::Metadata.new(
          self
        ).generate
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
        "<Start Date -YYYYMMDD>-<Timestamp - YYYYMMDDHHMMSS>-TARICFileSequence.XML"
      end

      def clean_up_tmp_file!(tmp_file)
        tmp_file.close
        tmp_file.unlink
      end

      def template_name
        "main"
      end
  end
end

require 'zip'

module XmlGeneration
  class TaricExport < ::XmlGeneration::XmlInteractorBase
    attr_accessor :record,
                  :extract_start_date_time,
                  :extract_end_date_time,
                  :extract_database_date_time,
                  :xml_data,
                  :tmp_xml_file

    def initialize(record)
      @record = record
    end

    def run
      mark_export_process_as_started!
      fetch_relevant_data_and_generate_xml

      if xml_data
        validate_xml_data!
        attach_files!
        attach_metadata_file!
        clean_up_tmp_files!

        mark_export_process_as_completed!
      else
        mark_export_process_as_empty!
      end
    end

    def name_of_xml_file
      "#{filename_prefix}-EUFileSequence.xml"
    end

  private

    def mark_export_process_as_started!
      @extract_start_date_time = Time.now.utc
      record.update(state: "G")
    end

    def mark_export_process_as_completed!
      record.update(state: "C")
    end

    def mark_export_process_as_empty!
      record.update(state: "E")
    end

    # data is a XmlGeneration::NodeEnvelope object
    def fetch_relevant_data_and_generate_xml
      data = ::XmlGeneration::NodeEnvelope.new(result_groups)
      @extract_database_date_time = Time.now.utc

      unless @record.envelope_id.present?
        raise "Cannot export Taric XML without an envelope_id (id=#{@record.id})"
      end

      if data.present?
        @xml_data = renderer.render(
          data,
          xml: xml_builder,
          envelope_id: @record.envelope_id,
        )
      end
    end

    def result_groups
      ::XmlGeneration::TransactionGrouper.new.group(xml_generator_search.result)
    end

    def xml_generator_search
      ::XmlGeneration::WorkbasketSearch.new(record.workbasket_selected)
    end

    def validate_xml_data!
      errors = ::XmlGeneration::XmlXsdValidator.new(xml_data).run
      @record.update(validation_errors: errors.to_json)
    end

    def attach_files!
      attach_xml_file!
      @extract_end_date_time = Time.now.utc
    end

    def attach_xml_file!
      @tmp_xml_file = put_data_into_tempfile!(:xml, xml_data)
      save_xml!(:xml, tmp_xml_file)
    end

    def attach_metadata_file!
      @tmp_metadata_file = put_data_into_tempfile!(:meta, metadata)
      save_xml!(:meta, @tmp_metadata_file)
    end

    def clean_up_tmp_files!
      clean_up_tmp_file!(tmp_xml_file)
      clean_up_tmp_file!(@tmp_metadata_file)
    end

    def metadata
      ::XmlGeneration::Metadata.new(self).generate
    end

    def put_data_into_tempfile!(version_name, content)
      tmp_file = Tempfile.new([tmp_file_name(version_name), ".xml"])

      tmp_file.binmode
      tmp_file.write(content)
      tmp_file.rewind

      tmp_file
    end

    def save_xml!(uploader_name, tmp_file)
      @record.public_send("#{uploader_name}=", File.open(tmp_file))
    end

    def tmp_file_name(version_name)
      "#{extract_start_date_time}_#{Time.now.to_i}_xml_export_#{version_name}_version"
    end

    def name_of_metadata_file
      "DIT_TAQ01_V1_#{timestamp}_metadata.xml"
    end

    def filename_prefix
      "DIT_#{timestamp}"
    end

    def timestamp
      extract_start_date_time.strftime("%Y%m%dT%H%M%S")
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

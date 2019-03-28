require 'zip'
require 'aws-sdk-s3'

module XmlGeneration
  class Upload

    attr_reader :record, :timestamp

    def initialize(record, timestamp)
      @record = record
      @timestamp = timestamp
    end

    def run
      if Rails.env.development?
        upload_in_dev_env
      else
        upload_in_non_dev_env
      end
    end

    def s3
      Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    end

    def bucket(remote_path)
      s3.bucket(ENV['AWS_BUCKET_NAME']).object(remote_path)
    end

    def upload_in_dev_env
      upload_main_file_in_dev_env
      upload_metadata_file_in_dev_env
    end

    def upload_main_file_in_dev_env
      bucket(main_file_remote_path).upload_file(local_main_file_path)
    end

    def upload_metadata_file_in_dev_env
      bucket(metadata_remote_path).upload_file(local_metadata_file_path)
    end

    def remote_metadata_file_name
      "DIT#{record.envelope_id}_metadata.xml"
    end

    def remote_main_file_name
      "DIT#{record.envelope_id}.xml"
    end

    def local_main_file_path
      path = record.xml.url.prepend('public')
      Rails.root.join(path)
    end

    def local_metadata_file_path
      Rails.root.join('public', 'uploads', 'store', local_metadata_filename)
    end

    def local_metadata_filename
      JSON.parse(record.meta_data)['id']
    end

    def main_file_remote_path
      "dev/xml_testing/#{remote_main_file_name}"
    end

    def metadata_remote_path
      "dev/xml_testing/#{remote_metadata_file_name}"
    end

    def upload_in_non_dev_env
      upload_on_non_dev_mainfile
      upload_on_non_dev_metadata
    end

    def upload_on_non_dev_mainfile
      filename = record.xml.id
      object = s3.bucket(ENV['AWS_BUCKET_NAME']).object("store/#{filename}")
      object.copy_to(ENV['AWS_BUCKET_NAME'] + "/dev/xml_testing/#{remote_main_file_name}")
    end

    def upload_on_non_dev_metadata
      metadata_filename = JSON.parse(record.meta_data)['id']
      object = s3.bucket(ENV['AWS_BUCKET_NAME']).object("store/#{metadata_filename}")
      object.copy_to(ENV['AWS_BUCKET_NAME'] + "/dev/xml_testing/#{remote_metadata_file_name}")
    end
  end
end

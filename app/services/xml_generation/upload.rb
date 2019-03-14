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
      upload_main_file
      upload_metadata_file
    end

    def bucket(remote_path)
      s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
      s3.bucket(ENV['AWS_BUCKET_NAME']).object(remote_path)
    end

    def upload_main_file
      if Rails.env.development?
        upload_main_file_from_local
      else
        move_main_file_from_bucket
      end
    end

    def upload_metadata_file
      if Rails.env.development?
        upload_metadata_from_local
      else
        move_metadata_from_bucket
      end
    end

    def upload_main_file_from_local
      bucket(metadata_remote_path).upload_file(local_metadata_file_path)
    end

    def move_main_file_from_bucket
      key = record.xml.url.split('/').last(2).join('/').prepend('/')
      object = s3.buckets['AWS_BUCKET_NAME'].objects[key]
      object.move_to(ENV['AWS_BUCKET_NAME'] + "dev/xml_testing/#{remote_main_file_name}")
    end

    def upload_metadata_from_local
      bucket(metadata_remote_path).upload_file(local_metadata_file_path)
    end

    def move_metadata_from_bucket
      remote_metadata_file_name = Rails.root.join('store', local_metadata_filename)
      key = record.xml.url.split('/').last(2).join('/').prepend('/')
      object = s3.buckets['AWS_BUCKET_NAME'].objects[key]
      object.move_to(ENV['AWS_BUCKET_NAME'] + "dev/xml_testing/#{remote_metadata_file_name}")
    end

    def remote_metadata_file_name
      "DIT_TAQ01_V1_#{timestamp}_metadata.xml"
    end

    def remote_main_file_name
      "DIT_TAQ01_V1_#{timestamp}.xml"
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
  end
end

require 'aws-sdk-s3'

module XmlGeneration
  class Download
    def run
      object_collection = get_objects_from_bucket
      xml_collection = get_xml_from_objects(object_collection)
      move_objects_to_processed_directory(object_collection)
      CdsResponse::ResponseProcessor.process(xml_collection)
    end

    def bucket
      s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
      s3.bucket(ENV['AWS_BUCKET_NAME'])
    end

    def get_objects_from_bucket
      bucket.objects(prefix: 'dev')
    end

    def file_names
      bucket.objects.with_prefix('dev').collect(&:key)
    end

    def get_xml_from_objects(objects)
      objects.map do |object_summary|
        { object_summary.key => object_summary.object.get.body.string }
      end
    end

    def move_objects_to_processed_directory(objects)
      objects.each do |object_summary|
          filename = object_summary.key.split('/').last
        object_summary.object.move_to(ENV['AWS_BUCKET_NAME'] + "/dev/processed/#{filename}")
      end
    end
  end
end

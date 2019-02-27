require 'aws-sdk-s3'

module XmlGeneration
  class Download
    def run
      object_collection = bucket.objects(prefix: 'dev')
      xml_collection = object_collection.map do |object_summary|
        object_summary.object.get.body.string
      end
    end

    def bucket
      s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
      s3.bucket(ENV['AWS_BUCKET_NAME'])
    end

    def file_names
      bucket.objects.with_prefix('dev').collect(&:key)
    end
  end
end

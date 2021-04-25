require 'aws-sdk-s3'

module ArticlesHelper
    # Lists the available Amazon S3 buckets.
    #
    # @param s3_client [Aws::S3::Client] An initialized Amazon S3 client.
    # @example
    #   list_buckets(Aws::S3::Client.new(region: 'us-east-1'))
    def list_buckets(s3_client)
        response = s3_client.list_buckets
        if response.buckets.count.zero?
            puts 'No buckets.'
        else
            response.buckets.each do |bucket|
            puts bucket.name
        end
    end
    rescue StandardError => e
        puts "Error listing buckets: #{e.message}"
    end
end

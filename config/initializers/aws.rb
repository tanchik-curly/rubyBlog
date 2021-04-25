require 'aws-sdk-s3'

Aws.config.update({
  region: 'eu-north-1',
  credentials: Aws::Credentials.new('AKIAZH3A772PJ7GIM5MG', '3IbI867JOFWRuUy8CsCSR4x5WJzlzUdo5LCMH/Ud'),
  endpoint:'http://localhost:3000'
})

S3_BUCKET = Aws::S3::Resource.new.bucket('rails-blog-articles')
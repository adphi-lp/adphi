Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = {
  bucket: ENV['S3_BUCKET_NAME'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  s3_host_name: ENV['S3_HOST_NAME']
}

Paperclip.options[:content_type_mappings] = {
  pdf: "application/pdf"
}
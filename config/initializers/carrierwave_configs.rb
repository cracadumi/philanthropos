CarrierWave.configure do |config|
  config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: AWS_KEY_ID,
      aws_secret_access_key: AWS_KEY,
      url: ":s3_domain_url",
      region: S3_REGION 
  }
  config.fog_directory = BUCKET_NAME
  # config.asset_host = ASSET_HOST
end
CarrierWave.configure do |config|
  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')
  case Rails.env.to_sym
    when :production
      config.fog_credentials = {
        provider: "AWS",
        aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
        url: ":s3_domain_url",
        region: ENV["AWS_REGION"]
      }
      config.fog_directory = ENV["S3_BUCKET_NAME"]
    # config.asset_host = ASSET_HOST
    else
      config.storage = :file
      config.root = File.join(Rails.root, 'public')
  end
end

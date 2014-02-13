sync = Hobo::Lib::S3Sync.new(
  Hobo.user_config.aws.access_key_id,
  Hobo.user_config.aws.secret_access_key
)

Hobo.ui.success("Downloading magento sample data")
sync.sync("s3://inviqa-assets-magento/development/1.11.1.0/", File.join(Hobo.project_config.project_path, "tools/assets/development/"))
Hobo.ui.separator
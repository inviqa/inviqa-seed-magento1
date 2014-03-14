sync = Hobo::Lib::S3::Sync.new(Hobo.aws_credentials)

Hobo.ui.success("Downloading magento sample data")
sync.sync(
  "s3://inviqa-assets-magento/development/1.11.1.0/",
  File.join(Hobo.project_config.project_path, "tools/assets/development/")
)
Hobo.ui.separator

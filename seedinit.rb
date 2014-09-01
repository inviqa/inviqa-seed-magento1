sync = Hobo::Lib::S3::Sync.new(Hobo.aws_credentials)
default_edition = 'enterprise'
editions = ['enterprise', 'community']

if Hobo.project_config[:magento_edition].nil? || !editions.include?(Hobo.project_config[:magento_edition])
  Hobo.project_config[:magento_edition] = Hobo.ui.ask_choice("Magento edition", editions, :default => default_edition)
end

magento_edition = Hobo.project_config[:magento_edition]

magento_git_url = "git@github.com:inviqa/magento-#{magento_edition}"

magento_seed = Hobo::Lib::Seed::Seed.new(
  File.join(Hobo.seed_cache_path, "magento-#{magento_edition}"),
  magento_git_url
)
magento_seed.update

versions = magento_seed.tags.reverse

if Hobo.project_config[:magento_version].nil? || !versions.include?(Hobo.project_config[:magento_version])
  Hobo.project_config[:magento_version] = Hobo.ui.ask_choice("Magento version", versions, :default => versions.first)
end

magento_version = Hobo.project_config[:magento_version]
magento_version_parts = magento_version.split('.')

magento_semver = Semantic::Version.new(magento_version_parts[0..2].join('.') + "-pre.#{magento_version_parts[3]}")

sample_data_version = case magento_edition
  when 'enterprise'
    if magento_semver.satisfies('>= 1.14.0-pre.0')
      '1.14.0.0'
    else
      '1.11.1.0'
    end
  when 'community'
    if magento_semver.satisfies('>= 1.9.0-pre.0')
      '1.9.0.0'
    else
      '1.6.1.0'
    end
  end


magento_seed.export File.join(Hobo.project_config.project_path, 'public'),
  :name => "magento-#{magento_edition}",
  :ref => magento_version

Hobo.ui.success("Downloading magento sample data")
sync.sync(
  "s3://inviqa-assets-magento/#{magento_edition}/sample-data/#{sample_data_version}/",
  File.join(Hobo.project_config.project_path, "tools/assets/development/")
)
Hobo.ui.separator

Hobo.ui.success "Don't forgot to run `hobo assets upload` once your S3 bucket is created!"
Hobo.ui.separator

# Overwrite hobo README with project README
old_readme = File.join(Hobo.project_config.project_path, 'README.md')
new_readme = File.join(Hobo.project_config.project_path, 'README.project.md')
FileUtils.mv new_readme, old_readme

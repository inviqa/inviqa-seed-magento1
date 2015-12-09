require 'semantic'

if defined?(Hem)
  tool_name = 'hem'
else
  tool_name = 'hobo'
  Hem = Hobo
end

def download_magento(magento_seed, magento_edition, magento_version)
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


  Hem.ui.success("Exporting Magento #{magento_edition} #{magento_version} to public folder")
  magento_seed.export File.join(Hem.project_config.project_path, 'public'),
    :name => "magento-#{magento_edition}",
    :ref => magento_version

  Hem.ui.success("Downloading magento sample data")
  sync = Hem::Lib::S3::Sync.new(Hem.aws_credentials)
  sync.sync(
    "s3://inviqa-assets-magento/#{magento_edition}/sample-data/#{sample_data_version}/",
    File.join(Hem.project_config.project_path, "tools/assets/development/")
  )
end

unless ::Semantic::Version.new(Hem::VERSION).satisfies('>= 0.0.15')
  FileUtils.rm_rf Hem.project_config.project_path
  raise Hem::UserError.new "This seed requires at least hobo 0.0.15\n\nPlease upgrade with `gem install hobo-inviqa`"
end

default_edition = 'enterprise'
editions = ['enterprise', 'community', 'skip']

if Hem.project_config[:magento_edition].nil? || !editions.include?(Hem.project_config[:magento_edition])
  Hem.project_config[:magento_edition] = Hem.ui.ask_choice("Magento edition", editions, :default => default_edition)
end

magento_edition = Hem.project_config[:magento_edition]

if magento_edition == 'skip'
  Hem.project_config.delete(:magento_edition)
  Hem.project_config.delete(:magento_version)
else
  magento_git_url = "git@github.com:inviqa/magento-#{magento_edition}"

  magento_seed = Hem::Lib::Seed::Seed.new(
    File.join(Hem.seed_cache_path, "magento-#{magento_edition}"),
    magento_git_url
  )
  magento_seed.update

  versions = magento_seed.tags.reverse

  if Hem.project_config[:magento_version].nil? || !versions.include?(Hem.project_config[:magento_version])
    Hem.project_config[:magento_version] = Hem.ui.ask_choice("Magento version", versions, :default => versions.first)
  end

  download_magento(magento_seed, magento_edition, Hem.project_config[:magento_version])

  Hem.ui.separator

  Hem.ui.success "Don't forget to run `#{tool_name} assets upload` once your S3 bucket is created!"
  Hem.ui.separator
end

Hem.ui.success "Please also run `#{tool_name} magento patches apply` to get the latest Magento patches."
Hem.ui.success "You may have to have run `#{tool_name} vm up` beforehand if you aren't on Linux/OSX"
Hem.ui.separator

# Overwrite hem README with project README
old_readme = File.join(Hem.project_config.project_path, 'README.md')
new_readme = File.join(Hem.project_config.project_path, 'README.project.md')
FileUtils.mv new_readme, old_readme

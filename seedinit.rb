def download_magento(magento_seed, magento_edition, magento_version)
  sample_data_version = case magento_edition
    when 'enterprise'
      if Gem::Dependency.new('', '>= 1.14.2.4').match?('', magento_version)
        '1.14.2.4'
      elsif Gem::Dependency.new('', '>= 1.14').match?('', magento_version)
        '1.14.0.0'
      else
        '1.11.1.0'
      end
    when 'community'
      if Gem::Dependency.new('', '>= 1.9.2.4').match?('', magento_version)
        '1.9.2.4'
      elsif Gem::Dependency.new('', '>= 1.9').match?('', magento_version)
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

Hem.require_version '>= 1.2.0'

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

  Hem.ui.success "Don't forget to run `hem assets upload` once your S3 bucket is created!"
  Hem.ui.separator
end

Hem.ui.success "Please also run `hem magento patches apply` to get the latest Magento patches."
Hem.ui.success "You may have to have run `hem vm up` beforehand if you aren't on Linux/OSX"
Hem.ui.separator

# Overwrite .dev hostnames with .test
config.hostname = "#{config.name}.test"

# Overwrite hem README with project README
old_readme = 'README.md'
new_readme = 'README.project.md.erb'
File.delete old_readme
FileUtils.mv new_readme, "#{old_readme}.erb"

# MySQL local VM MySQL passwords
password = '984C42CF342f7j6' # password still is set in the basebox
config.tmp.mysql_root_password = password
config.tmp.mysql_repl_password = password
config.tmp.mysql_debian_password = password

config.locate.Berksfile.patterns = ['tools/chef/Berksfile']
config.locate.Cheffile.patterns = ['tools/chef/Cheffile']
config.locate.Gemfile.patterns = ['Gemfile']
config.locate.Vagrantfile.patterns = ['tools/vagrant/Vagrantfile']

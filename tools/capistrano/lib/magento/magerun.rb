require "capistrano"

module Magento
  class Magerun
    def self.load_into(config)
      config.load do
        after "deploy:setup", "inviqa:magerun:setup"
        after "deploy:migrate", "inviqa:magerun:sys_setup", "inviqa:magerun:cache_clean"

        namespace :inviqa do
          namespace :magerun do
            task :setup do
              run "curl -o #{shared_path}/n98-magerun.phar https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar"
            end

            task :cache_clean, :roles => :app, :only => { :primary => true } do
              run "cd #{latest_release}/public && php #{shared_path}/n98-magerun.phar cache:clean"
            end

            task :sys_setup, :roles => :app, :only => { :primary => true } do
              run "cd #{latest_release}/public && php #{shared_path}/n98-magerun.phar cache:clean config"
              run "cd #{latest_release}/public && php #{shared_path}/n98-magerun.phar sys:setup:incremental -n"
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Magento::Magerun.load_into(Capistrano::Configuration.instance)
end

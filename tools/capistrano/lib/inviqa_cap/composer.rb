require "capistrano"

module InviqaCap
  class Composer
    def self.load_into(config)
      config.load do
        _cset(:composer_home) { "#{shared_path}/composer" }
        after "deploy:setup", "inviqa:composer:setup"
        after "deploy:finalize_update", "inviqa:composer:install"

        namespace :inviqa do
          namespace :composer do
            task :setup do
              run "cd #{shared_path} && curl -sS https://getcomposer.org/installer | /usr/bin/env COMPOSER_HOME=#{composer_home} php"
            end

            task :install do
              run "cd #{shared_path} && COMPOSER_HOME=#{composer_home} php #{shared_path}/composer.phar self-update"
              run "cd #{latest_release} && COMPOSER_HOME=#{composer_home} php #{shared_path}/composer.phar install --no-dev --optimize-autoloader"
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  InviqaCap::Composer.load_into(Capistrano::Configuration.instance)
end

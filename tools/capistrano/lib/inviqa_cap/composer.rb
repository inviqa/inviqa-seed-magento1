require "capistrano"

module InviqaCap
  class Composer
    def self.load_into(config)
      config.load do
        after "deploy:setup", "inviqa:composer:setup"
        after "deploy:finalize_update", "inviqa:composer:install"

        namespace :inviqa do
          namespace :composer do
            task :setup do
              run "mkdir -p #{shared_path}/composer"
              run "cd #{shared_path} && curl -sS https://getcomposer.org/installer | php"
            end

            task :install do
              run "cp #{latest_release}/composer.* #{shared_path}/composer"
              run "cd #{shared_path} && php #{shared_path}/composer.phar self-update"
              run "cd #{shared_path}/composer && php #{shared_path}/composer.phar install --no-dev --optimize-autoloader"
              run "cp -R #{shared_path}/composer/* #{latest_release}"
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

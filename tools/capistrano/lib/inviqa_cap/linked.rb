require "capistrano"

module InviqaCap
  class LinkedFiles
    def self.load_into(config)
      config.load do
        after "deploy:setup", "inviqa:setup"
        after "deploy:setup", "inviqa:composer:setup"

        before "deploy:create_symlink", "inviqa:symlink"
        after "deploy:finalize_update", "deploy:cleanup"

        namespace :inviqa do
          task :setup do
            (linked_files || []).each do |file|
              run "mkdir -p #{File.join(shared_path, File.dirname(file))}"
            end

            (linked_directories || []).each do |file|
              run "mkdir -p #{File.join(shared_path, file)}"
            end
          end

          task :symlink do
            linked = (linked_directories || []).concat(linked_files || [])
            linked.each do |file|
              shared_file = File.join(shared_path, file)
              release_file = File.join(latest_release, file)
              run "rm -rf #{release_file}"
              run "ln -s #{shared_file} #{release_file}"
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  InviqaCap::LinkedFiles.load_into(Capistrano::Configuration.instance)
end
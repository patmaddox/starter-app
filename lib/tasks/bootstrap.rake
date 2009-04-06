require 'fileutils'

namespace :bootstrap do
  desc "Create required directories"
  task :create_dirs do
    Dir.chdir(RAILS_ROOT) do
      %w(log db).each {|dir| FileUtils.mkdir(dir) unless File.directory?(dir) }
    end
  end

  desc "Copy the database.yml file"
  task :copy_db_yml do
    Dir.chdir(RAILS_ROOT + '/config') do
      FileUtils.cp('database.yml.example', 'database.yml') unless File.exist?('database.yml')
    end
  end

  desc "Install required gems with geminstaller"
  task :install_gems do
    `sudo gem install geminstaller` unless `gem list geminstaller`.include?('geminstaller')
    puts "Installing required gems"
    Dir.chdir(RAILS_ROOT) do
      `sudo geminstaller`
      `sudo geminstaller -c config/geminstaller_test.yml` if File.exist?('config/geminstaller_test.yml')
    end
  end

  desc "Generate rspec"
  task :generate_rspec do
    Dir.chdir(RAILS_ROOT) { `ruby script/generate rspec` unless File.directory?('spec') }
  end

  desc "Generate cucumber"
  task :generate_cucumber do
    Dir.chdir(RAILS_ROOT) { `ruby script/generate cucumber` unless File.directory?('features') }
  end
end

desc "Bootstrap a new project"
task :bootstrap => ["bootstrap:create_dirs", "bootstrap:copy_db_yml", "bootstrap:install_gems",
                    "bootstrap:generate_rspec", "bootstrap:generate_cucumber"]

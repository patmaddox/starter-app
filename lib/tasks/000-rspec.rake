desc "Check out the rspec and rspec-rails plugins to vendor/plugins"
task :fetch_rspec do
  plugins_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'plugins'))

  new_rspec = false
  %w(rspec rspec-rails).each do |plugin|
    if File.exist?(File.join(plugins_dir, plugin))
      puts "Updating #{plugin}"
      puts `cd #{File.join(plugins_dir, plugin)} && git pull --rebase`
    else
      new_rspec = true
      puts "Fetching #{plugin}"
      puts `cd #{plugins_dir} && git clone git://github.com/dchelimsky/#{plugin}.git`
    end
  end
  
  puts "It looks like you installed RSpec for the first time.  You may want to run\n\t./script/generate rspec" if new_rspec
end

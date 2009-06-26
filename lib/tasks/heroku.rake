namespace :heroku do
  desc "Generates the .gems dependencies from the config.gem directives of the current environment"
  task :gems => :environment do
    File.open(".gems", "w") do |io|
      # If we have vendored Rails, no need to specify a dependency
      io.printf "%-30s --version %-12s\n", "rails", Rails.version.to_s.inspect unless Rails.vendor_rails?

      Rails.configuration.gems.each do |gem|
        next if gem.vendor_gem? # Don't install gems that we've vendored

        name            = gem.name
        versions        = gem.requirement ? gem.requirement.as_list : []
        current_version = Gem.loaded_specs[name].version
        source          = gem.source

        io.printf "%-30s", name
        if versions.empty?
          io.printf " --version %-12s", current_version.to_s.inspect
        else
          versions.each do |version|
            io.printf " --version %-12s", version.to_s.inspect
          end
        end
        io.printf " --source \"%s\"", source if source
        io.printf "\n"
      end
    end

    sh "git add .gems"
    result = `git status`
    case $?.exitstatus
    when 0
      sh "git commit -m \"Updated .gems dependencies for Heroku, in the #{Rails.env} environment\" .gems"
    when 1
      # NOP, clean directory
    else
      puts result
      exit $?.exitstatus
    end
  end
end

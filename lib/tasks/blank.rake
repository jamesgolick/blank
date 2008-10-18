namespace :blank do
  task :switch_origin do
    `git remote add origin #{ENV['REPO']}`
    `git push --force origin master`
    `git fetch origin`
    `git checkout origin/master`
    `git branch --track -f master origin/master`
    `git checkout master`
  end
  
  task :switch_to_app_gitignore do
    `cp .new_app.gitignore .gitignore`
  end
  
  task :session_config do
    @secret = Rails::SecretKeyGenerator.new(ENV['ID']).generate_secret
    @name   = ENV['NAME']
    
    result = ERB.new(File.read(File.dirname(__FILE__)+'/../templates/session.rb.erb')).result(binding)
    File.open(File.dirname(__FILE__)+'/../../config/session.rb', 'w') do |f|
      f << result
    end
  end
end

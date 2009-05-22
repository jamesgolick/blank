namespace :blank do
  task :switch_origin do
    sh "git remote add origin #{ENV['REPO']}"
    sh "git push origin master"
    sh "git fetch origin"
    sh "git checkout origin/master"
    sh "git branch --track -f master origin/master"
    sh "git checkout master"
  end
  
  task :switch_to_app_gitignore do
    cp ".new_app.gitignore", ".gitignore"
  end
  
  task :session_config do
    @secret = ActiveSupport::SecureRandom.hex(64)
    @name   = ENV['NAME']
    
    result = ERB.new(File.read(File.dirname(__FILE__)+'/../templates/session.rb.erb')).result(binding)
    File.open(File.dirname(__FILE__)+'/../../config/session.rb', 'w') do |f|
      f << result
    end
  end

  task :prepare_test_env do
    sh "rake RAILS_ENV=test gems:install"
  end

  task :build => ['blank:session_config', 'auth:gen:site_key', 'gems:install', 'db:migrate', 'blank:prepare_test_env', :test]
end

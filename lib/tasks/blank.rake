namespace :blank do
  task :switch_origin do
    `git remote add origin #{ENV['REPO']}`
    `git push origin master`
    `git fetch origin`
    `git checkout origin/master`
    `git branch --track -f master origin/master`
    `git checkout master`
  end
  
  task :switch_to_app_gitignore do
    `cp .new_app.gitignore .gitignore`
  end
end

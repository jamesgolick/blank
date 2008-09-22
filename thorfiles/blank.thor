# module: blank

class Blank < Thor
  BLANK_REPO = 'git@github.com:giraffesoft/blank.git'
  
  desc "new_app NAME [REPO]", "Create a new blank app in directory NAME."
  def new_app(name, repo=nil)
    @name = name
    
    puts "---- Cloning blank from #{BLANK_REPO}..."
    `git clone -o blank #{BLANK_REPO} #{name}`
    
    puts "\n---- Generating site keys for restful-auth..."
    run_in_project_dir 'rake auth:gen:site_key'
    
    if repo
      puts "\n---- Pushing to repo @ #{repo}..."
      run_in_project_dir("git remote add origin #{repo}")
      run_in_project_dir("git push origin master")
    end
    
    puts "\n---- There are TODOs in blank. Here's the output of rake notes, for your perusal:"
    puts run_in_project_dir('rake notes')
  end
  
  protected
    def run_in_project_dir(cmd)
      `cd #{@name}; #{cmd}`
    end
end

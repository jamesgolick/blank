# module: blank

class Blank < Thor
  desc "new_app NAME [REPO] [BRANCH]", "Create a new blank app, from branch BRANCH (defaults to master), in directory NAME, push it to REPO."
  def new_app(name, repo=nil, branch="master")
    run "rails --template http://github.com/giraffesoft/blank/raw/templates/auth.rb #{name}"
    return unless repo
    Dir.chdir(name) do
      run "git remote add origin #{repo}"
      run "git push origin #{branch}"
      run "git config branch.master.remote origin"
      run "git config branch.master.merge refs/heads/#{branch}"
    end
  end

  protected
  def run(command)
    system(command)
  end
end

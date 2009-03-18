# Don't need this static file, we already have a home page defined in PagesController
run "rm public/index.html"

# We happen to prefer jQuery
run "rm -f public/javacripts/{prototype,controls,dragdrop,effects}.js"
run "curl -q -o public/javascripts/jquery-min.js http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"
file "public/javascripts/application.js", %q(jQuery(function() {
// Add your hooks here
});
)

plugin "hoptoad_notifier",       :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
plugin "open_id_authentication", :git => "git://github.com/rails/open_id_authentication.git"
plugin "resource_controller",    :git => "git://github.com/giraffesoft/resource_controller.git"

# Authentication
gem "thoughtbot-clearance",     :lib => "clearance",     :source => "http://gems.github.com/"
gem "ruby-openid",              :lib => "openid"

# Attachments
gem "thoughtbot-paperclip",     :lib => "paperclip",     :source => "http://gems.github.com/"

# Pagination
gem "mislav-will_paginate",     :lib => "will_paginate", :source => "http://gems.github.com/"

# Utilities
gem "andand"
gem "active_presenter"

# Testing dependencies
file "tmp/testing.rb", %q(
# GiraffeSoft Testing Preferences:
config.gem "floehopper-mocha",        :source => "http://gems.github.com/", :lib => "mocha"
config.gem "thoughtbot-shoulda",      :source => "http://gems.github.com/", :lib => "shoulda/rails"
config.gem "thoughtbot-factory_girl", :source => "http://gems.github.com/", :lib => "factory_girl"

# Cucumber, for feature testing
config.gem "aslakhellesoy-cucumber", :lib => "cucumber", :source => "http://gems.github.com/"
config.gem "webrat"

# Cucumber dependencies
config.gem "term-ansicolor", :lib => "term/ansicolor"
config.gem "treetop"
config.gem "diff-lcs",       :lib => "diff/lcs"
config.gem "nokogiri"
config.gem "builder"
)
run "cat tmp/testing.rb >> config/environments/test.rb"
run "rm tmp/testing.rb"

# Make sure all gems are installed
rake "gems:install", :sudo => true
rake "gems:install", :sudo => true, :env => "test"

# Unpack runtime dependencies
rake "gems:unpack"
rake "rails:freeze:gems"

# Generate the required Cucumber files, for feature testing
generate "cucumber"

# Install clearance correctly
generate "clearance"
generate "clearance_features", "--force"

initializer "mail.rb", %q(# Clearance needs this constant setup to know from where to send mail
# TODO: Change these to something appropriate
HOST         = "localhost"
DO_NOT_REPLY = "no-reply@localhost"
)

# We happen to prefer Test::Unit in Cucumber features as well
file "tmp/world.rb", %q(require "test/unit/assertions"

World do |world|
  world.extend(Test::Unit::Assertions)
  world
end
)
run "cat tmp/world.rb >> features/support/env.rb"
run "rm tmp/world.rb"

# Running rake alone should also run the features
rakefile "testing.rake", "task :default => :features"

# Generate the initial DB (SQLite3 probably)
rake "db:create"
rake "db:migrate"
rake "db:create", :env => "test"

# Ignore files and folders, and make sure the folders exist on checkout
file ".gitignore", %q(coverage/*
.DS_Store
public/javascripts/all.js
public/stylesheets/all.css
.dotest/*
)

file "log/.gitignore", %q(*.log
*.pid
)

file "db/.gitignore", %q(*.db
*.sqlite3
)

file "tmp/.gitignore", "**/*"
file "doc/.gitignore", %q(api
app
)

route "map.root :controller => \"pages\", :action => \"show\", :page => \"home\""
run "mkdir app/views/pages"
file "app/views/pages/home.html.erb", "<h1>This is your home page</h1>\n<p><%= flash[:notice] %></p>\n"
file "app/controllers/pages_controller.rb", %q(class PagesController < ApplicationController
  def show
    render params[:page]
  end
end
)

git :init
git :add => "."
git :commit => "--message 'Initial commit'"

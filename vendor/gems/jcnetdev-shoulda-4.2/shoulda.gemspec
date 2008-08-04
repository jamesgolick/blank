Gem::Specification.new do |s|
  s.name = 'shoulda'
  s.version = '4.2'
  s.date = '2008-07-04'
  
  s.summary = "Makes tests easy on the fingers and the eyes"
  s.description = "Shoulda consists of test macros, assertions, and helpers added on to the Test::Unit framework"
  
  s.authors = ['Tammer Saleh']
  s.email = 'tsaleh@thoughtbot.com'
  s.homepage = 'http://github.com/thoughtbot/shoulda'

  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.extra_rdoc_files = ["README.rdoc"]

  s.add_dependency 'rails', ['>= 2.1']
  
  s.files = ["CONTRIBUTION_GUIDELINES.rdoc",
              "MIT-LICENSE",
              "README.rdoc",
              "Rakefile",
              "bin/convert_to_should_syntax",
              "init.rb",
              "lib/shoulda/active_record_helpers.rb",
              "lib/shoulda/color.rb",
              "lib/shoulda/controller_tests",
              "lib/shoulda/controller_tests/controller_tests.rb",
              "lib/shoulda/controller_tests/formats",
              "lib/shoulda/controller_tests/formats/html.rb",
              "lib/shoulda/controller_tests/formats/xml.rb",
              "lib/shoulda/gem/proc_extensions.rb",
              "lib/shoulda/gem/shoulda.rb",
              "lib/shoulda/general.rb",
              "lib/shoulda/private_helpers.rb",
              "lib/shoulda.rb",
              "rails/init.rb",
              "shoulda.gemspec",
              "tasks/list_tests.rake",
              "tasks/yaml_to_shoulda.rake"]
  
  s.test_files = ["test/fixtures/addresses.yml",
                   "test/fixtures/posts.yml",
                   "test/fixtures/taggings.yml",
                   "test/fixtures/tags.yml",
                   "test/fixtures/users.yml",
                   "test/functional/posts_controller_test.rb",
                   "test/functional/users_controller_test.rb",
                   "test/other/context_test.rb",
                   "test/other/helpers_test.rb",
                   "test/other/private_helpers_test.rb",
                   "test/rails_root/app/controllers/application.rb",
                   "test/rails_root/app/controllers/posts_controller.rb",
                   "test/rails_root/app/controllers/users_controller.rb",
                   "test/rails_root/app/helpers/application_helper.rb",
                   "test/rails_root/app/helpers/posts_helper.rb",
                   "test/rails_root/app/helpers/users_helper.rb",
                   "test/rails_root/app/models/address.rb",
                   "test/rails_root/app/models/dog.rb",
                   "test/rails_root/app/models/flea.rb",
                   "test/rails_root/app/models/post.rb",
                   "test/rails_root/app/models/tag.rb",
                   "test/rails_root/app/models/tagging.rb",
                   "test/rails_root/app/models/user.rb",
                   "test/rails_root/app/views/layouts/posts.rhtml",
                   "test/rails_root/app/views/layouts/users.rhtml",
                   "test/rails_root/app/views/posts/edit.rhtml",
                   "test/rails_root/app/views/posts/index.rhtml",
                   "test/rails_root/app/views/posts/new.rhtml",
                   "test/rails_root/app/views/posts/show.rhtml",
                   "test/rails_root/app/views/users/edit.rhtml",
                   "test/rails_root/app/views/users/index.rhtml",
                   "test/rails_root/app/views/users/new.rhtml",
                   "test/rails_root/app/views/users/show.rhtml",
                   "test/rails_root/config/boot.rb",
                   "test/rails_root/config/database.yml",
                   "test/rails_root/config/environment.rb",
                   "test/rails_root/config/environments/sqlite3.rb",
                   "test/rails_root/config/initializers/new_rails_defaults.rb",
                   "test/rails_root/config/routes.rb",
                   "test/rails_root/db/migrate/001_create_users.rb",
                   "test/rails_root/db/migrate/002_create_posts.rb",
                   "test/rails_root/db/migrate/003_create_taggings.rb",
                   "test/rails_root/db/migrate/004_create_tags.rb",
                   "test/rails_root/db/migrate/005_create_dogs.rb",
                   "test/rails_root/db/migrate/006_create_addresses.rb",
                   "test/rails_root/db/migrate/007_create_fleas.rb",
                   "test/rails_root/db/migrate/008_create_dogs_fleas.rb",
                   "test/rails_root/db/migrate/009_add_ssn_to_users.rb",
                   "test/rails_root/db/schema.rb",
                   "test/rails_root/log/.keep",
                   "test/rails_root/public/.htaccess",
                   "test/rails_root/public/404.html",
                   "test/rails_root/public/422.html",
                   "test/rails_root/public/500.html",
                   "test/rails_root/script/console",
                   "test/rails_root/script/generate",
                   "test/rails_root/vendor/plugins/.keep",
                   "test/README",
                   "test/test_helper.rb",
                   "test/unit/address_test.rb",
                   "test/unit/dog_test.rb",
                   "test/unit/flea_test.rb",
                   "test/unit/post_test.rb",
                   "test/unit/tag_test.rb",
                   "test/unit/tagging_test.rb",
                   "test/unit/user_test.rb"]

end
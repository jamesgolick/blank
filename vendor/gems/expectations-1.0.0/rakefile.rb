require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README'
  task.title = 'expectations'
  task.rdoc_dir = 'doc'
  task.options << "--line-numbers" << "--inline-source"
  task.rdoc_files.include('README', 'lib/**/*.rb')
end

desc "Generate README"
task :readme do
  %x[erb README_TEMPLATE > README]
end


desc "Upload RDoc to RubyForge"
task :publish_rdoc do
  Rake::Task[:readme].invoke
  Rake::Task[:rdoc].invoke
  Rake::SshDirPublisher.new("jaycfields@rubyforge.org", "/var/www/gforge-projects/expectations", "doc").upload
end

Gem::manage_gems

specification = Gem::Specification.new do |s|
  s.name   = "expectations"
  s.summary = "A lightweight unit testing framework. Tests (expectations) will be written as follows 
  expect 2 do 
    1 + 1 
  end 

  expect NoMethodError do 
    Object.invalid_method_call 
  end."
  s.version = "1.0.0"
  s.author = 'Jay Fields'
  s.description = "A lightweight unit testing framework. Tests (expectations) will be written as follows 
  expect 2 do 
    1 + 1 
  end 

  expect NoMethodError do 
    Object.invalid_method_call 
  end."
  s.homepage = 'http://expectations.rubyforge.org'
  s.rubyforge_project = 'expectations'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README']
  s.rdoc_options << '--title' << 'expectations' << '--main' << 'README' << '--line-numbers'

  s.email = 'ruby@jayfields.com'
  s.files = FileList['{lib,test}/**/*.rb', '[A-Z]*$', 'rakefile.rb'].to_a
  s.add_dependency('mocha', '>= 0.5.5')
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = false
end

# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'jeweler'

$:.unshift(File.expand_path('../lib', __FILE__))

require 'cutter'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "cutter"
  gem.homepage = "http://github.com/stanislaw/cutter"
  gem.license = "MIT"
  gem.summary = %Q{Ruby tracing gem}
  gem.description = %Q{Ruby tracing gem}
  gem.email = "s.pankevich@gmail.com"
  gem.authors = ["stanislaw"]
  gem.files = Dir["{lib}/**/*"]
  gem.version = Cutter::VERSION
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

desc "Run demos"
task :demo do
  system %[ bundle exec rspec spec/demo/*.rb ]
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cutter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

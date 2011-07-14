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
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "drymon_tng"
  gem.homepage = "http://github.com/yuuna/drymon_tng"
  gem.license = "MIT"
  gem.summary = %Q{drymong,the next generation}
  gem.description = %Q{testing tool for openpne v3}
  gem.email = "yuuna.m@gmail.com"
  gem.authors = ["Yuuna Kurita"]
  # dependencies defined in Gemfile
  gem.bindir = 'bin'
  gem.executables  << 'drymon-tng-openpne-fixture-gen' << 'drymon-tng-openpne-gen' << 'drymon-tng-lime' << 'drymon-tng-selenium' << 'drymon-tng-config-gen' << 'drymon-tng-openpne-table'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/task'

#Rake::RDocTask.new do |rdoc|
#  version = File.exist?('VERSION') ? File.read('VERSION') : ""
#
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title = "drymon_tng #{version}"
#  rdoc.rdoc_files.include('README*')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end

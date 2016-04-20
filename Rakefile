#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

task default: [:ci]

require 'rspec/core/rake_task'
require 'engine_cart/rake_task'
require 'rubocop/rake_task'

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

RSpec::Core::RakeTask.new(:spec)

desc 'Start solr, fcrepo, and run specs'
task ci: ['rubocop', 'engine_cart:generate'] do
  Rake::Task['spec'].invoke
end

#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

ENV["RAILS_ROOT"] ||= 'spec/internal'

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec => :generate) do |t|
      t.rspec_opts = "--colour"
end


describe "Create the test rails app"
task :generate do
  unless File.exists?('spec/internal/Rakefile')
    puts "Generating rails app"
    `rails new spec/internal`
    puts "Copying gemfile"
    `cp spec/support/Gemfile spec/internal`
    puts "Copying generator"
    `cp -r spec/support/lib/generators spec/internal/lib`

    FileUtils.cd('spec/internal')
    puts "Bundle install"
    `bundle install`
    puts "running generator"
    puts `rails generate test_app`

    puts "running migrations"
    puts `rake db:migrate db:test:prepare`
    FileUtils.cd('../..')
  end
  puts "Running specs"
end

describe "Clean out the test rails app"
task :clean do
  puts "Removing sample rails app"
  `rm -rf spec/internal`
end

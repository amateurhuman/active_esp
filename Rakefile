#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task :default => :spec

desc 'Execute a console with the environment preloaded'
task :console do
  exec 'irb -rubygems -I lib -r active_esp.rb'
end

namespace :docs do
  task :generate do
    exec 'yard doc'
  end

  task :server do
    exec 'yard server --reload --server thin'
  end

  task :stats do
    exec 'yard stats'
  end
end
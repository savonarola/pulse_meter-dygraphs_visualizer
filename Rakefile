#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'coffee-script'
require 'listen'
require 'rspec/core/rake_task'
require 'sprockets'
require 'tilt'
require 'yard'
require 'yard/rake/yardoc_task'

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new(:yard)

ROOT = File.dirname(__FILE__)

task :default => :spec

namespace :coffee do
  COFFEE_PATH = "#{ROOT}/lib/pulse_meter/dygraphs_visualize/coffee"
  JS_PATH = "#{ROOT}/lib/pulse_meter/dygraphs_visualize/js"

  def compile_js
    Tilt::CoffeeScriptTemplate.default_bare = true
    env = Sprockets::Environment.new
    env.append_path COFFEE_PATH
    env.append_path JS_PATH
    data = env['application.coffee']
    open("#{ROOT}/lib/pulse_meter/dygraphs_visualize/public/js/application.js", "w").write(data)
    puts "application.js compiled"
  end

  desc "Compile coffee to js"
  task :compile do
    compile_js
  end

  desc "Watch coffee files and recomplile them immediately"
  task :watch do
    Listen.to(COFFEE_PATH) do |modified, added, removed|
      puts "Modified: #{modified}" unless modified.empty?
      puts "Added: #{added}" unless added.empty?
      puts "Removed: #{removed}" unless removed.empty?
      puts "Recompiling..."
      compile_js
    end
  end
end

namespace :yard do
  desc "Open doc index in a browser"
  task :open do
    system 'open', "#{ROOT}/doc/index.html"
  end
end


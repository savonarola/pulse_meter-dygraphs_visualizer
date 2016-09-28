#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'listen'
require 'rspec/core/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new(:yard)

task :default => :spec

STDOUT.sync = true

namespace :coffee do
  COFFEE_PATH = "lib/pulse_meter/dygraphs_visualize/coffee"
  COFFEE_FILES = %w{
    extensions
    models/page_info
    models/widget
    models/dinamic_widget
    models/sensor_info
    collections/page_info_list
    collections/sensor_info_list
    collections/widget_list
    presenters/widget
    presenters/timeline
    presenters/series
    presenters/line
    presenters/stack
    views/page_title
    views/page_titles
    views/sensor_info_list
    views/dynamic_chart
    views/dynamic_widget
    views/widget_chart
    views/widget
    views/widget_list
    router
    application
  }.map{|f| "#{COFFEE_PATH}/#{f}.coffee"}.join(" ")
  APP_JS = "lib/pulse_meter/dygraphs_visualize/public/js/application.js"
  COFFEE_SCRIPT = "node_modules/coffee-script/bin/coffee"

  def compile_js
    command = "cat #{COFFEE_FILES} | #{COFFEE_SCRIPT} --compile --bare --stdio > #{APP_JS}"
    puts "running #{command}"
    system(command)
    puts "application.js compiled"
  end

  desc "Compile coffee to js"
  task :compile do
    compile_js
  end

  desc "Watch coffee files and recomplile them immediately"
  task :watch do
    listener = Listen.to(COFFEE_PATH) do |modified, added, removed|
      puts "Modified: #{modified}" unless modified.empty?
      puts "Added: #{added}" unless added.empty?
      puts "Removed: #{removed}" unless removed.empty?
      puts "Recompiling..."
      compile_js
    end
    listener.start
    sleep
  end
end

namespace :yard do
  desc "Open doc index in a browser"
  task :open do
    system 'open', "#{ROOT}/doc/index.html"
  end
end

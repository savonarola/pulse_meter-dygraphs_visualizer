#!/usr/bin/env rake
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

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
  COFFEE = "node_modules/coffee-script/bin/coffee"

  file COFFEE do
    puts "Running npm install"
    system "npm install" or raise "npm install failed"
  end

  desc "Compile coffee to js"
  task :compile => [COFFEE] do
    command = "cat #{COFFEE_FILES} | #{COFFEE} --compile --bare --stdio > #{APP_JS}"
    puts "running #{command}"
    system(command)
    puts "application.js compiled"
  end

  desc "Watch coffee files and recomplile them immediately"
  task :watch => [:compile] do
    require 'listen'
    STDOUT.sync = true
    listener = Listen.to(COFFEE_PATH) do |modified, added, removed|
      puts "Modified: #{modified}" unless modified.empty?
      puts "Added: #{added}" unless added.empty?
      puts "Removed: #{removed}" unless removed.empty?
      puts "Recompiling..."
      Rake::Task["coffee:compile"].execute
    end
    listener.start
    sleep
  end
end

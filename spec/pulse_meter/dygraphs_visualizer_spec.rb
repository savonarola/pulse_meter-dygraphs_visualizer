require 'spec_helper'

describe PulseMeter::DygraphsVisualizer do
  describe "::draw" do
    it "should generate correct layout with passed block" do
      layout = described_class.draw do |l|

        l.title "My Gauges"

        l.page "Dashboard" do |p|
          p.line :convertion do |c|
            c.sensor :adv_clicks, color: :green
            c.sensor :adv_shows, color: :red
          end

          p.stack :agents, title: 'User Agents' do |c|
            c.sensor :agent_ie
            c.sensor :agent_chrome
            c.sensor :agent_ff
            c.sensor :agent_other
          end

        end

        l.page "Request stats" do |p|
          p.line :rph_total, sensor: :rph_total
          p.line :rph_main_page, sensor: :rph_main_page
          p.line :request_time_p95_hour
        
          p.stack :success_vs_fail_total_hourly do |w|
            w.sensor :success_total_hourly
            w.sensor :fail_total_hourly
          end

        end

      end
      layout.should be_kind_of(PulseMeter::DygraphsVisualize::Layout)
    end
  end
end


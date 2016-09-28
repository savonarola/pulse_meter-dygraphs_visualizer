$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'pulse_meter_dygraphs_visualizer'

PulseMeter.redis = Redis.new

layout = PulseMeter::DygraphsVisualizer.draw do |l|

  l.title "WunderZoo Stats"

  l.dygraphs_options labels_k_m_b: true

  l.page "Counts" do |p|

    p.line "Lama count" do |c|
      c.sensor :lama_count, color: '#CC1155'
      c.redraw_interval 1
      c.values_label 'Count'
      c.width 5
      c.show_last_point true
      c.timespan 1200
      c.dygraphs_options(
        show_range_selector: true
      )
    end

    p.line "Lama count 1 min" do |c|
      c.sensor :lama_count_1min, color: '#FA295C'
      c.redraw_interval 1
      c.values_label 'Count'
      c.width 5
      c.show_last_point true
      c.timespan 1200
    end

    p.line "Rhino count", sensor: :rhino_count do |c|
      c.redraw_interval 1
      c.values_label 'Count'
      c.width 5
      c.show_last_point true
      c.timespan 1200
    end

    p.line "Rhino & Lama & Goose count comparison" do |c|
      c.redraw_interval 1
      c.values_label 'Count'
      c.width 5
      c.show_last_point true
      c.timespan 1200

      c.sensor :rhino_count, color: '#AAAAAA'
      c.sensor :lama_count, color: '#CC1155'
      c.sensor :goose_count
    end

    p.line "Rhino & Lama & Gooze count comparison" do |c|
      c.redraw_interval 1
      c.values_label 'Count'
      c.width 5
      c.show_last_point false
      c.timespan 1200

      c.sensor :rhino_count, color: '#AAAAAA'
      c.sensor :lama_count, color: '#CC1155'
      c.sensor :goose_count
    end

    p.stack "Rhino & Lama & Goose count comparison" do |c|
      c.redraw_interval 1
      c.values_label 'Count'
      c.width 12
      c.show_last_point true
      c.timespan 1200

      c.sensor :rhino_count, color: '#AAAAAA'
      c.sensor :lama_count, color: '#CC1155'
      c.sensor :goose_count
    end


  end

  l.page "Ages" do |p|

    p.line "Lama average age", sensor: :lama_average_age do |c|
      c.redraw_interval 1
      c.values_label 'Age'
      c.width 5
      c.show_last_point true
      c.timespan 1200
    end

    p.line "Rhino average age", sensor: :rhino_average_age do |c|
      c.redraw_interval 1
      c.values_label 'Age'
      c.width 5
      c.show_last_point true
      c.timespan 1200
    end

    p.line "Rhino & Lama average age comparison" do |c|
      c.redraw_interval 1
      c.values_label 'Age'
      c.width 5
      c.show_last_point true
      c.timespan 1200

      c.sensor :lama_average_age
      c.sensor :rhino_average_age
    end

    p.line "Rhino & Lama average age comparison" do |c|
      c.redraw_interval 1
      c.values_label 'Age'
      c.width 5
      c.show_last_point false
      c.timespan 1200

      c.sensor :lama_average_age
      c.sensor :rhino_average_age
    end

  end

end

run layout.to_app

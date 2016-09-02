require "spec_helper"

describe PulseMeter::DygraphsVisualize::Layout do
  let(:layout) do
    l = PulseMeter::DygraphsVisualize::DSL::Layout.new
    l.page "page1" do |p|
      p.line "w1"
      p.line "w2"
      p.dygraphs_options({a: 1})
    end
    l.page "page2" do |p|
      p.line "w3"
      p.line "w4"
    end
    l.to_data
  end

  describe "#page_infos" do
    it "returns list of page infos with ids" do
      expect(layout.page_infos).to eq([
        {title: "page1", id: 1, dygraphs_options: {a: 1}},
        {title: "page2", id: 2, dygraphs_options: {}}
      ])
    end
  end

  describe "#options" do
    it "returns layout options" do
      ldsl = PulseMeter::DygraphsVisualize::DSL::Layout.new
      ldsl.use_utc true
      ldsl.dygraphs_options({a: 1})
      l = ldsl.to_data
      expect(l.options).to eq({use_utc: true, dygraphs_options: {a: 1}})
    end
  end

  describe "#widget" do
    it "returns data for correct widget" do
      w = layout.widget(1, 0)
      expect(w).to include(id: 1, title: "w3")
      w = layout.widget(0, 1, timespan: 123)
      expect(w).to include(id: 2, title: "w2")
    end
  end

  describe "#widgets" do
    it "returns data for correct widgets of a page" do
      datas = layout.widgets(1)
      expect(datas[0]).to include(id: 1, title: "w3")
      expect(datas[1]).to include(id: 2, title: "w4")
    end
  end

end

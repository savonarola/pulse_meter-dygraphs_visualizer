WidgetChartView = Backbone.View.extend {
	tagName: 'div'
	template: '<div id="chart"></div><div id="legend"></div>'

	initialize: (options) ->
		@$el.html(@template)
		@pageInfos = options['pageInfos']
		@model.bind 'destroy', @remove, this

	updateData: ->
		@presenter.draw()

	render: ->
		@presenter = WidgetPresenter.create(@pageInfos, @model, @$el)
}

class WidgetPresenter
	constructor: (@pageInfos, @model, @el) ->
		@chartEl = @el.find('#chart')[0]
		@legendEl = @el.find('#legend')[0]
		@chart = new Dygraph.GVizChart(@chartEl)
		@draw()

	get: (arg) -> @model.get(arg)

	globalOptions: -> gon.options

	dateOffset: ->
		if @globalOptions.useUtc
			(new Date).getTimezoneOffset() * 60000
		else
			0
	
	options: -> {
		labelsDiv: @legendEl
		labelsSeparateLines: false
		rightGap: 30
	}

	mergedOptions: ->
		pageOptions = if @pageInfos.selected()
			@pageInfos.selected().get('dygraphsOptions')
		else
			{}

		$.extend(true,
			@options(),
			@globalOptions.dygraphsOptions,
			pageOptions,
			@get('dygraphsOptions')
		)

	data: -> new google.visualization.DataTable

	draw: ->
		@chart.draw @data(), @mergedOptions()

WidgetPresenter.create = (pageInfos, model, el) ->
	type = model.get('type')
	if type? && type.match(/^\w+$/)
		presenterClass = eval("#{type.capitalize()}Presenter")
		new presenterClass(pageInfos, model, el)
	else
		null

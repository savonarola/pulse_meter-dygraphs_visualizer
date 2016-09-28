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
		highlightCircleSize: 2

		highlightSeriesOpts:
			strokeWidth: 2
			strokeBorderWidth: 1
			highlightCircleSize: 5

		axisLabelWidth: 80

		axes:
			y:
				valueFormatter: (x) -> x
				axisLabelFormatter: (x) => @formatValueLabel(x)

	}

	mergedOptions: ->
		pageOptions = if @pageInfos.selected()
			@pageInfos.selected().get('dygraphsOptions')
		else
			{}

		$.extend(true,
			@options(),
			@globalOptions().dygraphsOptions,
			pageOptions,
			@get('dygraphsOptions')
		)

	data: -> new google.visualization.DataTable

	formatValueLabel: (v) ->
		sign = if v < 0 then "-" else ""
		absv = Math.abs(v)
		if absv >= 1000000000
			v.toPrecision(4)
		else
			if absv >= 1000000
			 	"#{sign}#{Math.floor(absv / 1000000)}kk"
			else
				if absv >= 1000
					"#{sign}#{Math.floor(absv / 1000)}k"
				else
					v



	draw: ->
		@chart.draw @data(), @mergedOptions()

WidgetPresenter.create = (pageInfos, model, el) ->
	type = model.get('type')
	if type? && type.match(/^\w+$/)
		presenterClass = eval("#{type.capitalize()}Presenter")
		new presenterClass(pageInfos, model, el)
	else
		null

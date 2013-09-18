WidgetView = Backbone.View.extend {
	tagName: 'div'

	template: (args) ->
		_.template($(".widget-template[data-widget-type=\"#{@model.get('type')}\"]").html())(args)

	initialize: (options) ->
		@pageInfos = options['pageInfos']
		@model.bind('destroy', @remove, this)
		@model.bind('redraw', @updateChart, this)

	events: {
		"click #refresh": 'refresh'
		"click #need-refresh": 'setRefresh'
		"click #extend-timespan": 'extendTimespan'
		"click #reset-timespan": 'resetTimespan'
		"change #start-time input": 'maybeEnableStopTime'
		"click #set-interval": 'setTimelineInterval'
	}

	refresh: ->
		@model.forceUpdate()

	setRefresh: ->
		needRefresh = @$el.find('#need-refresh').is(":checked")
		@model.setRefresh(needRefresh)
		true

	extendTimespan: ->
		select = @$el.find("#extend-timespan-val")
		val = select.first().val()
		@model.increaseTimespan(parseInt(val))

	setTimelineInterval: ->
		start = @unixtimeFromDatepicker("#start-time input")
		end = @unixtimeFromDatepicker("#end-time input")
		@model.setStartTime(start)
		@model.setEndTime(end)

	maybeEnableStopTime: ->
		date = @dateFromDatepicker("#start-time input")
		disabled = if date then false else true
		@$el.find("#end-time input").prop("disabled", disabled)

	resetTimespan: ->
		@model.resetTimespan()

	renderChart: ->
		@chartView.render()

	updateChart: ->
		@chartView.updateData(@cutoffMin(), @cutoffMax())

	setIds: ->
		@$el.find('#configure-button').prop('href', "#configure-#{@model.id}")
		@$el.find('#configure').attr('id', "configure-#{@model.id}")
		@$el.find('#start-time input').attr('id', "start-time-#{@model.id}")
		@$el.find('#end-time input').attr('id', "end-time-#{@model.id}")

	render: ->
		@$el.html @template(@model.toJSON())
		@setIds()
		@chartView = new WidgetChartView {
			pageInfos: @pageInfos
			model: @model
		}
		@$el.find("#plotarea").append(@chartView.el)
		@$el.addClass("span#{@model.get('width')}")
		@initDatePickers()
	
	initDatePickers: ->
		@$el.find(".datepicker").each (i) ->
			$(this).datetimepicker
				showOtherMonths: true
				selectOtherMonths: true
		@$el.find("#end-time input").prop("disabled", true)

	cutoffMin: ->
		val = parseFloat(@controlValue('#cutoff-min'))
		if _.isNaN(val) then null else val

	cutoffMax: ->
		val = parseFloat(@controlValue('#cutoff-max'))
		if _.isNaN(val) then null else val

	controlValue: (id) ->
		val = @$el.find(id).first().val()

	dateFromDatepicker: (id) ->
		@$el.find(id).datetimepicker("getDate")

	unixtimeFromDatepicker: (id) ->
		date = @dateFromDatepicker(id)
		if date
			date.getTime() / 1000
		else
			null

}

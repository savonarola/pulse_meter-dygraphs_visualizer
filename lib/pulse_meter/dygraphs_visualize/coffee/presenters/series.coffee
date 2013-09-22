class SeriesPresenter extends TimelinePresenter
	options: ->
		$.extend(true,
			super(),
			{
				title: @get('title')
				legend: 'always'
				height: 300
				ylabel: @valuesTitle()
				colors: @colors()
			}
		)

	valuesTitle: ->
		if @get('valuesTitle')
			"#{@get('valuesTitle')} / #{@humanizedInterval()}"
		else
			@humanizedInterval()

	colors: ->
		_.map @get('series').options, (o) -> o.color


	humanizedInterval: ->
		@get('interval').humanize()
	

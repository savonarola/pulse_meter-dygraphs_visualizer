PageTitle = Backbone.Model.extend {
	defaults: -> {
		title: ""
		selected: false
	}
	initialize: ->
		if !@get('title')
			@set {
				'title': @defaults.title
			}
		@set('selected', @defaults.selected)
	clear: ->
		@destroy()
}

PageTitleList = Backbone.Collection.extend {
	model: PageTitle
	url: ROOT + 'page_titles'

	selectFirst: (args) ->
		@at(0).set('selected', true) if @length > 0

	selectPage: (model) ->
		@each (m) ->
			m.set 'selected', m.id == model.id
			
}

PageTitles = new PageTitleList

PageTitleView = Backbone.View.extend {
	tagName: 'li'
	
	template: _.template('<a href="#"><%= title %></a>')
		
	events: {
		'click': 'selectPage'
	}

	initialize: ->
		@model.bind 'change', @render, this
		@model.bind 'destroy', @remove, this

	render: ->
		@$el.html @template(@model.toJSON())
		if @model.get('selected')
			@$el.addClass('active')
		else
			@$el.removeClass('active')

	selectPage: ->
		PageTitles.selectPage(@model)
}

PageTitlesView = Backbone.View.extend {
	initialize: ->
		PageTitles.bind 'reset', @render, this
		PageTitles.fetch()

	addOne: (page_title) ->
		view = new PageTitleView {
			model: page_title
		}
		view.render()
		@$('#page-titles').append(view.el)

	render: ->
		@$('#page-titles').empty()
		PageTitles.each(@addOne)
		PageTitles.selectFirst()

}

PageTitlesApp = new PageTitlesView

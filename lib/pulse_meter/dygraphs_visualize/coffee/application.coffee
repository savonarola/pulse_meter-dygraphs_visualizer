document.startApp = ->
	pageInfos = new PageInfoList
	pageTitlesApp = new PageTitlesView(pageInfos)
	pageInfos.reset gon.pageInfos

	widgetList = new WidgetList
	widgetList.setContext(pageInfos)
	widgetList.startPolling()

	widgetListApp = new WidgetListView {widgetList: widgetList, pageInfos: pageInfos}

	appRouter = new AppRouter(pageInfos, widgetList)

	Backbone.history.start()

class App.Views.Dashboard extends Backbone.View
  template: JST['application/dashboard']

  id: 'dashboard'

  events:
    'click #sign-out': 'signOut'

  initialize: ->
    @session = @model
    @listenTo(App.EventBus, 'side-nav:gallery', @renderGallery)
    @listenTo(App.EventBus, 'side-nav:designer', @renderDesigner)
    @listenTo(App.EventBus, 'side-nav:content-manager', @renderContentManager)
    @listenTo(App.EventBus, 'side-nav:profile', @renderProfile)

  render: =>
    @$el.html(@template())
    view = new App.Views.SideNav(model: @session)
    @$('#dashboard-side-nav').html(view.render().el)
    @addSubView('dashboard-side-nav', view)
    @renderGallery()
    this

  signOut: ->
    @close()
    @session.destroy
      success: ->
        view = new App.Views.Registration()
        $('#container').html(view.render().el)
      error: ->
        # handle error

  # Delegation of SideNav clicks
  renderGallery: (e) ->
    view = new App.Views.Gallery(model: @session)
    @renderDashboardBody(view)

  renderDesigner: (e) ->
    view = new App.Views.Designer(model: @session)
    @renderDashboardBody(view)

  renderContentManager: (e) ->
    view = new App.Views.ContentManager(model: @session)
    @renderDashboardBody(view)

  renderProfile: (e) ->
    view = new App.Views.Profile(model: @session)
    @renderDashboardBody(view)

  renderDashboardBody: (view) ->
    @$('#dashboard-body').html(view.render().el)
    @addSubView('dashboard-body', view)
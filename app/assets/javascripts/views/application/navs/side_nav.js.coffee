class App.Views.SideNav extends Backbone.View
  template: JST['application/navs/side_nav']

  id: 'side-nav'

  events:
    'click .side-nav-item': 'toggleActiveNav'
    'click #side-nav-gallery': 'renderGallery'
    'click #side-nav-create': 'renderCreate'
    'click #side-nav-content': 'renderContent'
    'click #side-nav-profile': 'renderProfile'
    
  initialize: ->
    @session = @model

  render: ->
    @$el.html(@template())
    @$('#side-nav-gallery').addClass('active')
    this

  toggleActiveNav: (e) ->
    @$('.side-nav-item').removeClass('active')
    @$(e.currentTarget).addClass('active')

  renderGallery: (e) ->
    view = new App.Views.Gallery(model: @session)
    @renderDashboardBody(view)

  renderCreate: (e) ->
    view = new App.Views.Create()
    @renderDashboardBody(view)

  renderContent: (e) ->
    view = new App.Views.Content(model: @session)
    @renderDashboardBody(view)

  renderProfile: (e) ->
    view = new App.Views.Profile(model: @session)
    @renderDashboardBody(view)

  renderDashboardBody: (view) ->
    $('#dashboard-body').html(view.render().el)
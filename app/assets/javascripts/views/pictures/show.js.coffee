class App.Views.PicturesShow extends Backbone.View
  template: JST['pictures/show']

  tagName: 'li'

  events:
    'click': 'selectPicture'
    'click': 'renderEditDialog'

  initialize: ->
    @listenTo(@model, 'destroy', @removeView)

  render: ->
    @$el.html(@template(model: @model))
    this

  #### SubViewAction: edit ####
  # Methods related to opening a dialog to edit this picture.
  renderEditDialog: (e) =>
    view = new App.Views.PicturesEdit(model: @model)
    $(view.render().el).dialog(
      resizable: true
      show: { effect: 'fade', duration: 200 }
      hide: { effect: 'fade', duration: 150 }
      modal: true
      width: 500

      close: ->
        $(this).remove()
    )

  removeView: (e) ->
    @el.remove()

  #### SubViewAction: select ####
  # Methods related to selecting this picture from the list.
  # Use .radio-buttons and .selected classes to gain implied behavior
  selectPicture: (e) =>
    @deselectSelectedPictures() if @isRadioButton()
    @togglePicture()

  togglePicture: =>
    @$('img').toggleClass('selected')
    @$('input[type=checkbox]')[0].checked = @$('img').hasClass('selected')

  isRadioButton: ->
    return ($('.radio-buttons')[0] && $.contains($('.radio-buttons')[0], @el))

  deselectSelectedPictures: ->
    $('.radio-buttons .selected').removeClass('selected')
    checkedCheckboxes = _.remove($('.radio-buttons input[type=checkbox]'), 'checked')
    _.forEach(checkedCheckboxes, @uncheckCheckbox)

  uncheckCheckbox: (checkbox) =>
    $(checkbox)[0].checked = false
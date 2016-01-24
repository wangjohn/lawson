Template.modal_book_tee_time.helpers
  timestamp: ->
    data = Session.get("modal_book_tee_time_data") || {}
    data.timestamp
  teeTime: ->
    data = Session.get("modal_book_tee_time_data") || {}
    if data.timestamp
      Helpers.getTeeTime(new Date(data.timestamp))

Template.modal_book_tee_time.rendered = ->
  @$(".ui.checkbox").checkbox({
    onChange: =>
      $(".num-guests-field").toggleClass("hidden-field")
  })
  @$(".ui.dropdown").dropdown()

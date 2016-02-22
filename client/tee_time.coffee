Template.tee_time.events
  "click .open-cancel-tee-time": (evt) ->
    Helpers.openCancelTeeTimeModal(@teeTime.time.getTime())

  "click .open-book-tee-time": (evt) ->
    data =
      timestamp: @teeTime.time.getTime()
    Session.set("book_tee_time_data", data)
    Router.go("/book")

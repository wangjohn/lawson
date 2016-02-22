Template.tee_time.helpers
  "numCards": (context) ->
    if context?.hideInfoCard then "four" else "five"

Template.tee_time_information_card.events
  "click .open-cancel-tee-time": (evt) ->
    Helpers.openCancelTeeTimeModal(@teeTime.time.getTime())

  "click .open-book-tee-time": (evt) ->
    data = {timestamp: @teeTime.time.getTime()}
    Session.set("book_tee_time_data", data)
    Router.go("/book")

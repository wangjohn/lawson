Template.available_player_card_bookable_image.rendered = ->
  @$(".image.dimmable").dimmer({on: "hover"})

Template.player_card.rendered = ->
  @$(".image.dimmable").dimmer({on: "hover"})

Template.available_player_card_bookable_image.events
  "click .open-book-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    data =
      timestamp: parseInt(timestampStr, 10)
      userId: Meteor.userId()
    Session.set("modal_book_tee_time_data", data)
    Router.go("/book")
    #Helpers.openBookTeeTimeModal(parseInt(timestampStr, 10))

Template.player_card.events
  "click .open-cancel-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    Helpers.openCancelTeeTimeModal(parseInt(timestampStr, 10))

Template.player_card.helpers
  blurrableClass: (canCancel) ->
    if canCancel
      "blurring dimmable"

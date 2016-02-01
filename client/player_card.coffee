Template.available_player_card.onRendered ->
  @$(".image").dimmer({on: "hover"})

Template.player_card.onRendered ->
  @$(".image.dimmable").dimmer({on: "hover"})

Template.available_player_card.events
  "click .open-book-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    Helpers.openBookTeeTimeModal(parseInt(timestampStr, 10))

Template.player_card.events
  "click .open-cancel-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    Helpers.openCancelTeeTimeModal(parseInt(timestampStr, 10))

Template.player_card.helpers
  blurrableClass: (showCancel) ->
    if showCancel
      "blurring dimmable"

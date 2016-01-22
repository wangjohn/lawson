Template.tee_times.rendered = ->
  $("#tee-times-menu").visibility({
    type: "fixed",
    offset: 15,
  })

  #TODO: figure out how to wait for the real height to come to the element
  setTimeout ->
    controller = new ScrollMagic.Controller({globalSceneOptions: {}})
    $("#tee-times-menu .menu .item").each (i, elem) ->
      dateData = $(elem).attr("id")
      matchedData = dateData.match(/menu-item-(.*)/)
      if matchedData and matchedData.length >= 2
        day = matchedData[1]
        teeTimeSelector = "#tee-times-#{day}"
        height = $(teeTimeSelector).height()
        new ScrollMagic.Scene({triggerElement: teeTimeSelector, triggerHook: 0, duration: height})
          .setClassToggle("#menu-item-#{day}", "active")
          .addTo(controller)
  , 500

Template.available_player_card.onRendered ->
  @$(".image").dimmer({on: "hover"})

Template.player_card.onRendered ->
  @$(".image").dimmer({on: "hover"})

Template.available_player_card.events
  "click .open-book-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    timestamp = parseInt(timestampStr, 10)
    userId = Meteor.userId()
    bookTeeTime(timestamp, userId)

Template.player_card.events
  "click .open-cancel-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    Helpers.openCancelTeeTimeModal(parseInt(timestampStr, 10), Meteor.userId())

Template.tee_times.helpers
  dateData: ->
    dates = Helpers.getNextDays()
    result = []
    for date in dates
      result.push
        date: date
        teeTimes: Helpers.getTeeTimes(date)
    result

  menuData: ->
    Helpers.getNextWeeks()

bookTeeTime = (timestamp, userId) ->
  teeTime = Helpers.getTeeTime(new Date(timestamp))
  Meteor.call("bookTeeTime", Meteor.userId(), teeTime._id)

cancelTeeTime = (timestamp, userId) ->
  teeTime = Helpers.getTeeTime(new Date(timestamp))
  Meteor.call("cancelTeeTime", Meteor.userId(), teeTime._id)

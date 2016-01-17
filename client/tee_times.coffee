Template.tee_times.onRendered ->
  controller = new ScrollMagic.Controller({globalSceneOptions: {duration: 100}})
  @$(".menu a.item").each (i, elem) ->
    dateData = $(elem).attr("id")
    matchedData = dateData.match(/menu-item-(.*)/)
    if matchedData and matchedData.length >= 2
      day = matchedData[1]
      new ScrollMagic.Scene({triggerElement: "#tee-times-#{day}", triggerHook: 0})
        .setClassToggle("#menu-item-#{day}", "active")
        .addIndicators()
        .addTo(controller)

  new ScrollMagic.Scene({triggerElement: "#tee-times-list", duration: 200, triggerHook: 0})
    .addTo(controller)
    .on("progress", (e) ->
      if e.progress > 0
        $("#tee-times-menu").addClass("sticky-fixed")
      else
        $("#tee-times-menu").removeClass("sticky-fixed")
    )

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
    timestamp = parseInt(timestampStr, 10)
    userId = Meteor.userId()
    cancelTeeTime(timestamp, userId)

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

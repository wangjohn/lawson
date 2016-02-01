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

Template.tee_time_list.helpers
  teeTimeData: (teeTime) ->
    Helpers.teeTimeData(teeTime)

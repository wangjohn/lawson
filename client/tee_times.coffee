Template.tee_times.helpers
  dateData: ->
    dates = Helpers.getNextDays()
    result = []
    for date in dates
      result.push
        date: date
        teeTimes: [1,2]
    result

  menuData: ->
    Helpers.getNextWeeks()

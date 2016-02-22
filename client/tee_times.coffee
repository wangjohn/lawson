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

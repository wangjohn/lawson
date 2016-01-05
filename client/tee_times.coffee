Template.tee_times.helpers
  dateData: ->
    dates = Helpers.getNextDays(new Date())
    result = []
    for date in dates
      result.push
        date: date
        teeTimes: [1,2]
    result

  menuData: ->
    dates = Helpers.getNextDays(new Date())
    weeks = []
    for date in dates
      currentWeek = moment(Helpers.getMonday(date)).format("M/D/YYYY")
      if weeks[weeks.length-1]?.currentWeek == currentWeek
        weekObject = weeks[weeks.length-1]
      else
        weekObject = {currentWeek: currentWeek, dates: []}
        weeks.push(weekObject)
      weekObject.dates.push(date)
    weeks

DAYS_AVAILABLE = 14

Template.tee_times.helpers
  dateData: ->
    dates = getNextDays(DAYS_AVAILABLE)
    result = []
    for date in dates
      result.push
        date: date
        teeTimes: [1,2]
    result

  menuData: ->
    dates = getNextDays(DAYS_AVAILABLE)
    weeks = []
    for date in dates
      currentWeek = moment(date).format("w YYYY")
      if weeks[weeks.length-1]?.currentWeek == currentWeek
        weekObject = weeks[weeks.length-1]
      else
        weekObject = {currentWeek: currentWeek, dates: []}
        weeks.push(weekObject)
      weekObject.dates.push(date)
    weeks

getNextDays = (daysForward) ->
  result = [new Date()]
  today = Date.now()
  i = 0
  while i < daysForward
    i += 1
    nextDay = today + (1000*60*60*24 * i)
    result.push(new Date(nextDay))
  result

DAYS_AVAILABLE = 14

Template.tee_times.helpers
  dateData: ->
    dates = getNextDays(DAYS_AVAILABLE)
    result = []
    for date in dates
      result.push
        date: moment(date).format("dddd, MMM Do YYYY")
        teeTimes: [1,2]
    result

getNextDays = (daysForward) ->
  result = [new Date()]
  today = Date.now()
  i = 0
  while i < daysForward
    i += 1
    nextDay = today + (1000*60*60*24 * i)
    result.push(new Date(nextDay))
  result

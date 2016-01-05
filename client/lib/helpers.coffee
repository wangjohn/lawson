FUTURE_DAYS_AVAILABLE = 14

class Helpers
  getMonday: (date) ->
    day = date.getDay()
    if day == 0
      diff = 8
    else
      diff = (day + 1)
    new Date(date - 1000*60*60*24*diff)

  getNextDays: (date) ->
    result = [date]
    i = 0
    while i < FUTURE_DAYS_AVAILABLE
      i += 1
      nextTimestamp = date.getTime() + (1000*60*60*24 * i)
      result.push(new Date(nextTimestamp))
    result

@Helpers = new Helpers()

FUTURE_DAYS_AVAILABLE = 14

getMonday = (date) ->
  day = date.getDay()
  if day == 0
    diff = 8
  else
    diff = (day + 1)
  new Date(date - 1000*60*60*24*diff)

class Helpers
  getNextDays: (date) ->
    date ||= new Date()
    result = [date]
    i = 0
    while i < FUTURE_DAYS_AVAILABLE
      i += 1
      nextTimestamp = date.getTime() + (1000*60*60*24 * i)
      result.push(new Date(nextTimestamp))
    result

  getNextWeeks: (startDate) =>
    dates = @getNextDays(startDate)
    weeks = []
    for date in dates
      currentWeek = moment(getMonday(date)).format("M/D/YYYY")
      if weeks[weeks.length-1]?.currentWeek == currentWeek
        weekObject = weeks[weeks.length-1]
      else
        weekObject = {currentWeek: currentWeek, dates: []}
        weeks.push(weekObject)
      weekObject.dates.push(date)
    weeks

  getTeeTimes: (date) ->
    dayStart = moment(date).hour(0).minute(0).second(0).millisecond(0)
    dayEnd = moment(dayStart).add(1, 'days')
    TeeTimes.find({time: {"$gte": dayStart.toDate(), "$lt": dayEnd.toDate()}})

  getTeeTime: (date) ->
    TeeTimes.findOne({time: date})

@Helpers = new Helpers()

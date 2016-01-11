Template.reservations.helpers
  reservedTeeTimes: ->
    teeTimes = Helpers.getUserTeeTimes(Meteor.userId())
    dates = {}
    for teeTime in teeTimes.fetch()
      currentDay = moment(teeTime.time).hour(0).minute(0).second(0).millisecond(0)
      timestamp = currentDay.toDate().getTime()
      dates[timestamp] ||= []
      dates[timestamp].push(teeTime)

    result = []
    for timestamp, teeTimes of dates
      result.push
        date: new Date(parseInt(timestamp, 10))
        teeTimes: teeTimes
    result.sort (a, b) ->
      a.date.getTime() - b.date.getTime()
    result

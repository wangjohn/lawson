Template.add_tee_times.helpers
  scheduledTeeTimes: ->
    weekData = Helpers.getNextWeeks()
    for week in weekData
      dateData = []
      for date in week.dates
        teeTimes = Helpers.getTeeTimes(date)
        dateData.push
          date: date
          timestamp: date.getTime()
          teeTimes: teeTimes
      week.dateData = dateData
    weekData

Template.add_tee_times.events
  "click .open-tee-time": (evt) ->
    $hiddenMessage = $(evt.currentTarget).closest("tr").next()
    $hiddenMessage.toggleClass("hidden")

  "click .add-tee-time .submit": (evt) ->
    evt.preventDefault()
    $form = $(evt.currentTarget).closest(".add-tee-time")
    addTeeTime($form)

addTeeTime = ($form) ->
  dateTimestamp = parseInt($form.attr("data-timestamp"), 10)
  timeHour = parseInt($form.find("input[name='time-hour']").val(), 10)
  timeMinute = parseInt($form.find("input[name='time-minute']").val(), 10)
  spots = parseInt($form.find("select[name='spots']").val(), 10)
  date = moment(dateTimestamp).hour(timeHour).minute(timeMinute).second(0)
  teeTimeData =
    createdAt: new Date()
    time: date.toDate()
    potentialSpots: spots
    reservedPlayers: []
  TeeTimes.insert(teeTimeData)

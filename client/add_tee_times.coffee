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
    time = $form.find("input[name='time']").val()
    spots = $form.find("select[name='spots']").val()
    console.log(time, spots)

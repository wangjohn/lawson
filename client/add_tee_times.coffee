Template.add_tee_times.helpers
  scheduledTeeTimes: ->
    weekData = Helpers.getNextWeeks()
    for week in weekData
      dateData = []
      for date in week.dates
        teeTimes = Helpers.getTeeTimes(date)
        dateData.push
          date: date
          teeTimes: teeTimes
      week.dateData = dateData
    weekData

Template.add_tee_times.events
  "click .open-tee-time": (evt) ->
    toggleTeeIcons(evt.currentTarget)
    $hiddenMessage = $(evt.currentTarget).closest("tr").next()
    $hiddenMessage.removeClass("hidden")

  "click .close-tee-time": (evt) ->
    toggleTeeIcons(evt.currentTarget)
    $hiddenMessage = $(evt.currentTarget).closest("tr").next()
    $hiddenMessage.addClass("hidden")

  "click .add-tee-time .submit": (evt) ->
    evt.preventDefault()
    $form = $(evt.currentTarget).closest(".add-tee-time")
    addTeeTime($form)

  "click .remove-tee-time": (evt) ->
    teeTimeId = $(evt.currentTarget).closest("tr").attr("data-id")
    Meteor.call("removeTeeTime", teeTimeId)

toggleTeeIcons = (target) ->
  $tr = $(target).closest("tr")
  $tr.find(".open-tee-time").toggleClass("hidden-field")
  $tr.find(".close-tee-time").toggleClass("hidden-field")

addTeeTime = ($form) ->
  dateTimestamp = parseInt($form.attr("data-timestamp"), 10)
  timeHour = parseInt($form.find("select[name='time-hour']").val(), 10)
  timeMinute = parseInt($form.find("select[name='time-minute']").val(), 10)
  timePeriod = $form.find("select[name='time-period']").val()
  if timePeriod == "pm" and timeHour != 12
    timeHour += 12
  else if timePeriod == "am" and timeHour == 12
    timeHour = 0
  spots = parseInt($form.find("select[name='spots']").val(), 10)
  date = moment(dateTimestamp).hour(timeHour).minute(timeMinute).second(0).millisecond(0)
  Meteor.call("createTeeTime", date.toDate(), spots)

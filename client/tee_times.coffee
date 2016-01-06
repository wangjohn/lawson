Template.tee_times.rendered = ->
  $(".tee-times .image").dimmer({on: "hover"})

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

Template.tee_times.events
  "click .open-book-tee-time": (evt) ->
    timestampStr = $(evt.currentTarget).closest(".item").attr("data-timestamp")
    timestamp = parseInt(timestampStr, 10)
    userId = Meteor.userId()
    bookTeeTime(timestamp, userId)

bookTeeTime = (timestamp, userId) ->
  teeTime = Helpers.getTeeTime(new Date(timestamp))
  TeeTimes.update(teeTime._id, {
    $push: {reservedPlayers: userId}
  })

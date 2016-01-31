FUTURE_DAYS_AVAILABLE = 14

getMonday = (date) ->
  day = date.getDay()
  if day == 0
    diff = 6
  else
    diff = (day - 1)
  new Date(date - 1000*60*60*24*diff)

openModal = (selector, onApprove, opts = {}) ->
  $(selector)
    .modal("setting", "transition", opts.transition || "horizontal flip")
    .modal({onApprove: onApprove})
    .modal("show")

class Helpers
  openBookTeeTimeModal: (timestamp) =>
    data =
      timestamp: timestamp
      userId: Meteor.userId()
    Session.set("modal_book_tee_time_data", data)
    onApprove = =>
      data = Session.get("modal_book_tee_time_data") || {}
      teeTime = @getTeeTime(new Date(data.timestamp))
      players = [{userId: Meteor.userId(), isGuest: false}]
      if $(".include-golfers").checkbox("is checked")
        $(".golfer-details").each (i, elem) ->
          $el = $(elem)
          isMember = $el.find(".is-member").checkbox("is checked")
          if isMember
            userId = $el.find(".select-member").dropdown("get value")
            players.push({userId: userId, isGuest: false})
          else
            name = $el.find("input[name='guest-name']").val()
            players.push({userId: Meteor.userId(), isGuest: true, name: name})
      Meteor.call "bookTeeTime", teeTime._id, players
    openModal(".book-tee-time.modal", onApprove)

  openCancelTeeTimeModal: (timestamp) ->
    data =
      timestamp: timestamp
      userId: Meteor.userId()
    Session.set("modal_cancel_tee_time_data", data)
    onApprove = =>
      teeTime = @getTeeTime(new Date(data.timestamp))
      Meteor.call("cancelTeeTime", data.userId, teeTime._id)
    openModal(".cancel-tee-time.modal", onApprove)

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
    TeeTimes.find({time: {"$gte": dayStart.toDate(), "$lt": dayEnd.toDate()}}, {sort: {time: 1}})

  getTeeTime: (date) ->
    TeeTimes.findOne({time: date})

  getUserTeeTimes: (userId) ->
    TeeTimes.find({"reservedPlayers.userId": userId})

  getUserDetails: (userId) ->
    details = UserDetails.findOne({userId: userId})
    if details
      details.profileImage = Images.findOne({_id: details.profileImageId})
      details

@Helpers = new Helpers()

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
  teeTimeData: (teeTime, options = {}) =>
    return unless teeTime
    availableSpots = teeTime.potentialSpots - teeTime.reservedPlayers.length
    data = []
    reservedPlayers = _.sortBy teeTime.reservedPlayers, (player) ->
      if player.userId == Meteor.userId() then 0 else 1

    for player in reservedPlayers
      playerDetails = @getUserDetails(player.userId)
      if player.isGuest
        fullName = player.name
      else
        fullName = "#{playerDetails?.firstName} #{playerDetails?.lastName}"
      if "canCancel" of options
        canCancel = options["canCancel"]
      else
        canCancel = player.userId and player.userId == Meteor.userId()
      data.push
        isReserved: true
        isGuest: player.isGuest
        player: playerDetails
        name: fullName
        canCancel: canCancel

    if "canBook" of options
      canBook = options["canBook"]
    else
      canBook = !_.some(reservedPlayers, (player) -> player.userId == Meteor.userId())

    for i in [0...availableSpots]
      data.push
        isReserved: false
        canBook: canBook

    result =
      data: data
      teeTime: teeTime
    result

  harvestTeeTimePlayers: =>
    players = [{userId: Meteor.userId(), isGuest: false}]
    if $(".include-golfers").checkbox("is checked")
      $(".golfer-details").each (i, elem) ->
        $el = $(elem)
        isMember = $el.find(".is-member").checkbox("is checked")
        if isMember
          userId = $el.find(".select-member").dropdown("get value")
          if typeof userId == 'string'
            players.push({userId: userId, isGuest: false})
        else
          name = $el.find("input[name='guest-name']").val()
          players.push({userId: Meteor.userId(), isGuest: true, name: name})
    players

  openBookTeeTimeModal: (timestamp) =>
    data =
      timestamp: timestamp
      userId: Meteor.userId()
    Session.set("modal_book_tee_time_data", data)
    onApprove = =>
      data = Session.get("modal_book_tee_time_data") || {}
      teeTime = @getTeeTime(new Date(data.timestamp))
      players = @harvestTeeTimePlayers()
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

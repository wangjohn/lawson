FUTURE_DAYS_AVAILABLE = 14

getMonday = (date) ->
  day = date.getDay()
  if day == 0
    diff = 6
  else
    diff = (day - 1)
  new Date(date - 1000*60*60*24*diff)

templateAttach = (template, callback, data) ->
  if typeof template == "string"
    template = Template[template]
  return false if not template
  if (data)
    instance = Blaze.renderWithData(template, data, document.body)
  else
    instance = Blaze.render(template, document.body)
  return callback && callback.call(this, instance)

openModal = (template, selector, onApprove, data) ->
  instanceCallback = (instance) =>
    $(selector)
      .modal("setting", "transition", "horizontal flip")
      .modal({onApprove: onApprove})
      .modal("show")
  if $(selector).length == 0
    templateAttach(Template.modal_cancel_tee_time, instanceCallback, data)
  else
    instanceCallback()

class Helpers
  teeTimeData: (teeTime, options = {}) =>
    return unless teeTime
    data = []
    reservedPlayers = options.reservedPlayers || teeTime.reservedPlayers
    reservedPlayers = _.sortBy reservedPlayers, (player) ->
      if player.userId == Meteor.userId() then 0 else 1
    availableSpots = teeTime.potentialSpots - reservedPlayers.length

    for player in reservedPlayers
      playerDetails = @getUserDetails(player.userId)
      if player.isGuest
        fullName = player.name
      else
        fullName = "#{playerDetails?.firstName} #{playerDetails?.lastName}"
      data.push
        isReserved: true
        isGuest: player.isGuest
        player: playerDetails
        name: fullName

    for i in [0...availableSpots]
      data.push
        isReserved: false

    if "canBook" of options
      canBook = options["canBook"]
    else
      canBook = !_.some(reservedPlayers, (player) -> player.userId == Meteor.userId())
    result =
      data: data
      canBook: canBook
      teeTime: teeTime
    result

  harvestTeeTimePlayers: =>
    players = [{userId: Meteor.userId(), isGuest: false}]
    isChecked = $(".include-additional-golfers").checkbox("is checked")
    if isChecked
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

  openCancelTeeTimeModal: (timestamp) ->
    data =
      timestamp: timestamp
    Session.set("modal_cancel_tee_time_data", data)
    onApprove = =>
      teeTime = @getTeeTime(new Date(data.timestamp))
      Meteor.call("cancelTeeTime", Meteor.userId(), teeTime._id)
    openModal(Template.modal_cancel_tee_time, ".modal.cancel-tee-time", onApprove)

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

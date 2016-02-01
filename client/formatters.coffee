UI.registerHelper "formatDate", (context, options) ->
  if context
    moment(context).format("MM-DD-YYYY")

UI.registerHelper "formatDay", (context, options) ->
  if context
    moment(context).format("dddd, MMM Do YYYY")

UI.registerHelper "formatTime", (context, options) ->
  if context
    moment(context).format("h:mm A")

UI.registerHelper "formatTimestamp", (context, options) ->
  if context
    context.getTime()

UI.registerHelper "findLength", (context, options) ->
  if context
    context.length

UI.registerHelper "playerData", (context, options) ->
  if context
    availableSpots = context.potentialSpots - context.reservedPlayers.length
    data = []
    canBook = true
    for player in context.reservedPlayers
      canBook = false if player.userId == Meteor.userId()
      playerDetails = Helpers.getUserDetails(player.userId)
      if player.isGuest
        fullName = player.name
      else
        fullName = "#{playerDetails.firstName} #{playerDetails.lastName}"
      data.push
        isReserved: true
        isGuest: player.isGuest
        player: playerDetails
        name: fullName
    for i in [0...availableSpots]
      data.push
        isReserved: false
        canBook: canBook
    data

UI.registerHelper "imageUrl", (context, options) ->
  if context
    Images.findOne({_id: context})?.url

UI.registerHelper "availableSpots", (context, options) ->
  if context
    context.potentialSpots - context.reservedPlayers.length

UI.registerHelper "range", (context, options) ->
  if context
    start = options?.hash?.start || 0
    [start...context]

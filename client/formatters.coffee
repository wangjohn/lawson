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
    for player in context.reservedPlayers
      data.push
        isReserved: true
        isGuest: player.is_guest
        player: Helpers.getUserDetails(player.user_id)
    for i in [0...availableSpots]
      data.push
        isReserved: false
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

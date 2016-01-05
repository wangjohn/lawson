UI.registerHelper "formatDay", (context, options) ->
  if context
    moment(context).format("dddd, MMM Do YYYY")

UI.registerHelper "formatTime", (context, options) ->
  if context
    moment(context).format("H:mm A")

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
        player: player
    for i in [0...availableSpots]
      data.push
        isReserved: false

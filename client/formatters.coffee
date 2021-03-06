UI.registerHelper "formatDate", (context, options) ->
  if context
    moment(context).format("MM-DD-YYYY")

UI.registerHelper "formatDay", (context, options) ->
  if context
    moment(context).format("dddd M/D/YYYY")

UI.registerHelper "formatTime", (context, options) ->
  if context
    moment(context).format("h:mm A")

UI.registerHelper "formatTimestamp", (context, options) ->
  if context
    context.getTime()

UI.registerHelper "findLength", (context, options) ->
  if context
    context.length

UI.registerHelper "imageUrl", (context, options) ->
  if context
    Images.findOne({_id: context})?.url

UI.registerHelper "availableSpots", (context, options) ->
  if context
    context.potentialSpots - context.reservedPlayers.length

UI.registerHelper "range", (context, options) ->
  if context
    start = options?.hash?.start || 0
    end = if options?.hash?.inclusive then (context + 1) else context
    [start...end]

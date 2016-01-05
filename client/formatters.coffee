UI.registerHelper "formatDay", (context, options) ->
  if context
    moment(context).format("dddd, MMM Do YYYY")

UI.registerHelper "formatTime", (context, options) ->
  if context
    moment(context).format("H:mm A")

UI.registerHelper "findLength", (context, options) ->
  if context
    context.length

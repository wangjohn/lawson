UI.registerHelper "formatDay", (context, options) ->
  if context
    moment(context).format("dddd, MMM Do YYYY")

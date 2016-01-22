Template.modal_cancel_tee_time.helpers
  timestamp: ->
    data = Session.get("modal_cancel_tee_time_data") || {}
    data.timestamp

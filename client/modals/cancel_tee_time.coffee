Template.modal_cancel_tee_time.helpers
  timestamp: ->
    data = Session.get("modal_cancel_tee_time_data") || {}
    data.timestamp
  hasGuests: ->
    data = Session.get("modal_cancel_tee_time_data") || {}
    teeTime = Helpers.getTeeTime(new Date(data.timestamp))
    players = teeTime?.reservedPlayers || []
    for p in players
      if p.userId == data.userId and p.isGuest
        return true
    false

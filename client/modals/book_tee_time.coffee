Template.modal_book_tee_time.helpers
  timestamp: ->
    data = Session.get("modal_book_tee_time_data") || {}
    data.timestamp
  teeTime: ->
    data = Session.get("modal_book_tee_time_data") || {}
    if data.timestamp
       Helpers.getTeeTime(new Date(data.timestamp))
  teeTimeData: ->
    Session.get("modal_book_tee_time_golfers_changed")
    data = Session.get("modal_book_tee_time_data") || {}
    return unless data.timestamp
    teeTime = Helpers.getTeeTime(new Date(data.timestamp))
    return unless teeTime
    reservedPlayers = _.clone(teeTime.reservedPlayers)
    newPlayers = Helpers.harvestTeeTimePlayers()
    reservedPlayers = reservedPlayers.concat(newPlayers)
    Helpers.teeTimeData(teeTime, {canBook: false, canCancel: false, reservedPlayers: reservedPlayers})
  isLoading: ->
    Session.get("modal_book_tee_time_loading")

Template.modal_book_tee_time_golfers.helpers
  showGolfers: ->
    Session.get("modal_book_tee_time_include_additional_golfers")
  numGolfers: ->
    Session.get("modal_book_tee_time_num_golfers") || 1

Template.modal_book_tee_time_golfer.helpers
  golferNumber: (index) ->
    index + 1

Template.modal_book_tee_time.rendered = ->
  Session.set("modal_book_tee_time_num_golfers", 1)
  Session.set("modal_book_tee_time_include_additional_golfers", false)
  @$(".ui.checkbox.include-additional-golfers").checkbox({
    onChange: =>
      isChecked = $(".ui.checkbox.include-additional-golfers").checkbox("is checked")
      Session.set("modal_book_tee_time_include_additional_golfers", isChecked)
      Session.set("modal_book_tee_time_golfers_changed", Date.now())
      $(".num-golfers-field").toggleClass("hidden-field")
  })
  @$(".ui.dropdown.num-golfers").dropdown({
    onChange: (val, text, $elem) =>
      numGolfers = parseInt(val, 10)
      Session.set("modal_book_tee_time_num_golfers", numGolfers)
  })

Template.modal_book_tee_time_member.rendered = ->
  @$(".ui.dropdown").dropdown({
    onChange: ->
      Session.set("modal_book_tee_time_golfers_changed", Date.now())
  })

Template.modal_book_tee_time_member.helpers
  memberDetails: ->
    UserDetails.find({userId: {$ne: Meteor.userId()}})

Template.modal_book_tee_time_golfer.rendered = ->
  @$(".ui.checkbox.is-member").checkbox({
    onChange: =>
      @$(".add-member").toggleClass("hidden-field")
      @$(".add-guest").toggleClass("hidden-field")
  })

Template.modal_book_tee_time_golfer.events
  "change input[name='guest-name']": (evt) ->
    Session.set("modal_book_tee_time_golfers_changed", Date.now())

Template.modal_book_tee_time.events
  "click .actions .ok": (evt) ->
    data = Session.get("modal_book_tee_time_data") || {}
    teeTime = Helpers.getTeeTime(new Date(data.timestamp))
    players = Helpers.harvestTeeTimePlayers()
    Session.set("modal_book_tee_time_loading", true)
    Meteor.call "bookTeeTime", teeTime._id, players, (err) ->
      Session.set("modal_book_tee_time_loading", false)
      Router.go("/reservations")
  "click .actions .cancel": (evt) ->
    Router.go("/tee_times")

Template.book_tee_time.helpers
  timestamp: ->
    data = Session.get("book_tee_time_data") || {}
    data.timestamp
  teeTime: ->
    data = Session.get("book_tee_time_data") || {}
    if data.timestamp
       Helpers.getTeeTime(new Date(data.timestamp))
  teeTimeData: ->
    Session.get("book_tee_time_golfers_changed")
    data = Session.get("book_tee_time_data") || {}
    return unless data.timestamp
    teeTime = Helpers.getTeeTime(new Date(data.timestamp))
    return unless teeTime
    reservedPlayers = _.clone(teeTime.reservedPlayers)
    newPlayers = Helpers.harvestTeeTimePlayers()
    reservedPlayers = reservedPlayers.concat(newPlayers)
    Helpers.teeTimeData(teeTime, {canBook: false, canCancel: false, reservedPlayers: reservedPlayers})
  isLoading: ->
    Session.get("book_tee_time_loading")

Template.book_tee_time_golfers.helpers
  showGolfers: ->
    Session.get("book_tee_time_include_additional_golfers")
  numGolfers: ->
    Session.get("book_tee_time_num_golfers") || 1

Template.book_tee_time_golfer.helpers
  golferNumber: (index) ->
    index + 1

Template.book_tee_time.rendered = ->
  Session.set("book_tee_time_num_golfers", 1)
  Session.set("book_tee_time_include_additional_golfers", false)
  @$(".ui.checkbox.include-additional-golfers").checkbox({
    onChange: =>
      isChecked = $(".ui.checkbox.include-additional-golfers").checkbox("is checked")
      Session.set("book_tee_time_include_additional_golfers", isChecked)
      Session.set("book_tee_time_golfers_changed", Date.now())
      $(".num-golfers-field").toggleClass("hidden-field")
  })
  @$(".ui.dropdown.num-golfers").dropdown({
    onChange: (val, text, $elem) =>
      numGolfers = parseInt(val, 10)
      Session.set("book_tee_time_num_golfers", numGolfers)
  })

Template.book_tee_time_member.rendered = ->
  @$(".ui.dropdown").dropdown({
    onChange: ->
      Session.set("book_tee_time_golfers_changed", Date.now())
  })

Template.book_tee_time_member.helpers
  memberDetails: (golferNumber) ->
    Session.get("book_tee_time_golfers_changed")
    alreadyUsedIds = [Meteor.userId()]

    # Prevent selection of players already reserved in the tee time
    data = Session.get("book_tee_time_data") || {}
    if data.timestamp
      teeTime = Helpers.getTeeTime(new Date(data.timestamp))
      alreadyUsedIds = alreadyUsedIds.concat(_.pluck(teeTime.reservedPlayers, "userId"))

    # Prevent selection of players who are reserved in other dropdowns
    $golferDetails = $(".golfer-details[data-golfer-number='#{golferNumber}']")
    $bookingForm = $(".booking-form")
    $bookingForm.find(".golfer-details").each (i, elem) ->
      $el = $(elem)
      if parseInt($el.attr("data-golfer-number"), 10) != golferNumber
        userId = $el.find(".select-member").dropdown("get value")
        if typeof userId == 'string'
          alreadyUsedIds.push(userId)

    # Find all golfering players who aren't in the alreadyUsedIds array
    UserDetails.find({userId: {$nin: alreadyUsedIds}, golfingMember: {$ne: false}})

Template.book_tee_time_golfer.rendered = ->
  @$(".ui.checkbox.is-member").checkbox({
    onChange: =>
      @$(".add-member").toggleClass("hidden-field")
      @$(".add-guest").toggleClass("hidden-field")
  })

Template.book_tee_time_golfer.events
  "change input[name='guest-name']": (evt) ->
    Session.set("book_tee_time_golfers_changed", Date.now())

Template.book_tee_time.events
  "click .actions .ok": (evt) ->
    data = Session.get("book_tee_time_data") || {}
    teeTime = Helpers.getTeeTime(new Date(data.timestamp))
    players = Helpers.harvestTeeTimePlayers()
    Session.set("book_tee_time_loading", true)
    Meteor.call "bookTeeTime", teeTime._id, players, (err) ->
      Session.set("book_tee_time_loading", false)
      Router.go("/reservations")
  "click .actions .cancel": (evt) ->
    Router.go("/tee_times")

Template.book_tee_time_user.helpers
  name: ->
    userDetails = UserDetails.findOne({userId: Meteor.userId()})
    if userDetails
      "#{userDetails.firstName} #{userDetails.lastName}"

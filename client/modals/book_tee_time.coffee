Template.modal_book_tee_time.helpers
  timestamp: ->
    data = Session.get("modal_book_tee_time_data") || {}
    data.timestamp
  teeTime: ->
    data = Session.get("modal_book_tee_time_data") || {}
    if data.timestamp
       Helpers.getTeeTime(new Date(data.timestamp))
  teeTimeData: ->
    data = Session.get("modal_book_tee_time_data") || {}
    return unless data.timestamp
    teeTime = Helpers.getTeeTime(new Date(data.timestamp))
    return unless teeTime
    reservedPlayers = _.clone(teeTime.reservedPlayers)
    newPlayers = Helpers.harvestTeeTimePlayers()
    teeTime.reservedPlayers = reservedPlayers.concat(newPlayers)
    Helpers.teeTimeData(teeTime, {canBook: false})

Template.modal_book_tee_time_golfers.helpers
  showGolfers: ->
    Session.get("modal_book_tee_time_include_golfers")
  numGolfers: ->
    Session.get("modal_book_tee_time_num_golfers") || 0

Template.modal_book_tee_time_golfer.helpers
  golferNumber: (index) ->
    index + 1

Template.modal_book_tee_time.rendered = ->
  Session.set("modal_book_tee_time_include_golfers", false)
  Session.set("modal_book_tee_time_num_golfers", 0)
  @$(".ui.checkbox.include-golfers").checkbox({
    onChange: =>
      isChecked = $(".ui.checkbox.include-golfers").checkbox("is checked")
      Session.set("modal_book_tee_time_include_golfers", isChecked)
      $(".num-golfers-field").toggleClass("hidden-field")
  })
  @$(".ui.dropdown.num-golfers").dropdown({
    onChange: (val, text, $elem) =>
      numGolfers = parseInt(val, 10)
      Session.set("modal_book_tee_time_num_golfers", numGolfers)
  })

Template.modal_book_tee_time_member.rendered = ->
  @$(".ui.dropdown").dropdown()

Template.modal_book_tee_time_member.helpers
  memberDetails: ->
    UserDetails.find({userId: {$ne: Meteor.userId()}})

Template.modal_book_tee_time_golfer.rendered = ->
  @$(".ui.checkbox.is-member").checkbox({
    onChange: =>
      @$(".add-member").toggleClass("hidden-field")
      @$(".add-guest").toggleClass("hidden-field")
  })

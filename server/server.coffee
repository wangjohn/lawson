cheerio = Meteor.npmRequire("cheerio")

WIDGET_URL = "http://widgets.ghin.com/HandicapLookupResults.aspx"

Meteor.startup ->
  unless Roles.userIsInRole("Xn3Nacqaf2Ft2HLZH", ["admin"])
    Roles.addUsersToRoles("Xn3Nacqaf2Ft2HLZH", ["admin"])

class HandicapRetriever
  constructor: ->
    @widgetQueryParams =
      entry: 1
      css: "default"
      dynamic: ""
      small: 0
      mode: ""
      tab: 0

  retrieve: (ghinNumber) =>
    queryParams = _.extend(@widgetQueryParams, {ghinno: ghinNumber})
    opts =
      params: queryParams
      headers:
        "Upgrade-Insecure-Requests": 1
    widgetResult = HTTP.call("GET", WIDGET_URL, opts)
    handicap = @parseHTML(widgetResult.content)
    if handicap
      parseFloat(handicap, 10)

  parseHTML: (html) ->
    $ = cheerio.load(html)
    $('.ClubGridHandicapIndex').text()

getHandicap = (ghinNumber) ->
  new HandicapRetriever().retrieve(ghinNumber)

sendBookingNotification = (userId, teeTime) ->
  return
  user = Meteor.users.findOne({_id: userId})
  userEmail = user.emails[0]
  # TODO: figure out the template for our booking email.
  emailOptions =
    from: "ProShop <proshop@presidiogolfclub.com>"
    to: userEmail
    subject: "Reservation confirmed for "
    text: "You've confirmed a reservation for "
  Email.send(emailOptions)

Meteor.publish "tee_times", ->
  TeeTimes.find({time: {"$gte": new Date()}})

Meteor.publish "user_details", ->
  UserDetails.find()

Meteor.publish "images", ->
  Images.find()

Meteor.methods
  createAccount: (accountData) ->
    accountOptions =
      email: accountData.email
      password: accountData.password
    userId = Accounts.createUser(accountOptions)
    userDetailsData =
      userId: userId
      firstName: accountData.firstName
      lastName: accountData.lastName
      yearJoined: accountData.yearJoined
      ghinNumber: accountData.ghinNumber
      golfingMember: true
    if userDetailsData.ghinNumber
      handicap = getHandicap(userDetailsData.ghinNumber)
      userDetailsData["handicap"] = handicap
    UserDetails.insert(userDetailsData)
    #Accounts.sendVerificationEmail(userId)

  updateSettings: (userId, settingsObj) ->
    setObj =
      firstName: settingsObj.firstName
      lastName: settingsObj.lastName
      yearJoined: parseInt(settingsObj.yearJoined, 10) || null
      ghinNumber: settingsObj.ghinNumber
    if settingsObj.ghinNumber
      handicap = getHandicap(settingsObj.ghinNumber)
      setObj["handicap"] = handicap
    if settingsObj.profileImageId
      setObj.profileImageId = settingsObj.profileImageId
    UserDetails.update({userId: userId}, {$set: setObj})

  bookTeeTime: (teeTimeId, players) ->
    teeTime = TeeTimes.findOne(teeTimeId)
    if Meteor.userId() in _.pluck(teeTime.reservedPlayers, "userId")
      throw new Meteor.Error("already-reserved", "You have already reserved this tee time")
    if teeTime.reservedPlayers.length >= teeTime.potentialSpots
      throw new Meteor.Error("tee-tee-full", "This tee time is full")
    if teeTime.potentialSpots < teeTime.reservedPlayers.length + players.length
      throw new Meteor.Error("not-enough-spots", "There aren't enough spots available to book that many people")
    if _.uniq(_.pluck(players, "userId")).length != players.length
      throw new Meteor.error("multiple-booking", "You cannot book a player multiple times")
    nonGuestAdditions = _.filter(players, (player) -> not player.isGuest)
    nonGuestReserved = _.filter(teeTime.reservedPlayers, (player) -> not player.isGuest)
    for player in nonGuestAdditions
      if player in _.pluck(nonGuestReserved, "userId")
        throw new Meteor.Error("already-reserved", "Player has already been reserved for this tee time", player.userId)

    TeeTimes.update(teeTimeId, {
      $push: {reservedPlayers: {$each: players}}
    })
    for player in players
      sendBookingNotification(player.userId) unless player.isGuest

  cancelTeeTime: (userId, teeTimeId) ->
    teeTime = TeeTimes.findOne(teeTimeId)
    if userId not in _.pluck(teeTime.reservedPlayers, "userId")
      throw new Meteor.Error("not-reserved", "You cannot cancel this tee time since you haven't booked it")
    TeeTimes.update(teeTimeId, {
      $pull: {reservedPlayers: {userId: userId}}
    })

  createTeeTime: (time, potentialSpots) ->
    user = Meteor.userId()
    if not user
      throw new Meteor.Error("no-user", "Cannot perform this action without a user")
    if not Roles.userIsInRole(user, ['admin'])
      throw new Meteor.Error("access-denied", "You do not have permission to perform that action")
    prevTime = TeeTimes.findOne({time: time})
    if prevTime
      throw new Meteor.Error("already-created", "You cannot create this tee time since there is already one at that time")
    TeeTimes.insert({
      createdAt: new Date()
      time: time
      potentialSpots: potentialSpots
      reservedPlayers: []
    })

  removeTeeTime: (id) ->
    user = Meteor.userId()
    if not user
      throw new Meteor.Error("no-user", "Cannot perform this action without a user")
    if not Roles.userIsInRole(user, ['admin'])
      throw new Meteor.Error("access-denied", "You do not have permission to perform that action")
    TeeTimes.remove({_id: id})

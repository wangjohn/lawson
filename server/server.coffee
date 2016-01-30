cheerio = Meteor.npmRequire("cheerio")

WIDGET_URL = "http://widgets.ghin.com/HandicapLookupResults.aspx"

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
    if userDetailsData.ghinNumber
      handicap = getHandicap(userDetailsData.ghinNumber)
      userDetailsData["handicap"] = handicap
    UserDetails.insert(userDetailsData)
    Accounts.sendVerificationEmail(userId)

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

  bookTeeTime: (userId, teeTimeId, numGuests) ->
    teeTime = TeeTimes.findOne(teeTimeId)
    if userId in _.pluck(teeTime.reservedPlayers, "userId")
      throw new Meteor.Error("already-reserved", "You have already reserved this tee time")
    if teeTime.reservedPlayers.length >= teeTime.potentialSpots
      throw new Meteor.Error("tee-tee-full", "This tee time is full")
    if teeTime.potentialSpots - teeTime.reservedPlayers.length < 1 + numGuests
      throw new Meteor.Error("not-enough-spots", "There aren't enough spots available to book that many people")

    reservedPlayers = [{userId: userId, isGuest: false}]
    for i in [0...numGuests]
      reservedPlayers.push({userId: userId, isGuest: true})

    TeeTimes.update(teeTimeId, {
      $push: {reservedPlayers: {$each: reservedPlayers}}
    })

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

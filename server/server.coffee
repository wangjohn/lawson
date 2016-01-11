Meteor.publish "tee_times", ->
  TeeTimes.find({time: {"$gte": new Date()}})

Meteor.publish "user_details", ->
  UserDetails.find()

Meteor.publish "images", ->
  Images.find()

Meteor.methods
  updateSettings: (userId, settingsObj) ->
    setObj =
      firstName: settingsObj.firstName
      lastName: settingsObj.lastName
      ghinNumber: settingsObj.ghinNumber
    if settingsObj.profileImageId
      setObj.profileImageId = settingsObj.profileImageId
    UserDetails.update({user_id: userId}, {$set: setObj})

  bookTeeTime: (userId, teeTimeId) ->
    teeTime = TeeTimes.findOne(teeTimeId)
    if userId in teeTime.reservedPlayers
      throw new Meteor.Error("already-reserved", "You have already reserved this tee time")
    if teeTime.reservedPlayers.length >= teeTime.potentialSpots
      throw new Meteor.Error("tee-tee-full", "This tee time is full")
    TeeTimes.update(teeTimeId, {
      $push: {reservedPlayers: userId}
    })

  cancelTeeTime: (userId, teeTimeId) ->
    teeTime = TeeTimes.findOne(teeTimeId)
    if userId not in teeTime.reservedPlayers
      throw new Meteor.Error("not-reserved", "You cannot cancel this tee time since you haven't booked it")
    TeeTimes.update(teeTimeId, {
      $pull: {reservedPlayers: userId}
    })

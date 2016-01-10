Meteor.publish "tee_times", ->
  TeeTimes.find({time: {"$gte": new Date()}})

Meteor.publish "user_details", ->
  UserDetails.find()

Meteor.publish "images", ->
  Images.find()

Meteor.methods
  updateSettings: (userId, settingsObj) ->
    userDetailsQuery =
      $set:
        firstName: settingsObj.firstName
        lastName: settingsObj.lastName
        ghinNumber: settingsObj.ghinNumber
        profileImageId: settingsObj.profileImageId
    UserDetails.update({user_id: userId}, userDetailsQuery)

Meteor.publish "tee_times", ->
  TeeTimes.find({time: {"$gte": new Date()}})

Meteor.publish "user_details", ->
  UserDetails.find()

Images.allow
  insert: ->
    true

Meteor.methods
  updateSettings: (userId, settingsObj) ->
    userDetailsQuery =
      $set:
        firstName: settingsObj.firstName
        lastName: settingsObj.lastName
        ghinNumber: settingsObj.ghinNumber
        profileImageId: settingsObj.profileImageId
    UserDetails.update({user_id: userId}, userDetailsQuery)

Meteor.publish "tee_times", ->
  TeeTimes.find({time: {"$gte": new Date()}})

Meteor.publish "user_details", ->
  UserDetails.find()

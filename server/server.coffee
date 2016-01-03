TeeTimes = new Mongo.Collection("tee_times")

Meteor.publish "tee_times", ->
  TeeTimes.find()

@TeeTimes = new Mongo.Collection("tee_times")
@UserDetails = new Mongo.Collection("user_details")

@Images = new FS.Collection("images", {
  stores: [new FS.Store.FileSystem("images", {})]
})

@AllowedEmails = new Mongo.Collection("allowed_emails")
@TeeTimes = new Mongo.Collection("tee_times")
@UserDetails = new Mongo.Collection("user_details")

@Images = new FS.Collection("images", {
  stores: [
    new FS.Store.FileSystem("images", {
      beforeWrite: (fileObj) ->
        {extension: "png", type: "image/png"}
      transformWrite: (fileObj, readStream, writeStream) ->
        gm(readStream, fileObj.name())
          .resize("250", "250", "^")
          .gravity("Center")
          .extent("250", "250")
          .stream("PNG").pipe(writeStream)
    })
  ]
})
Images.allow
  insert: -> true
  update: -> true
  download: -> true

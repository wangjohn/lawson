Template.settings.helpers
  settingsData: ->
    UserDetails.findOne(Meteor.userId())

Template.settings.events
  "click button.submit": (evt) ->
    evt.preventDefault()
    $form = $(evt.currentTarget).closest(".form")
    firstName = $form.find("input[name='first-name']").val()
    lastName = $form.find("input[name='last-name']").val()
    files = $form.find("input[name='file-upload']").files
    FS.Utility.eachFile evt, (file) ->
      Images.insert file, (err, fileObj) ->
        console.log(fileObj)


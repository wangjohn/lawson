Template.settings.helpers
  settingsData: ->
    Helpers.getUserDetails(Meteor.userId())

Template.settings.events
  "click button.submit": (evt) ->
    evt.preventDefault()
    $form = $(evt.currentTarget).closest(".form")
    firstName = $form.find("input[name='first-name']").val()
    lastName = $form.find("input[name='last-name']").val()
    ghinNumber = $form.find("input[name='ghin-number']").val()
    profileFile = getFileFromInput($form.find("input[name='file-upload']"))

    Images.insert profileFile, (err, fileObj) ->
      if err
        Session.set("settings_errors", {})
        return

      settingsObj =
        firstName: firstName
        lastName: lastName
        ghinNumber: ghinNumber
        profileImageId: fileObj._id
      Meteor.call("updateSettings", Meteor.userId(), settingsObj)

getFileFromInput = ($input) ->
  $input[0].files[0]

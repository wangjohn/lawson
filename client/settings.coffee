Template.settings.helpers
  settingsData: ->
    Helpers.getUserDetails(Meteor.userId())
  playerName: ->
    playerDetails = Helpers.getUserDetails(Meteor.userId())
    "#{playerDetails?.firstName} #{playerDetails?.lastName}"
  loading: ->
    Session.get("settings_loading")

Template.settings.events
  "click button.submit": (evt) ->
    evt.preventDefault()
    $form = $(evt.currentTarget).closest(".form")
    settingsObj =
      firstName: $form.find("input[name='first-name']").val()
      lastName: $form.find("input[name='last-name']").val()
      yearJoined: $form.find("input[name='year-joined']").val()
      ghinNumber: $form.find("input[name='ghin-number']").val()

    profileFile = getFileFromInput($form.find("input[name='file-upload']"))
    Session.set("settings_loading", true)
    updateCB = (err, res) ->
      Session.set("settings_loading", false)
    if profileFile
      Images.insert profileFile, (err, fileObj) ->
        if err
          Session.set("settings_errors", {})
          Session.set("settings_loading", false)
          return

        settingsObj.profileImageId = fileObj._id
        Meteor.call("updateSettings", Meteor.userId(), settingsObj, updateCB)
    else
      Meteor.call("updateSettings", Meteor.userId(), settingsObj, updateCB)

getFileFromInput = ($input) ->
  $input[0].files[0]

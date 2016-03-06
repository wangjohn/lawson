Template.change_password.rendered = ->
  Session.set("change_password_message", null)

Template.change_password.helpers
  "message": ->
    message = Session.get("change_password_message")
    if message?.error
      if message?.error?.reason == "Incorrect password"
        "Oops, your current password was typed in incorrectly."
      else
        "Oops, we weren't able to change your password: #{message?.error?.reason}."
    else if message?.success
      "You've successfully changed your password!"

  "messageClass": ->
    message = Session.get("change_password_message")
    if message?.error
      "error"
    else if message?.success
      "success"

Template.change_password.events
  "submit .form.change-password": (evt) ->
    evt.preventDefault()
    changePassword()

  "click .form.change-password .submit": (evt) ->
    evt.preventDefault()
    changePassword()

changePassword = ->
  oldPassword = $(".form.change-password input[name='current-password']").val()
  newPassword = $(".form.change-password input[name='new-password']").val()
  Session.set("change_password_message", null)
  Accounts.changePassword oldPassword, newPassword, (err) ->
    if err
      Session.set("change_password_message", {error: err})
    else
      Session.set("change_password_message", {success: true})

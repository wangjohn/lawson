Template.forgot_password.rendered = ->
  Session.set("forgot_password_message", null)

Template.forgot_password.helpers
  "message": ->
    message = Session.get("forgot_password_message")
    if message?.error
      if message?.error?.reason == "User not found"
        "Oops, it doesn't look like that email is registered."
      else
        "Oops, something went wrong."
    else if message?.success
      "Successfully sent an email to #{message?.success}."

  "messageClass": ->
    message = Session.get("forgot_password_message")
    if message?.error
      "error"
    else if message?.success
      "success"

Template.forgot_password.events
  "click .form.forgot-password .submit": (evt) ->
    evt.preventDefault()
    emailAddress = $("input[name='email']").val()
    Accounts.forgotPassword {email: emailAddress}, (err) ->
      if err
        Session.set("forgot_password_message", {error: err})
      else
        Session.set("forgot_password_message", {success: emailAddress})

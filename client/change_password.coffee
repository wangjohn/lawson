Template.change_password.events
  "submit form.change-password": (evt) ->
    evt.preventDefault()
    changePassword()

  "click form.change-password .submit": (evt) ->
    changePassword()

changePassword = ->
  # do something here


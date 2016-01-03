Template.login.events
  "submit form.sign-in": (evt) ->
    evt.preventDefault()
    username = $(evt.target).find("input[name='username']").val()
    password = $(evt.target).find("input[name='password']").val()
    Meteor.loginWithPassword username, password, (error) ->
      Session.set("login_error", error)

Template.login.helpers
  errorClass: ->
    "error" if Session.get("login_error")
  error: ->
    Session.get("login_error")

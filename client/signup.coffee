Template.signup.helpers
  loading: ->
    Session.get("signup_loading")
  errorClass: ->
    if Session.get("signup_errors")
      "error"
  errorMessage: ->
    Session.get("signup_errors")?.reason

Template.signup.rendered = ->
  Session.set("signup_loading", false)
  Session.set("signup_errors", null)
  formRequirements =
    on: "submit"
    fields:
      email:
        identifier: "email"
        rules: [{type: "email", prompt: "Please enter a valid email address"}]
      password:
        identifier: "password"
        rules: [{type: "minLength[6]", prompt: "Password must be at least 6 characters"}]
      firstName:
        identifier: "firstName"
        rules: [{type: "empty", prompt: "Please enter a first name"}]
      lastName:
        identifier: "lastName"
        rules: [{type: "empty", prompt: "Please enter a last name"}]
  $("form.sign-up").form(formRequirements)

Template.signup.events
  "submit form.sign-up": (evt) ->
    evt.preventDefault()
    accountData = $("form.sign-up").form("get values")
    Session.set("signup_loading", true)
    Meteor.call "createAccount", accountData, (err) ->
      Session.set("signup_loading", false)
      if err
        Session.set("signup_errors", err)
      else
        Router.go("/")

Router.configure
  layoutTemplate: "main_layout"

Router.route "/", ->
  @render "home"
  @render "menu", {to: "menu"}

Router.route "/login",
  template: "login"
  onBeforeAction: ->
    if Meteor.user()
      @redirect("/")
    else
      @next()

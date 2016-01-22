Router.configure
  layoutTemplate: "main_layout"

Router.route "/", ->
  @layout "home_layout"
  @render "home"

Router.route "/tee_times", ->
  @render "tee_times"
  @render "menu", {to: "menu"}

Router.route "/add_tee_times",
  template: "add_tee_times"
  yieldRegions:
    menu: {to: "menu"}

Router.route "/settings", ->
  @render "settings"
  @render "menu", {to: "menu"}

Router.route "/login",
  template: "login"
  onBeforeAction: ->
    if Meteor.user()
      @redirect("/")
    else
      @next()

Router.route "/reservations",
  template: "reservations"
  yieldRegions:
    menu: {to: "menu"}

Router.configure
  layoutTemplate: "main_layout"

Router.route "/", ->
  @layout "home_layout"
  @render "home"

Router.route "/tee_times", ->
  @render "tee_times"
  @render "menu", {to: "menu"}

Router.route "/book",
  template: "modal_book_tee_time"
  yieldRegions:
    menu: {to: "menu"}

Router.route "/add_tee_times",
  template: "add_tee_times"
  yieldRegions:
    menu: {to: "menu"}

Router.route "/settings", ->
  @render "settings"
  @render "menu", {to: "menu"}

Router.route "/signup",
  template: "signup"

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

authenticateUser = ->
  user = Meteor.userId()
  if not user
    @redirect("/")
  else
    @next()

authenticateAdmin = ->
  user = Meteor.userId()
  if Roles.userIsInRole(user, 'admin')
    @next()
  else
    @redirect("/")

Router.onBeforeAction(authenticateUser, {only: ['tee_times', 'add_tee_times', 'settings', 'reservations']})
Router.onBeforeAction(authenticateAdmin, {only: ['add_tee_times']})

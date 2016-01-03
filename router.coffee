Router.configure
  layoutTemplate: "main_layout"

Router.route "/", ->
  @render "home"
  @render "menu", {to: "menu"}

Router.route "/login", ->
  @render "login"

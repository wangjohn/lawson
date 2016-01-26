Template.menu.events
  "click #sign-out": (evt) ->
    Meteor.logout ->
      Router.go("/")

Template.menu_settings_dropdown.helpers
  userDetails: ->
    Helpers.getUserDetails(Meteor.userId())
  displayName: ->
    details = Helpers.getUserDetails(Meteor.userId())
    if details
      "#{details.firstName} #{details.lastName}"

Template.menu_settings_dropdown.onRendered ->
  @$(".settings-dropdown").dropdown({
    on: 'hover'
  })

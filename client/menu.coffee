Template.menu.events
  "click #sign-out": (evt) ->
    Meteor.logout ->
      Router.go("/")

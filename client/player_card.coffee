Template.player_card.helpers
  handicapLink: (ghinNumber) ->
    if ghinNumber
      "http://widgets.ghin.com/HandicapLookupResults.aspx?entry=1&ghinno=#{ghinNumber}&css=default&dynamic=&small=0&mode=&tab=0"

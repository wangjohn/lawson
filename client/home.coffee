QUOTES_LIST = [{
    quote: "It's impossible to outplay an opponent you can't outhink."
    author: "Lawson Little"
  }, {
    quote: "Concentration is a fine antidote to anxiety."
    author: "Jack Nicklaus"
  }, {
    quote: "I have a tip that can take five strokes off anyone's game; it's called an eraser."
    author: "Arnold Palmer"
  }, {
    quote: "The more I practice, the luckier I get."
    author: "Gary Player"
  }, {
    quote: "The most important shot in golf is the next one."
    author: "Ben Hogan"
}]

Template.home.helpers
  quote: ->
    _.sample(QUOTES_LIST)

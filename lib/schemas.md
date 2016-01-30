# TeeTimes

createdAt:
  type: Date
  required: true
time:
  type: Date
  required: true
potentialSpots:
  type: Number
  required: true
reservedPlayers:
  type: PlayersArray
  required: true

## PlayersArray

userId:
  type: String
  required: true
isGuest:
  type: Boolean
  required: true
firstName:
  type: String
lastName:
  type: String

# UserDetails

userId:
  type: String
  required: true
firstName:
  type: String
lastName:
  type: String
yearJoined:
  type: Number
ghinNumber:
  type: String
handicap:
  type: Float

d = document
$document = $(d)

API_KEY = "aaaaa"

isRoomPage = ->
  $target = $(d.getElementById("rooms-show"))
  $target && $target.length > 0

setupRoom = ->
  manager = new PeerManager(ROOM_ID);


$ ->
  isRoomPage() && setupRoom()
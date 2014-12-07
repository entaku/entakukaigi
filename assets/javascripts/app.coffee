getRoomID = ->
  return location.pathname.split("/")[2]

window.ROOM_ID = getRoomID()

# on ready
jThree ((j3) ->
  renderer = new jThreeRenderer(j3)
  renderer.init ->
    peerManager = PeerManagerFactory.create(ROOM_ID)

  milkcocoa = new MilkCocoa("https://io-ni2re3bq2.mlkcca.com:443/")
  messageDataStore = milkcocoa.dataStore("messages")

  query = messageDataStore.query().limit(20).sort('desc').done((list)->
    _.each list.reverse(), (data)->
      p = jQuery "<p></p>"
      p.text data["message"]
      jQuery("#display_area").append p
  )

  jQuery("#message_area").on "keypress", (e) ->
    if e.keyCode is 13
      messageDataStore.push
        message: jQuery(this).val()
        date: new Date()
      , (data)->
      jQuery(this).val ""
    return

  messageDataStore.on "push", (event) ->
    jQuery("#display_area p:first").remove()  if jQuery("#display_area p").size() > 10
    p = jQuery "<p></p>"
    p.text event.value["message"]
    jQuery("#display_area").append p
    return

), ->
  alert "このブラウザはWebGLに対応していません。"
  return

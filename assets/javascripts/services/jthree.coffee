jThree ((j3) ->
  $("#loading").remove()
  j3.Trackball()
  degree = 0
  scene = j3("scene")
  x = 0
  y = 0
  z = 0
  r = 10
  i = 1
  degree = 0
  while degree < 360
    obj_degree = -degree
    console.log obj_degree
    obj_degree = obj_degree * (Math.PI / 180)
    x = Math.cos(degree * (Math.PI / 180)) * r
    z = Math.sin(degree * (Math.PI / 180)) * r
    rad = degree * (Math.PI / 180)
    if degree is 0
      console.log j3("#camera")
      j3("#camera").css "position", x + " " + y + " " + z
      console.log j3("camera").css("position")
    texture = j3("<txr id=\"video_texture" + i + "\" video=\"#video" + i + "\" param=\"\" />")
    j3("head").append texture
    texture = j3("<txr id=\"overlay_texture" + i + "\" canvas=\"#overlay" + i + "\" animation=\"true\" \" param=\"repeat:1;wrap:2;\" />")
    j3("head").append texture
    texture = j3("<txr id=\"webgl_texture" + i + "\" canvas=\"#webgl" + i + "\" animation=\"true\" \" param=\"repeat:1;wrap:2;\" />")
    j3("head").append texture

    material = j3("<mtl id=\"video_mtl" + i + "\" type=\"MeshBasic\" param=\"color: #fff; map: #video_texture" + i + ";\" />")
    j3("head").append material
    material = j3("<mtl id=\"overlay_mtl" + i + "\" type=\"MeshBasic\" param=\"color: #aaa; map: #overlay_texture" + i + ";\" />")
    j3("head").append material
    material = j3("<mtl id=\"webgl_mtl" + i + "\" type=\"MeshBasic\" param=\"color: #111; map: #webgl_texture" + i + ";\" />")
    j3("head").append material
    scene.append "<mesh id=\"\" class=\"face\" geo=\"#plain_geo\" mtl=\"#video_mtl" + i + "\" style=\"position: " + x + " " + y + " " + z + "; rotateY: " + obj_degree + "; scaleX: 0.01;\"></mesh>"
    scene.append "<mesh id=\"\" class=\"face\" geo=\"#plainol_geo\" mtl=\"#overlay_mtl" + i + "\" style=\"position: " + x + " " + y + " " + z + "; rotateY: " + obj_degree + "; scaleX: 0.01;\"></mesh>"
    scene.append "<mesh id=\"\" class=\"face\" geo=\"#plainwebgl_geo\" mtl=\"#webgl_mtl" + i + "\" style=\"position: " + x + " " + y + " " + z + "; rotateY: " + obj_degree + "; scaleX: 0.01;\"></mesh>"
    i++
    degree += 30
  j3(".face").on "click", ->

  j3("body").on "keyup", (e) ->
    lookAt = j3("#camera").css("lookat")
    console.log "keyup"
    switch e.which
      when 39 # Key[→]
        j3("#camera").css "lookAt", lookAt[0] + 0.5 + " " + lookAt[1] + " " + lookAt[2]
      when 37 # Key[←]
        $("#container img").animate
          left: "-=10px"
        , 100
      when 38 # Key[↑]
        $("#container img").animate
          top: "-=10px"
        , 100
      when 40 # Key[↓]
        $("#container img").animate
          top: "+=10px"
        , 100
  navigator.getUserMedia = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia
  window.URL = window.URL or window.webkitURL
  window.AudioContext = window.AudioContext or window.webkitAudioContext or window.mozAudioContext or window.msAudioContext
  success = (localMediaStream) ->
    window.importHTML = jThree("import").contents()
    manager = new PeerManager(ROOM_ID)
    return
  success()

  milkcocoa = new MilkCocoa("https://io-ni2re3bq2.mlkcca.com:443/")
  messageDataStore = milkcocoa.dataStore("messages")

  jQuery("#message_area").on "keypress", (e) ->
    if e.keyCode is 13
      messageDataStore.push message: jQuery(this).val(), (data)->
        console.log data
      jQuery(this).val ""
    return

  messageDataStore.on "push", (event) ->
    jQuery("#display_area").append "<p>" + event.value["message"] + "</p>"
    console.log(event.value)
    return

  return
), ->
  alert "このブラウザはWebGLに対応していません。"
  return

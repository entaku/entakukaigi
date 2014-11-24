KEY =
  RIGHT: 39
  LEFT: 37
  UP: 38
  DOWN: 40
class jThreeRendererBase
  constructor: (js) ->
    @j3 = js
    @scene = @j3("scene")
    @head = @j3("head")

  init: ->
    @_trackball()
    @_bindKeyup()

  _trackball :-> @j3.Trackball()

  _setupCamera: (x, y, z)->
    @j3("#camera").css "position", x + " " + y + " " + z

  _bindKeyup: ->
    @j3("body").on "keyup", (e) =>
      lookAt = @j3("#camera").css("lookat")
      $containerImg = $("#container img")
      switch e.which
        when KEY.RIGHT
          @j3("#camera").css "lookAt", lookAt[0] + 0.5 + " " + lookAt[1] + " " + lookAt[2]
        when KEY.LEFT
          $containerImg.stop().animate
            left: "-=10px"
          , 100
        when KEY.UP
          $containerImg.stop().animate
            top: "-=10px"
          , 100
        when KEY.DOWN
          $containerImg.stop().animate
            top: "+=10px"
          , 100

class jThreeRenderer extends jThreeRendererBase
  init: ->
    super()
    @_setup()
    @_setupPeerManager()

  _setup: ->
    degree = 0
    x = 0
    y = 0
    z = 0
    r = 10
    i = 1
    degree = 0
    while degree < 360
      objDegree = @_objDegree(degree)
      x = Math.cos(degree * (Math.PI / 180)) * r
      z = Math.sin(degree * (Math.PI / 180)) * r
      # rad = degree * (Math.PI / 180)
      @_setupCamera(x, y, z) if degree is 0
      @_appendElements(i, x, y, z, objDegree)
      i++
      degree += 30

  _objDegree: (degree) ->
    objDegree = -degree
    objDegree * (Math.PI / 180)

  _appendElements: (i, x, y, z, objDegree) ->
    @head.append @j3(@_textureEl(i))
    @head.append @j3(@_materialEl(i))
    @scene.append @j3(@_sceneEl(i, x, y, z, objDegree))

  _textureEl: (i) ->
    """
    <txr id="video_texture#{i}" video="#video#{i}" param="" />
    <txr id="overlay_texture#{i}" canvas="#overlay#{i}" animation="true" param="repeat:1;wrap:2;width:400;height:300;" />
    <txr id="webgl_texture#{i}" canvas="#webgl#{i}" animation="true" param="repeat:1;wrap:2;width:400;height:300;" />
    """

  _materialEl: (i) ->
    """
    <mtl id="video_mtl#{i}" type="MeshBasic" param="color: #fff; map: #video_texture#{i};" />
    <mtl id="overlay_mtl#{i}" type="MeshBasic" param="color: #000; map: #overlay_texture#{i};" />
    <mtl id="webgl_mtl#{i}" type="MeshBasic" param="color: #cc0066; map: #webgl_texture#{i};" />
    """

  _sceneEl: (i, x, y, z, objDegree) ->
    # x = Math.ceil(x)
    # y = Math.ceil(y)
    # z = Math.ceil(z)
    layerWidth = 0.001
    position = "#{x} #{y} #{z}"
    position2 = "#{x + layerWidth} #{y + layerWidth} #{z + layerWidth}"
    # position2 = position
    """
    <mesh id="" class="face" geo="#plain_geo" mtl="#video_mtl#{i}" style="position: #{position}; rotateY: #{objDegree}; scaleX: 0.01;"></mesh>
    <mesh id="" class="face" geo="#plainol_geo" mtl="#overlay_mtl#{i}" style="position: #{position2}; rotateY: #{objDegree}; scaleX: 0.01;"></mesh>
    <mesh id="" class="face" geo="#plainwebgl_geo" mtl="#webgl_mtl#{i}" style="position: #{position2}; rotateY: #{objDegree}; scaleX: 0.01;"></mesh>
    """

  _setupPeerManager: ->
    window.importHTML = jThree("import").contents()
    @peerManager = new PeerManager(ROOM_ID)

# on ready
jThree ((j3) ->
  renderer = new jThreeRenderer(j3)
  renderer.init()

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

), ->
  alert "このブラウザはWebGLに対応していません。"
  return

KEY =
  RIGHT: 39
  LEFT: 37
  UP: 38
  DOWN: 40
class jThreeRendererBase
  constructor: (j3) ->
    @j3 = j3
    @scene = @j3("scene")
    @head = @j3("head")

  init: ->
    @_trackball()
    @_bindKey()

  close: -> @j3(window).unbind()

  _trackball :-> @j3.Trackball()

  _setupCamera: (x, y, z)->
    @camera ||= @j3("#camera")
    @x = x
    @y = y
    @z = z
    @camera.css "position", x + " " + y + " " + z

  _bindKey: ->
    @j3(window).on "keydown", (e) =>
      if @camera
        switch e.which
          when KEY.RIGHT
            @x += 0.5
          when KEY.LEFT
            @x -= 0.5
          when KEY.UP
            @z += 0.5
          when KEY.DOWN
            @z -= 0.5
        @camera.css "lookAt", @x + " " + @y + " " + @z

class @jThreeRenderer extends jThreeRendererBase
  init: (fn)->
    super()
    @_setup()
    window.importHTML = jThree("import").contents()
    fn() if fn

  # private
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
    <txr id="overlay_texture#{i}" canvas="#overlay#{i}" animation="true" param="repeat:1;wrap:2;width:#{CONFIG.VIDEO.W};height:#{CONFIG.VIDEO.H};" />
    <txr id="webgl_texture#{i}" canvas="#webgl#{i}" animation="true" param="repeat:1;wrap:2;width:#{CONFIG.VIDEO.W};height:#{CONFIG.VIDEO.H};" />
    """

  _materialEl: (i) ->
    """
    <mtl id="video_mtl#{i}" type="MeshBasic" param="color: #fff; map: #video_texture#{i};" />
    <mtl id="overlay_mtl#{i}" type="MeshBasic" param="color: #000; map: #overlay_texture#{i};" />
    <mtl id="webgl_mtl#{i}" type="MeshBasic" param="map: #webgl_texture#{i};" />
    """

  _sceneEl: (i, x, y, z, objDegree) ->
    # x = Math.ceil(x)
    # y = Math.ceil(y)
    # z = Math.ceil(z)
    layerWidth = 0.00001
    position = "#{x} #{y} #{z}"
    position2 = "#{x + layerWidth} #{y + layerWidth} #{z + layerWidth}"
    # position2 = position
    """
    <mesh id="" class="face" geo="#plain_geo" mtl="#video_mtl#{i}" style="position: #{position}; rotateY: #{objDegree}; scaleX: 0.01;"></mesh>
    <mesh id="" class="face" geo="#plainol_geo" mtl="#overlay_mtl#{i}" style="position: #{position2}; rotateY: #{objDegree}; scaleX: 0.01;"></mesh>
    <mesh id="" class="face" geo="#plainwebgl_geo" mtl="#webgl_mtl#{i}" style="position: #{position2}; rotateY: #{objDegree}; scaleX: 0.01;"></mesh>
    """

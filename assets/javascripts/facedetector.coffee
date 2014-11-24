MASK_LENGTH = 7
getRandom = (min, max) ->
  min + Math.floor(Math.random() * (max - min + 1))

class @FaceDetector
  constructor: (video, overlay, webgl, remote = false) ->
    # console.log "hgoehogheo"
    # console.log video
    # console.log overlay
    # console.log webgl
    # console.log clm
    # console.log pModel
    @first = true
    @remote = remote
    video.width = 400 if video.width == 0
    video.height = 300 if video.height == 0
    @video = video
    @ctrack = new clm.tracker()
    @ctrack.init pModel
    @fd = new faceDeformer()

    webgl.width = video.width
    webgl.height = video.height

    @fd.init webgl
    @overlay = overlay
    @overlay.width = video.width
    @overlay.height = video.height
    @overlayCC = @overlay.getContext("2d")
    @currentMask = getRandom(0, MASK_LENGTH - 1)
    @startVideo()
  @updateMask: (maskNo) ->
    @currentMask = maskNo
    @switchMasks()
    return
  switchMasks: ->
    # get mask
    console.log "switchMasks" if @remote
    maskname = Object.keys(masks)[@currentMask]
    @fd.load $(window.importHTML.find("#"+maskname))[0], masks[maskname], pModel
    return
  startVideo: ->
    # start tracking
    # console.log @ctrack
    @ctrack.start @video
    # start drawing face grid
    @drawGridLoop(true)
    return
  drawGridLoop: (initial = false)->
    # get position of face
    # console.log @ctrack
    positions = @ctrack.getCurrentPosition @video
    @overlayCC.clearRect 0, 0, 500, 375
    # draw current grid
    @ctrack.draw @overlay  if positions
    # check whether mask has converged
    pn = @ctrack.getConvergence()
    if pn < 0.4# || (initial && @remote)
      @switchMasks()
      requestAnimFrame @drawMaskLoop.bind(this)
    else
      requestAnimFrame @drawGridLoop.bind(this)
    return
  drawMaskLoop: ->
    # get position of face
    positions = @ctrack.getCurrentPosition(@video)
    #console.log "pos", positions
    @overlayCC.clearRect 0, 0, 400, 300
    # draw mask on top of face
    if positions
      # window.firstPosition = positions
      @fd.draw positions
      @first = false
    # if @remote && @first
    #   console.log "draw"
    #   @first = false
    #   @fd.draw window.firstPosition
    animationRequest = requestAnimFrame(@drawMaskLoop.bind(this))
    return
  # TODO
  close: ->

document.addEventListener "clmtrackrIteration", ((event) ->
), false
MASK_LENGTH = Object.keys(masks).length
getRandom = (min, max) ->
  min + Math.floor(Math.random() * (max - min + 1))

class @FaceDetector
  constructor: (video, overlay, webgl, remote = false, defaultWidth = CONFIG.VIDEO.W, defaultHeight = CONFIG.VIDEO.H) ->
    @first = true
    @remote = remote

    video.width = defaultWidth if video.width == 0
    video.height = defaultHeight if video.height == 0
    @video = video
    @ctrack = new clm.tracker()
    @ctrack.init pModel
    @fd = new faceDeformer()

    @webgl = webgl
    @webgl.width = video.videoWidth || video.width
    @webgl.height = video.videoHeight || video.height

    @fd.init @webgl
    @overlay = overlay
    @overlay.width = video.videoWidth || video.width
    @overlay.height = video.videoHeight || video.height
    @overlayCC = @overlay.getContext("2d")
    @currentMask = getRandom(0, MASK_LENGTH - 1)
    @startVideo()
  @updateMask: (maskNo) ->
    @currentMask = maskNo
    @switchMasks()
    return
  switchMasks: ->
    # get mask
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
    if pn < 0.4
      @switchMasks()
      requestAnimFrame @drawMaskLoop.bind(this)
    else
      requestAnimFrame @drawGridLoop.bind(this)
    return
  drawMaskLoop: ->
    # get position of face
    positions = @ctrack.getCurrentPosition(@video)
    @overlayCC.clearRect 0, 0, @video.videoWidth, @video.videoHeight
    # draw mask on top of face
    if positions
      @fd.draw positions
      @first = false
    animationRequest = requestAnimFrame(@drawMaskLoop.bind(this))
    return
  close: ->
    @ctrack.stop()
    @fd.clear()

document.addEventListener "clmtrackrIteration", ((event) ->
), false
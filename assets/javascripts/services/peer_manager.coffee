window.URL = window.URL || window.webkitURL
KEY = "cjqoqnezltk2o6r"

class @PeerManager
  constructor: (roomId) ->
    @roomId = roomId
    @targetIDs = []
    @peer = new Peer(USER_ID,
      host: 'entakutest.herokuapp.com'
      secure: true
      port: 443
      key: KEY
    )
    @myCalls = {}
    @remoteCalls = {}
    @peer.on "open", (id) -> console.log "peer on open", id
    @peer.on "close", =>
      console.log "peer on close"
      @peer.destroy()
    @peer.on "error", (error) ->
      console.log "peer on error", error
      sendError error if sendError
    @peer.on "call", (call) =>
      console.log "peer on call", call
      # @closeRemote()
      @remoteCalls[call.id] = call
      call.answer(window.localStream)
      @_setRemoteConnection call, call.id
    @call()

  close: ->
    # @closeRemote()
    if @dataConnection
      @dataConnection.close()
      @dataConnection = null
    @myCall.close() if @myCall
    @peer.destroy() if @peer

  # closeRemote: ->
  #   @remoteCall.close() if @remoteCall

  call: ->
    # getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia
    navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    navigator.getUserMedia {video: true, audio: true}, (stream) =>
      myVideo = document.getElementById "my-video"
      myVideo.src = URL.createObjectURL(stream)
      myVideo.play()
      myVideo.muted = true
      window.localStream = stream
      @_getTargetIDs (targetIDs) =>
        if typeof targetIDs != "undefined"
          for id in targetIDs
            # @targetIDs.push targetID
            @myCalls[id] = @peer.call(id, stream)
            @_setRemoteConnection @myCalls[id], id
    , (error) ->
      console.error "getUserMedia err", error
      sendError error if sendError

  _setRemoteConnection: (call, id = null) ->
    console.log "_setRemoteConnection", call, id
    remoteVideo = "<video src=\"\"></video>"
    $remoteVideo = $(remoteVideo)
    call.on "stream", (remoteStream) ->
      console.log "_setRemoteConnection on stream", remoteStream
      $remoteVideo.attr
        src: URL.createObjectURL(remoteStream)
        id: id
      $("#remote-video-container").append $remoteVideo
      $remoteVideo[0].play()
    call.on "close", ->
      console.log "_setRemoteConnection on close", call
      URL.revokeObjectURL $remoteVideo.attr("src")
      $remoteVideo.remove()

  _getTargetIDs: (fn) ->
    url = "/api/rooms_users/#{@roomId}"
    $.post(url)
    .done((data) =>
      fn(data) if data && fn
    ).fail((error) ->
      console.log error
      sendError error if sendError
    )
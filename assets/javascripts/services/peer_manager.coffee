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
    @peer.on "open", (id) -> #console.log "peer on open", id
    @peer.on "close", =>
      console.log "peer on close"
      @peer.destroy()
    @peer.on "error", (error) ->
      # console.log "peer on error", error
    @peer.on "call", (call) =>
      # console.log "peer on call", call
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
      # console.log "window.videos", window.videos
      myVideo = $(window.importHTML.find(".myvideo"))
      myOverlay = $(window.importHTML.find(".myoverlay"))
      myWebgl = $(window.importHTML.find(".mywebgl"))
      myVideo.attr
        src: URL.createObjectURL(stream)
      myVideo[0].muted = true
      myVideo.addClass("attached").removeClass("not-attached")
      window.localStream = stream
      fd = new FaceDetector(myVideo[0], myOverlay[0], myWebgl[0])
      @_getTargetIDs (targetIDs) =>
        if typeof targetIDs != "undefined"
          for id in targetIDs
            # @targetIDs.push targetID
            @myCalls[id] = @peer.call(id, stream)
            @_setRemoteConnection @myCalls[id], id
    , (error) ->
      console.error "getUserMedia err", error

  _setRemoteConnection: (call, id = null) ->
    # console.log "_setRemoteConnection", call, id
    # remoteVideo = "<video src=\"\"></video>"
    $remoteVideo = $(window.importHTML.find(".not-attached")[0])
    targetID = $remoteVideo.data("id")
    $remoteOverlay = $(window.importHTML.find(".overlay#{targetID}"))
    $remoteWebgl = $(window.importHTML.find(".webgl#{targetID}"))

    fd = null
    call.on "stream", (remoteStream) ->
      # console.log "_setRemoteConnection on stream", remoteStream
      $remoteVideo.attr
        src: URL.createObjectURL(remoteStream)
        id: id
      $remoteVideo.addClass("attached").removeClass("not-attached")
      fd = new FaceDetector($remoteVideo[0], $remoteOverlay[0], $remoteWebgl[0])
    call.on "close", =>
      # console.log "_setRemoteConnection on close", call
      userId = call.peer
      # delete @myCalls[userId]
      URL.revokeObjectURL $remoteVideo.attr("src")
      # $remoteVideo.remove()
      $remoteVideo.addClass("not-attached").removeClass("attached")
      @_deletePeer userId
      fd.close()

  _getTargetIDs: (fn) ->
    url = "/api/rooms_users/#{@roomId}"
    $.post(url)
    .done((data) =>
      fn(data) if data && fn
    ).fail((error) ->
      # console.log error
    )

  _deletePeer: (id) ->
    url = "/api/rooms_users/#{@roomId}"
    $.ajax(
      url: url
      data: {user_id: id}
      method: "delete"
    )
    .done -># console.log "_deletePeer", id
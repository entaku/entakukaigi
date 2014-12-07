window.URL = window.URL || window.webkitURL
# PeerJS key
KEY = "cjqoqnezltk2o6r"

class @PeerManagerFactory
  instance = null
  @create: (roomID) -> instance ?= new PeerManager(roomID)

  # PeerManager should be a Singleton Class
  class PeerManager
    constructor: (roomID) ->
      @roomID = roomID
      @targetIDs = []
      @_enterRoom()
      .done (result) =>
        @userID = result.user_id
        @peer = new Peer(@userID,
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
      navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
      # videoOption =
      #   mandatory:
      #     maxWidth: CONFIG.VIDEO.W
      #     maxHeight: CONFIG.VIDEO.H
      #     minWidth: CONFIG.VIDEO.W
      #     minHeight: CONFIG.VIDEO.H
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
        @_getTargetIDs()
        .done (targetIDs) =>
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
        fd = new FaceDetector($remoteVideo[0], $remoteOverlay[0], $remoteWebgl[0], true)
        $remoteVideo.on "resize", (event) ->
          console.log "remoteVideo resized", "event.target.videoWidth", event.target.videoWidth, "event.target.videoHeight", event.target.videoHeight
          videoWidth = event.target.videoWidth
          videoHeight = event.target.videoHeight
          option =
            width: "#{videoWidth}px"
            height: "#{event.target.videoHeight}px"
          target = $(window.importHTML.find(".videos#{targetID}"))
          target.css option
          target[0].width = videoWidth
          target[0].height = videoHeight
        #   $remoteOverlay.css option
        #   $remoteOverlay[0].width = videoWidth
        #   $remoteOverlay[0].height = videoHeight
        #   $remoteWebgl.css option
        #   $remoteWebgl[0].width = videoWidth
        #   $remoteWebgl[0].height = videoHeight
        #   fd.close()
        #   fd = new FaceDetector(target[0], $remoteOverlay[0], $remoteWebgl[0], true, videoWidth, videoHeight)
      call.on "close", =>
        # console.log "_setRemoteConnection on close", call
        userID = call.peer
        URL.revokeObjectURL $remoteVideo.attr("src")
        $remoteVideo.addClass("not-attached").removeClass("attached")
        @_deletePeer userID
        fd.close()

    _enterRoom: ->
      d = new $.Deferred
      url = api "roomsShow", @roomID
      $.get(url)
      .done (data) => d.resolve data
      .fail (error) -> d.reject error
      d.promise()

    _getTargetIDs: (fn) ->
      d = new $.Deferred
      url = api "roomsUsersShow", @roomID
      data = {user_id: @userID}
      console.log "data", data
      $.get(url, data)
      .done (data) => d.resolve data
      .fail (error) -> d.reject error
      d.promise()

    _deletePeer: (userID) ->
      url = api "roomsUsersDestroy", @roomID, userID
      $.ajax
        url: url
        method: "delete"
      .done -># console.log "_deletePeer", id

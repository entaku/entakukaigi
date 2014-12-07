window.requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame
window.cancelAnimationFrame = window.cancelAnimationFrame || window.webkitCancelAnimationFrame
window.AudioContext = window.AudioContext || window.webkitAudioContext

liveInput = true
makeDistortionCurve = (amount) ->
  k = (if typeof amount is "number" then amount else 50)
  n_samples = 44100
  curve = new Float32Array(n_samples)
  deg = Math.PI / 180
  i = 0
  x = undefined
  while i < n_samples
    x = i * 2 / n_samples - 1
    curve[i] = (3 + k) * x * 20 * deg / (Math.PI + k * Math.abs(x))
    ++i
  curve

class @VoiceChanger
  constructor: (stream) ->
    audioCtx = new (window.AudioContext or window.webkitAudioContext)()
    microphone = audioCtx.createMediaStreamSource(stream)
    distortion = audioCtx.createWaveShaper()
    gainNode = audioCtx.createGain()
    biquadFilter = audioCtx.createBiquadFilter()
    convolver = audioCtx.createConvolver()
    biquadFilter.connect(convolver);
    convolver.connect(gainNode)
    gainNode.connect(audioCtx.destination)

    distortion.curve = new Float32Array
    distortion.oversample = "4x"
    biquadFilter.gain.value = 0
    convolver.buffer = `undefined`
    distortion.curve = makeDistortionCurve(1000)
    microphone.connect distortion
    distortion.connect audioCtx.destination
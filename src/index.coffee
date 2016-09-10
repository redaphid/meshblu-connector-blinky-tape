_               = require 'lodash'
{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-blinky-tape:index')
BlinkyTape      = require 'blinky-tape'

class Connector extends EventEmitter
  constructor: ->

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    return callback() unless @blinkyTape?
    @blinkyTape.close callback

  onConfig: (device={}) =>
    debug 'onConfig', device
    { options, desiredState } = device
    @_initializeBlinkyTape options, (error) =>
      return @emit 'error', error if error?
      @blinkyTape.ledStates = desiredState.leds || []
      @blinkyTape.sync()


  _initializeBlinkyTape: (options, callback) =>
    return callback() if _.isEqual options, @options
    @close =>
      @options = options
      @blinkyTape = new BlinkyTape @options
      @blinkyTape.connect callback

  start: (device, callback) =>
    debug 'started'
    @onConfig device
    callback()

module.exports = Connector

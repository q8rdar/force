_         = require 'underscore'
Backbone  = require 'backbone'

module.exports = class PersonalizeState extends Backbone.Model
  defaults:
    _steps:
      casual: ['collect', 'location', 'galleries', 'institutions', 'artists']
      collector: ['collect', 'location', 'artists', 'galleries', 'institutions', 'price_range']
    levels: ['Yes, I buy art', 'Interested in starting', 'Just looking and learning']
    track: 'collector'
    current_step: 'collect'
    current_level: 2 # Interested in starting

  initialize: ->
    super
    @listenTo this, 'transition:next', @next

  get: (attr) ->
    return @get('_steps')[@get('track')] if attr is 'steps'
    super

  setStep: (step) ->
    @set 'current_step', step

  setLevel: (level) ->
    @set 'track', @chooseTrack(level)
    @set 'current_level', level

  chooseTrack: (level) ->
    if level is 1 then 'casual' else 'collector'

  currentStepIndex: ->
    _.indexOf @get('steps'), @get('current_step')

  stepDisplay: ->
    "Step #{(@currentStepIndex())} of #{@get('steps').length - 1}"

  almostDone: ->
    @currentStepIndex() is @get('steps').length - 1

  next: ->
    if @currentStepIndex() + 1 >= @get('steps').length
      @trigger 'done'
      return

    @set 'current_step', @get('steps')[@currentStepIndex() + 1]

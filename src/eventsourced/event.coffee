IdentityGenerator = require './identity_generator'

class Event
  @attributes: {}
  @newInstance: (attr) ->
    instance = new @(attr)
    instance.id = IdentityGenerator.new()
    instance

  constructor: (attr) ->
    @attributes = attr


module.exports = Event

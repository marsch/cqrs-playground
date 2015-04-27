IdentityGenerator = require './identity_generator'
PubSub = require '../../node_modules/pubsub-js/src/pubsub'
helpers = require '../../node_modules/coffee-script/lib/coffee-script/helpers'
Command = require './command'

class EventSourced

  entityName: 'eventSourced'
  attributes: {}

  @newInstance: () ->
    instance = new @
    instance.id = IdentityGenerator.new()

    creationCommand = new Command {
      command: "create:#{instance.entityName}"
      data:
        id: instance.id
    }
    PubSub.publish 'command', creationCommand
    instance

  constructor: (attr = {}) ->
    # init instance variable
    @attributes = helpers.merge(@attributes, attr)


  startWatch: () ->
    Object.observe @attributes, @onChanges
    PubSub.subscribe "event.#{@id}", @onEvent
    console.log 'start listing to events', 'event:' + @id

  stopWatch: () ->
    Object.unobserve(@attributes, @onChanges)

  applyCommand: (command) ->
    console.log('applying command')

  applyEvent: (event) ->
    console.log('apply event')

  get: () ->
    @attributes

  set: (attr) ->
    for key, val of attr
      @attributes[key] = val
    for key of @attributes
      if !attr[key]
        delete @attributes[key]
    @attributes

  onChanges: (changes) =>
    cmds = []
    for change in changes
      command = Command.newFromChangeEvent change, @id, @entityName
      cmds.push command if command

    bulkCommand = new Command {
      command: 'bulk:commands'
      data: cmds
    }
    PubSub.publish 'command', bulkCommand
    console.log 'changes', cmds

  onEvent: () ->
    console.log 'onEvent', arguments


module.exports = EventSourced

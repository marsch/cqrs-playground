PubSub = require '../../node_modules/pubsub-js/src/pubsub'
Event = require './event'

class CommandHandler
  operationMap:
    'create': 'created'
    'update': 'updated'
    'delete': 'deleted'

  constructor: () ->
    PubSub.subscribe 'command', @onCommand

  onCommand: (topic, data) =>
    console.log 'onCommand', arguments
    if data.attributes.command == 'bulk:commands'
      @handleBulk data.attributes.data
    else
      @handleCommand data

  handleBulk: (cmds) ->
    for command in cmds
      @handleCommand command

  handleCommand: (command) ->
    # do what ever
    console.log('handleCommand', command)
    entity = command.getEntity()
    property = command.getProperty()
    eventName = @operationMap[command.getOperation()]

    event = Event.newInstance({
      event: "#{entity}:#{property}:#{eventName}"
      data: command.attributes.data
      commandId: command.id
    })
    eventTopic = "event:#{command.attributes.data.id}"
    PubSub.publish(eventTopic, event)
    console.log('new event', event)
    console.log 'publishiung', eventTopic
    # than event

module.exports = CommandHandler

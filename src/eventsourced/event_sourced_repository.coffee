
EventSourced = require './event_sourced'

class EventSourcedRepository
  entityName: 'eventSourced'
  entityClass: EventSourced

  constructor: () ->
    @instances = {}

  add: (id, attr) ->
    if @instances[id]
      # already in
      return
    @instances[id] = new @entityClass attr

  getAll: () ->
    @instances

  get: (id) ->
    @instances[id]

  remove: (id) ->
    console.log('remove from repo and trigger delete on entity');


module.exports = EventSourcedRepository

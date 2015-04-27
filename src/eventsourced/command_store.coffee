PubSub = require '../../node_modules/pubsub-js/src/pubsub'
PouchDB = require '../../node_modules/pouchdb/dist/pouchdb'

# stores all local commands, just for demo-purposes
# normally this would be the write-site of the eventsourcing
# UI-applies the commands implictly optimistic in this case
# error - events should cause in a roll-back of those commands

class CommandStore
  constructor: (storeStrategy) ->
    @storeStrategy = storeStrategy

  init: () ->
    PubSub.subscribe('command', @onCommand)

  onCommand: (topic, command) =>
    @save(command);

  save: (command) ->
    @storeStrategy.save(command)

  startSync: () ->
    @storeStrategy.startSync()

  stopSync: () ->
    @storeStrategy.stopSync()


class PouchDBCommandStoreStrategy

  constructor: () ->
    @db = new PouchDB 'cqrs_commands'

  save: (command) ->
    console.log('saving command', command)
    command.attributes._id = command.id
    @db.put command.attributes

  startSync: () ->
    remoteDB = 'http://localhost:5984/cqrs_commands'
    @db.replicate.to(remoteDB, {
      live: true
      retry: true
    })
    .on 'change', @onChange
    .on 'paused', @onPause
    .on 'denied', @onDenied
    .on 'active', @onActive
    .on 'error', @onError

  stopSync: () ->
    @replication.cancel()

  onChange: () =>
    console.log 'cqrs command change event', arguments
  onPause: (err) =>
    console.log 'cqrs command sync was paused', err
  onDenied: (err) =>
    console.log 'document denied', err
  onActive: () =>
    console.log 'cqrs command sync resumed'
  onError: (err) =>
    console.log 'error', err


module.exports = {
  CommandStore: CommandStore
  PouchDBCommandStoreStrategy: PouchDBCommandStoreStrategy
}

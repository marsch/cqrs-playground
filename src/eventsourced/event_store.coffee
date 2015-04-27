PubSub = require '../../node_modules/pubsub-js/src/pubsub'
PouchDB = require '../../node_modules/pouchdb/dist/pouchdb'


# stores all events, just for demo-purposes
# normally this would be the read-side of the eventsourcing

## event downstream
class EventStore
  constructor: (readStrategy) ->
    @receiveStrategy = readStrategy

  read: () ->
    @receiveStrategy.read()

  startSync: () ->
    @receiveStrategy.startSync()

  stopSync: () ->
    @receiveStrategy.stopSync()


class PouchDBEventReadStrategy

  constructor: () ->
    @db = new PouchDB 'cqrs_events'

  read: () ->
    console.log 'not implemented'

  startSync: () ->
    @replication = remoteDB = 'http://localhost:5984/cqrs_events'
    @db.replicate.from(remoteDB, {
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



module.exports =
  EventStore: EventStore
  PouchDBEventReadStrategy: PouchDBEventReadStrategy

EventSourced = require './eventsourced/event_sourced'
EventSourcedRepository = require './eventsourced/event_sourced_repository'
CommandHandler = require './eventsourced/command_handler'
EventStore = require('./eventsourced/event_store').EventStore
PouchDBEventReadStrategy = require('./eventsourced/event_store').PouchDBEventReadStrategy
CommandStore = require('./eventsourced/command_store').CommandStore
PouchDBCommandStoreStrategy = require('./eventsourced/command_store').PouchDBCommandStoreStrategy


Command = require './eventsourced/command'

class Notecard extends EventSourced
  entityName: 'notecard'
  attributes:
    color: null
    idea: null
    name: null
    page: null
    paragraph: null
    paraphrase: null
    quote: null
    source: null

class NotecardRepository extends EventSourcedRepository
  entityClass: Notecard



commandHandler = new CommandHandler()

pouchdbStrategy = new PouchDBCommandStoreStrategy()
commandStore = new CommandStore(pouchdbStrategy)
commandStore.init()

pouchdbEvents = new PouchDBEventReadStrategy()
eventStore = new EventStore(pouchdbEvents)
eventStore.startSync()

notecardRepository = new NotecardRepository()

window.Notecard = Notecard
window.commandHandler = commandHandler
window.eventStore = eventStore
window.Command = Command
window.commandStore = commandStore
window.notecardRepository = notecardRepository

window.h = Notecard.newInstance();
window.h.startWatch();

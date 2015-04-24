EventSourced = require './eventsourced/event_sourced'
CommandHandler = require './eventsourced/command_handler'

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

new CommandHandler()

window.Notecard = Notecard


window.h = Notecard.newInstance();
window.h.startWatch();

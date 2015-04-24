just do

```
npm install
```

after this

```
gulp watch
```

or

```
gulp
```


### general idea

Entities like the notecard are created in the UI. If the method `startWatch` is called, changes in the `attributes` - object of the entity
are observed. If attributes are changed in that object through UI-bindings or something a `Command` object is created and is send to the PubSub-Eventbroker. There a `CommandHandler` listens for incoming commands, that can be local or remote or both. Once a command is handled an event object is created and is send to the PubSub-Broker again. There the entity itself is listening for incoming event (like `event:[entityID]`). Those events than need to get handled by the entity itself. The event includes the original CommandId - so that commands can be assumed as commited or even rolled back if something went wrong.

if you like to play around with it try the following in the console:

```
a = Notecard.newInstance();
a.startWatch();
a.get().color = '#FFF'
```

Note: Along the way this includes a couple of design-decisions. For instance having the `attributes` object within the entity. This allows to get a plain JavaScript-Object of the entity's property for JSON-serialization or to work with other libraries that expect those objects. `Object.observe` is used by intention, there are several polyfills for other browsers than opera or chrome. The PubSub is used as a pattern to relay those events to remote machines also via websocket or restAPIs.

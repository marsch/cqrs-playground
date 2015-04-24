IdentityGenerator = require './identity_generator'

class Command
  attributes: {}

  typeMapping:
    'add': 'create'
    'update': 'update'
    'delete': 'delete'

  @newInstance: (changeEvent, id, entityName) ->
    # init instance variable

    newValue = changeEvent.object[changeEvent.name]
    isNewValue = (changeEvent.oldValue == null || changeEvent.oldValue == undefined || changeEvent.oldValue == '')

    type = Command::typeMapping[changeEvent.type]
    if isNewValue
      hasChanged = !(newValue == '' || newValue == null || newValue == undefined)
      if (hasChanged)
        type = 'create'
      else
        return false

    attributes = {}

    attributes.data =
      id: id

    attributes.data[changeEvent.name] = newValue
    attributes.command = "#{type}:#{entityName}:#{changeEvent.name}"

    instance = new Command attributes
    instance.id = IdentityGenerator.new()
    instance

  constructor: (@attributes) ->
    @attributes = @attributes

  getEntity: () ->
    @attributes.command.split(':')[1]

  getProperty: () ->
    @attributes.command.split(':')[2]

  getOperation: () ->
    @attributes.command.split(':')[0]

module.exports = Command

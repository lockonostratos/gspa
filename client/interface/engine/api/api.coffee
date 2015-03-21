scope = logics.api

Wings.defineApp 'api',
  currentNode: -> Session.get('currentApiNode')
  insertingMember: -> scope.insertingMember.get()
  insertingMethod: -> scope.insertingMethod.get()

  events:
    "keypress input[name='apiFilter']": (event, template) ->
      if event.which is 13
        $target = $(event.currentTarget)
        if (!Session.get("currentApiNode") || event.shiftKey)
          console.log 'this is with Ctrl'
          Wings.Api.insertNode($target.val())
          $target.val('')
        else
          console.log 'this is without Ctrl'
          Wings.Api.insertNode($target.val(), Session.get("currentApiNode")._id)
          $target.val('')

    "click li.api-node": (event, template) -> Session.set "currentApiNode", @
    "click .remove-node": (event, template) ->
      smartEmptyCurrentSelection(@) if Session.get("currentApiNode")
      Wings.Api.removeNode(@_id)

    "click .wings-insert.member": -> scope.insertingMember.set(true)
    "click .wings-insert.method": -> scope.insertingMethod.set(true)

#----------------------------------------------
smartEmptyCurrentSelection = (instance) ->
  currentNode = Session.get("currentApiNode")
  loop
    (Session.set "currentApiNode"; console.log "session cleaned"; break) if currentNode._id == instance._id
    break if !currentNode.parent

    currentNode = Model.ApiNode.findOne(currentNode.parent)
    break if !currentNode
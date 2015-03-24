scope = logics.api

Wings.defineApp 'api',
  currentNode: -> Session.get('currentApiNode')
#  insertingMember: -> scope.insertingMember.get()
#  insertingMethod: -> scope.insertingMethod.get()
#  machineMethods: -> Model.ApiMachineLeaf.find {parent: Session.get('currentApiNode')?._id, leafType: Wings.Enum.nodeTypes.method}
#  machineMembers: -> Model.ApiMachineLeaf.find {parent: Session.get('currentApiNode')?._id, leafType: Wings.Enum.nodeTypes.property}

  events:
    "keyup [name='insertMemberInput']": (event, template) ->
      if event.which is 13
        model =
          name: template.ui.$insertMemberInput.val()
          parent: Session.get('currentApiNode')._id
          leafType: Wings.Enum.nodeTypes.property
        insertResult = Wings.CRUD.insert(Model.ApiMachineLeaf, model, Wings.Validators.leafCreate)
        if insertResult.valid
          template.ui.$insertMemberInput.val('')
        else
          console.log insertResult.error
      else if event.which is 27
        template.ui.$insertMemberInput.blur()

    "keyup [name='insertMethodInput']": (event, template) ->
      if event.which is 13
        model =
          name: template.ui.$insertMethodInput.val()
          parent: Session.get('currentApiNode')._id
          leafType: Wings.Enum.nodeTypes.method
        insertResult = Wings.CRUD.insert(Model.ApiMachineLeaf, model, Wings.Validators.leafCreate)
        if insertResult.valid
          template.ui.$insertMethodInput.val('')
        else
          console.log insertResult.error
      else if event.which is 27
        template.ui.$insertMethodInput.blur()

    "click .wings-insert.member": (event, template)->
      template.ui.$insertMemberWrapper.removeClass('hide')
      template.ui.$insertMemberCommand.addClass('hide')
      template.ui.$insertMemberInput.focus()

    "blur [name=insertMemberInput]": (event, template) ->
      template.ui.$insertMemberWrapper.addClass('hide')
      template.ui.$insertMemberCommand.removeClass('hide')

    "click .wings-insert.method": (event, template)->
      template.ui.$insertMethodWrapper.removeClass('hide')
      template.ui.$insertMethodCommand.addClass('hide')
      template.ui.$insertMethodInput.focus()

    "blur [name=insertMethodInput]": (event, template) ->
      template.ui.$insertMethodWrapper.addClass('hide')
      template.ui.$insertMethodCommand.removeClass('hide')
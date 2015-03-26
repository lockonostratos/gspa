Wings.CRUD.insert = (collection, model, validator = {}, extraChecks) ->
  console.log model
  isValidModel = Wings.CRUD.validate(model, validator)

  return {valid: false, error: isValidModel.error} unless isValidModel.valid
  console.log isValidModel
  resultId = collection.insert(model)
  if resultId then {valid: true, result: resultId} else {valid: false, error: 'insert fail.'}

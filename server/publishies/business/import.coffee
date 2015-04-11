Wings.Enum.importTypes =
  property: 1
  method  : 2
  example : 3

Schema.Import.before.insert (userId, importObj) ->
  importObj.discountCash = importObj.depositCash = importObj.totalPrice = importObj.finalPrice = 0
  importObj.creator      = userId
  importObj.createdAt    = new Date()

Schema.Import.before.update (userId, importObj, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updateAt = new Date()
  modifier.$set.finalPrice = (importObj.totalPrice - modifier.$set.depositCash) if _.contains(fieldNames, 'depositCash')


Schema.Import.allow
  insert: (userId, importObj)-> true if Schema.Warehouse.findOne(importObj.warehouse)
  update: (userId, importObj, fieldNames, modifier)->
#    return false if !Wings.Validators.checkValidUpdateField(fieldNames, 'importUpdateFields')
#    return false if _.contains(fieldNames, 'provider') and !Schema.Provider.findOne(modifier.$set.provider)
#    return false if _.contains(fieldNames, 'depositCash') and modifier.$set.depositCash < 0
    return true
  remove: (userId, importObj)-> true
Schema.ImportDetail.before.insert (userId, importDetail) ->
  importDetail.quality = 1 if !importDetail.quality
  importDetail.price   = 0 if !importDetail.price

  importDetail.availableQuality = importDetail.inOderQuality = importDetail.inStockQuality = importDetail.saleQuality =
    importDetail.returnSaleQuality = importDetail.importQuality = importDetail.returnImportQuality = 0

  importDetail.creator   = userId if userId
  importDetail.createdAt = new Date()

Schema.ImportDetail.before.update (userId, importDetail, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updateAt = new Date()


Schema.ImportDetail.after.insert (userId, importDetail) ->
  discount = 0
  total    = importDetail.quality * importDetail.price
  Schema.Import.update importDetail.import, $inc:{discountCash: discount, totalPrice: total, finalPrice: (total - discount)}

Schema.ImportDetail.after.update (userId, importDetail, fieldNames, modifier, options) ->
  discount = 0
  total    = (importDetail.quality * importDetail.price) - (@previous.quality * @previous.price)
  Schema.Import.update importDetail.import, $inc:{discountCash: discount, totalPrice: total, finalPrice: total - discount}

Schema.ImportDetail.after.remove (userId, importDetail) ->
  discount = 0
  total    = importDetail.quality * importDetail.price
  Schema.Import.update importDetail.import, $inc:{discountCash: discount, totalPrice: -total, finalPrice: -(total - discount)}

Schema.ImportDetail.allow
  insert: (userId, importDetail)-> true if Schema.Import.findOne(importDetail.import)
  update: (userId, importDetail, fieldNames, modifier)->
#    return false if !Wings.Validators.checkValidUpdateField(fieldNames, 'importDetailUpdateFields')
#    return false if _.contains(fieldNames, 'quality') and modifier.$set.quality < 0
#    return false if _.contains(fieldNames, 'price') and modifier.$set.price < 0
    true
  remove: (userId, importDetail)-> true
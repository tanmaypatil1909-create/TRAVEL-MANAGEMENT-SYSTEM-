@EndUserText.label: 'Purchase Order Item'
@AccessControl.authorizationCheck: #CHECK
define view entity ZC_PO_ITEM_19
  as projection on ZI_PO_ITEM_19 as PurchaseOrderItem
{
  key PoItemUuid,
      PoUuid,
      ItemNo,
     @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SO_MATERIAL_19', element: 'MaterialId' } }]
      MaterialId,
      Quantity,
      Unit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      UnitPrice,
      CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      ItemAmount,
      LocalLastChangedAt,
      _Header : redirected to parent ZC_PO_HEADER_19,
      _Material 
}

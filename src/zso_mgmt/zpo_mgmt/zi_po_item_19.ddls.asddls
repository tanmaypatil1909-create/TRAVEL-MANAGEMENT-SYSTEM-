@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PO Item'
define view entity ZI_PO_ITEM_19
  as select from zpo_item_19
  association to parent ZI_PO_HEADER_19 as _Header on $projection.PoUuid = _Header.PoUuid
  association [0..1] to ZI_SO_MATERIAL_19 as _Material on $projection.MaterialId = _Material.material_id
{
  key po_item_uuid         as PoItemUuid,
      po_uuid               as PoUuid,
      item_no               as ItemNo,
      material_id           as MaterialId,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity              as Quantity,
      unit                  as Unit,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      unit_price            as UnitPrice,
      currency_code         as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      item_amount           as ItemAmount,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Header,
      _Material
}

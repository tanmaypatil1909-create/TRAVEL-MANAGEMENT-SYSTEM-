@EndUserText.label: 'Purchase Order'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_PO_HEADER_19
  provider contract transactional_query
  as projection on ZI_PO_HEADER_19 as PurchaseOrder
{
  key PoUuid,
      @Search.defaultSearchElement: true
      PoId,
      VendorId,
      PoDate,
      CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalAmount,
      Status,
      @UI.lineItem: [{ position: 10, criticality: 'StatusCriticality' }]
      StatusText,
      @UI.hidden: true
      StatusCriticality,
      ApprovalLevelRequired,
      CurrentApprovalLevel,
      RejectionReason,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Items : redirected to composition child ZC_PO_ITEM_19
}

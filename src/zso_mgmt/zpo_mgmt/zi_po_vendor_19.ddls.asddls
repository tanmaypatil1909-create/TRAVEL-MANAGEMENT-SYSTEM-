@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Vendor Master'
define root view entity ZI_PO_VENDOR_19
  as select from zpo_vendor_19
{
  key vendor_uuid as VendorUuid,
      vendor_id   as VendorId,
      vendor_name as VendorName,
      city        as City,
      country     as Country
}

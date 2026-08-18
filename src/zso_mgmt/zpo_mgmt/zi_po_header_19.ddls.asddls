@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PO Header'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_PO_HEADER_19
  as select from zpo_header_19
  composition [0..*] of ZI_PO_ITEM_19 as _Items
  association [0..1] to ZI_PO_VENDOR_19 as _Vendor on $projection.VendorId = _Vendor.VendorId
{
  key po_uuid                  as PoUuid,
      po_id                    as PoId,
      vendor_id                as VendorId,
      po_date                  as PoDate,
      currency_code            as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_amount             as TotalAmount,
      status                   as Status,
      case status
        when 'D' then 'Draft'
        when '1' then 'Pending Approval (Level 1)'
        when '2' then 'Pending Approval (Level 2)'
        when 'A' then 'Approved'
        when 'R' then 'Rejected'
        else 'Unknown'
      end                      as StatusText,
      case status
        when 'A' then '3'
        when 'R' then '2'
        when 'D' then '0'
        else '1'
      end                      as StatusCriticality,
      approval_level_required  as ApprovalLevelRequired,
      current_approval_level   as CurrentApprovalLevel,
      rejection_reason         as RejectionReason,
      @Semantics.user.createdBy: true
      created_by               as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by           as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at            as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at      as LocalLastChangedAt,
      _Items,
      _Vendor
}

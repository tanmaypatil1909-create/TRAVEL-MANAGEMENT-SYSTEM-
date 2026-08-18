@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TP: ROOT VIEW ENTITY'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_TP_I_TRAVEL
  as select from ztp_travel
 composition of  ZL_TP_TRAVELITEM as _item 
{
  key travel_id     as TravelId,
      agency_id     as AgencyId,
      customer_id   as CustomerId,
      begin_date    as BeginDate,
      end_date      as EndDate,
      @Semantics.amount.currencyCode : 'currencyCode'
      booking_fee   as BookingFee,
      @Semantics.amount.currencyCode : 'currencyCode'
      total_price   as TotalPrice,
      currency_code as CurrencyCode,
      description   as Description,
      status        as Status,
//      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as lastchangedat,
    _item, // Make association public
      duration  as Duration
}

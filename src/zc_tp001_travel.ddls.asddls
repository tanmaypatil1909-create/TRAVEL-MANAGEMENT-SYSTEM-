@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TP: PROJECT VIEW  ON TRAVEL'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_TP001_TRAVEL
  provider contract transactional_query
  as projection on ZR_TP_I_TRAVEL
{
  key TravelId,
      @Search.defaultSearchElement: true 
      @Consumption.valueHelpDefinition: [{  entity :{ name: '/dmo/i_agency_stdVH',
                                                         element : 'AgencyID'} }]
      AgencyId,
       @Search.defaultSearchElement: true 
       @Consumption.valueHelpDefinition: [{ 
                                               entity :{ name: '/dmo/i_customer_stdVH',
                                                         element : 'CustomerID'}
                                               }]
      CustomerId,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'currencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'currencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      Status,
      lastchangedat,
      Duration, 
      _item : redirected to composition child zc_tp_travelitem  
      
}

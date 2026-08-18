@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for travel item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_tp_travelitem as projection on ZL_TP_TRAVELITEM 
{
    key ItemUuid,
    AgencyId,
    TravelId,
    CarrierId,
    ConnectionId,
    FlightDate,
    BookingId,
    PassengerFirstName,
    PassengerLastName,
    Lastchangeat,
    /* Associations */
    _travel : redirected to parent ZC_TP001_TRAVEL 
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'INTERVIEW FOR ITEM TABLE'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZL_TP_TRAVELITEM as select from ztp_travelitem
association to parent ZR_TP_I_TRAVEL as _travel 
    on $projection.TravelId = _travel.TravelId 
{
    key item_uuid as ItemUuid,
    agency_id as AgencyId,
    travel_id as TravelId,
    carrier_id as CarrierId,
    connection_id as ConnectionId,
    flight_date as FlightDate,
    booking_id as BookingId,
    passenger_first_name as PassengerFirstName,
    passenger_last_name as PassengerLastName,
    lastchangeat as Lastchangeat,
   _travel   // "Make association public 
}

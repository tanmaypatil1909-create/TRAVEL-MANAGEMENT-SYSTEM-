CLASS zcl_structured_types DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_STRUCTURED_TYPES IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " Example 1
    DATA connection_full TYPE /DMO/I_Connection.

    SELECT SINGLE
      FROM /DMO/I_Connection
      FIELDS AirlineID,
             ConnectionID,
             DepartureAirport,
             DestinationAirport,
             DepartureTime,
             ArrivalTime,
             Distance,
             DistanceUnit
      WHERE AirlineID = 'LH'
        AND ConnectionID = '0400'
      INTO @connection_full.

    out->write( connection_full ).

  ENDMETHOD.
ENDCLASS.

CLASS zcl_tp_read_internal_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TP_READ_INTERNAL_TABLE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  TYPES : BEGIN OF TY_OUTPUT ,
            CARRRIER_ID   TYPE /DMO/FLIGHT-carrier_id,
            CONNECTION_ID TYPE /DMO/FLIGHT-CONNECTION_ID,
            FLDATE        TYPE /DMO/FLIGHT-flight_date ,
            PRICE         TYPE /DMO/FLIGHT-price ,
            NAME          TYPE /DMO/CARRIER-name ,
            BOOKING       TYPE /DMO/BOOKING-booking_id,
            BOOKING_DATE  TYPE /DMO/BOOKING-FLIGHT_DATE,
            BOOKING_AMOUNT TYPE /DMO/BOOKING-flight_price,
            CUSTOMER_ID   TYPE /DMO/BOOKING-customer_id,
            CUSTOMER_NAME TYPE STRING ,

          END OF ty_OUTPUT .

      DATA : LT_OUTPUT TYPE TABLE OF TY_OUTPUT,
             LS_OUTPUT TYPE TY_OUTPUT.

      SELECT A~CARRIER_ID , A~CONNECTION_ID , A~FLIGHT_DATE , A~PRICE, B~NAME
      FROM /DMO/FLIGHT AS A JOIN /DMO/CARRIER AS B ON A~carrier_id = B~carrier_id
      INTO TABLE @DATA(LT_FLIGHT).
      IF SY-subrc EQ 0.


      SELECT
      FROM /DMO/BOOKING AS C JOIN /DMO/CUSTOMER AS D ON C~customer_id = D~customer_id
      FIELDS C~booking_id AS BOOKING ,
             C~carrier_id ,
             C~flight_date AS BOOKING_DATE ,
             C~flight_price AS BOOKING_AMOUNT ,
             D~customer_id,
             D~first_name && D~last_name AS CUSTOMER_NAME
             INTO TABLE @DATA(LT_BOOKING).

*   LOOP AT LT_FLIGHT INTO DATA(LS_FLIGHT).

*  LS_OUTPUT-CARRIER_ID = LS_FLIGHT-A-CARRIER_ID.
 ENDIF.

   out->write( lt_booking ).

  ENDMETHOD.
ENDCLASS.

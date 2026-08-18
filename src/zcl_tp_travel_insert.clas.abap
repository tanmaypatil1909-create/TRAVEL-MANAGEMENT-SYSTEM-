CLASS zcl_tp_travel_insert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TP_TRAVEL_INSERT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


INSERT  ztp_travel FROM (
  SELECT travel_id,
         agency_id,
         customer_id,
         begin_date,
         end_date,
         booking_fee,
         total_price,
         currency_code,
         description,
         status
  FROM /dmo/travel ).

  ENDMETHOD.
ENDCLASS.

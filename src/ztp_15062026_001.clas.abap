CLASS ztp_15062026_001 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*******attribute of class*******
    DATA : ms_flight TYPE /dmo/flight.   "WORKAREA AS ATTRIBUTE

    METHODS :
      display_flight .

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZTP_15062026_001 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " declaring reference variable of a class

    DATA: lo_obj TYPE REF TO ztp_15062026_001.

    " instantiating object of a class
    lo_obj = NEW ztp_15062026_001( ).

    " calling method of a class

    lo_obj->display_flight( ).
    out->write(
      EXPORTING
      data = lo_obj->ms_flight

    ).


  ENDMETHOD.


  METHOD display_flight.
*****************SELEST SINGLE TO READ ONLY ONE ROW *****************************************************
    SELECT SINGLE *
    FROM /dmo/flight
    INTO @me->ms_flight . "ME IS SELF REFERENCING SYSTEM DEFINED REFERENCE VARIABLE (OBJECT OF A CLASS)
    IF sy-subrc = 0.
    ENDIF .
  ENDMETHOD.
ENDCLASS.

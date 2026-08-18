CLASS lhc_Vendor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Vendor RESULT result.

ENDCLASS.

CLASS lhc_Vendor IMPLEMENTATION.

  METHOD get_instance_authorizations.
    result = VALUE #( FOR key IN keys
      ( %tky = key-%tky ) ).
  ENDMETHOD.

ENDCLASS.

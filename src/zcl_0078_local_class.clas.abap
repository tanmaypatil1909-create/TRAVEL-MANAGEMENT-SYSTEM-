CLASS zcl_0078_local_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_0078_LOCAL_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  DATA CONNECTION TYPE REF TO lcl_connection.

  connection = new #(  ).

  connection->carrier_id = 'lh'.
  connection->connection_id = '0400'.


  ENDMETHOD.
ENDCLASS.

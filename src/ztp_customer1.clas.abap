CLASS ztp_customer1 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    METHODS get_all_customers
      RETURNING VALUE(rt_customers) TYPE zt19_customer1.
ENDCLASS.



CLASS ZTP_CUSTOMER1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_result TYPE zt19_customer1.

    lt_result = get_all_customers( ).

    LOOP AT lt_result INTO DATA(ls_cust).
      out->write( ls_cust-first_name ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_all_customers.

    SELECT *
      FROM /dmo/customer
      INTO CORRESPONDING FIELDS OF TABLE @rt_customers.

    TRY.
        DATA(ls_customer) = rt_customers[ customer_id = '000001' ].
    CATCH cx_sy_itab_line_not_found.
        " not found
    ENDTRY.

  ENDMETHOD.
ENDCLASS.

CLASS zcl_tp_010726 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TP_010726 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DATA : LT_EMPLOYEE TYPE TABLE OF ZTP_EMPLOYEE.

  lt_employee = value #( (  client = sy-mandt
                            emp_id = 'E0001'
                            FNAME = 'VIJAY'
                            LNAME = 'SHUKLA'
                            currencycode = 'INR'
                            salary = 20000
                            DOB = '20040919' )
                            (  client = sy-mandt
                            emp_id = 'E0002'
                            FNAME = 'RAJU'
                            LNAME = 'RASTOGI'
                            currencycode = 'INR'
                            salary = 20000
                            DOB = '20050820'  )
                             ).

      LOOP AT LT_EMPLOYEE INTO DATA(LS_EMPLOYEE).
      INSERT ZTP_EMPLOYEE FROM @LS_EMPLOYEE.
      ENDLOOP.
  ENDMETHOD.
ENDCLASS.

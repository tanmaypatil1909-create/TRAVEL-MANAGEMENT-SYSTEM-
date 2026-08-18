CLASS zcm_tp_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC INHERITING FROM cx_static_check.

  PUBLIC SECTION .
*
*   INTERFACES if_message .
    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS : BEGIN OF already_canceled,
                  msgid TYPE symsgid VALUE '/LRN/S4D437',
                  msgno TYPE symsgno VALUE '130',
                  attr1 TYPE scx_attrname VALUE 'Travel is already Canceled',
                  attr2 TYPE scx_attrname VALUE '',
                  attr3 TYPE scx_attrname VALUE '',
                  attr4 TYPE scx_attrname VALUE '',
                END OF already_canceled ,


                BEGIN OF customer_not_exist,
                  msgid TYPE symsgid VALUE '/LRN/S4D437',
                  msgno TYPE symsgno VALUE '150',
                  attr1 TYPE scx_attrname VALUE 'enter valid CUSTOMER',
                  attr2 TYPE scx_attrname VALUE '',
                  attr3 TYPE scx_attrname VALUE '',
                  attr4 TYPE scx_attrname VALUE '',
                END OF customer_not_exist,

                BEGIN OF field_empty ,
                  msgid TYPE symsgid VALUE '/LRN/S4D437',
                  msgno TYPE symsgno VALUE '140',
                  attr1 TYPE scx_attrname VALUE 'please enter value',
                  attr2 TYPE scx_attrname VALUE '',
                  attr3 TYPE scx_attrname VALUE '',
                  attr4 TYPE scx_attrname VALUE '',
                END OF field_empty  ,

                BEGIN OF begin_date_past ,
                 msgid TYPE symsgid VALUE '/LRN/S4D437',
                  msgno TYPE symsgno VALUE '120',
                  attr1 TYPE scx_attrname VALUE 'please enter value',
                  attr2 TYPE scx_attrname VALUE '',
                  attr3 TYPE scx_attrname VALUE '',
                  attr4 TYPE scx_attrname VALUE '',
                END OF begin_date_past ,

                BEGIN OF end_date_past ,
                  msgid TYPE symsgid VALUE '/LRN/S4D437',
                  msgno TYPE symsgno VALUE '120',
                  attr1 TYPE scx_attrname VALUE 'please enter value',
                  attr2 TYPE scx_attrname VALUE '',
                  attr3 TYPE scx_attrname VALUE '',
                  attr4 TYPE scx_attrname VALUE '',
                END OF end_date_past ,

                BEGIN OF sequence_d ,
                   msgid TYPE symsgid VALUE '/LRN/S4D437',
                  msgno TYPE symsgno VALUE '120',
                  attr1 TYPE scx_attrname VALUE 'please enter value',
                  attr2 TYPE scx_attrname VALUE '',
                  attr3 TYPE scx_attrname VALUE '',
                  attr4 TYPE scx_attrname VALUE '',
                END OF sequence_d  .


    METHODS constructor
      IMPORTING
        !textid  LIKE if_t100_message=>t100key OPTIONAL
*    !previous LIKE previous OPTIONAL .
        severity LIKE if_abap_behv_message~m_severity OPTIONAL
        customer TYPE /dmo/customer_id OPTIONAL.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCM_TP_TRAVEL IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor(
    previous = previous ).
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.

    ENDIF.
    IF severity IS INITIAL.
      if_abap_behv_message~m_severity = if_abap_behv_message~severity-error.
    ELSE.
      if_abap_behv_message~m_severity = severity.
    ENDIF.
    IF customer IS INITIAL .
      if_abap_behv_message~m_severity = if_abap_behv_message~severity-error.
    ELSE.
      if_abap_behv_message~m_severity = severity.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

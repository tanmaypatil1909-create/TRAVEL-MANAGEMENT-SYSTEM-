CLASS lhc_ZR_tp_I_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_tp_i_travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zr_tp_i_travel RESULT result.

    METHODS cancel_travel FOR MODIFY
      IMPORTING keys FOR ACTION zr_tp_i_travel~cancel_travel.

    METHODS issue_messages FOR MODIFY
      IMPORTING keys FOR ACTION zr_tp_i_travel~issue_message.
    METHODS validatecustomerid FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tp_i_travel~validatecustomer.

    METHODS validatedescription FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tp_i_travel~validatedescription.
    METHODS validatebegindate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tp_i_travel~validatebegindate.

    METHODS validateenddate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tp_i_travel~validateenddate.

    METHODS validateDateSequence
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR zr_tp_i_travel~validateDateSequence.
    METHODS determineStatus FOR DETERMINE ON save
      IMPORTING keys FOR zr_tp_i_travel~determineStatus.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_tp_i_travel RESULT result.
    METHODS determineduration FOR DETERMINE ON save
      IMPORTING keys FOR zr_tp_i_travel~determineduration.

    METHODS earlynumbering_create
      FOR NUMBERING
      IMPORTING entities
      FOR CREATE  zr_tp_i_travel.

ENDCLASS.

CLASS lhc_zr_tp_i_travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
   IF requested_authorizations-%create = if_abap_behv=>mk-on.

    result-%create = if_abap_behv=>auth-allowed.

  ENDIF.
  ENDMETHOD.

*---------------------------------------------------------------------------*
*                      Cancel Travel Method                                 *
*---------------------------------------------------------------------------*
  METHOD cancel_travel.

    READ ENTITIES OF zr_tp_i_travel IN LOCAL MODE
    ENTITY zr_tp_i_travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<travel>).
      IF <travel>-status <> 'C'.
        MODIFY ENTITIES OF zr_tp_i_travel IN LOCAL MODE
         ENTITY zr_tp_i_travel
         UPDATE
         FIELDS ( status )
         WITH VALUE #( ( %tky   = <travel>-%tky
                          status = 'C' ) ).
      ELSE.
        APPEND VALUE #( %tky = <travel>-%tky
                         ) to failed-zr_tp_i_travel.
        APPEND VALUE #(  %tky = <travel>-%tky
*  %msg = NEW /LRN/CM_S4D437( *           textid = *             /LRN/CM_S4D437=>already_canceled )
  %msg = NEW zcm_tp_travel(
                             textid =   zcm_tp_travel=>already_canceled )  )
         TO reported-zr_tp_i_travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

*---------------------------------------------------------------------------*
*                      Issue_Messages Method                                *
*---------------------------------------------------------------------------*

  METHOD issue_messages.
  ENDMETHOD.

*---------------------------------------------------------------------------*
*                    ValidatecustomerID Method                              *
*---------------------------------------------------------------------------*

  METHOD validatecustomerId.
  CONSTANTS c_area TYPE string VALUE `CUST`.
    READ ENTITIES OF zr_tp_i_travel IN LOCAL MODE
        ENTITY zr_tp_i_travel
          FIELDS ( CustomerId )
          WITH CORRESPONDING #( keys )
          RESULT DATA(travels).
      LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
        IF <travel>-CustomerId IS INITIAL.
          APPEND VALUE #(  %tky = <travel>-%tky )
            TO failed-zr_tp_i_travel.
          APPEND VALUE #( %tky                = <travel>-%tky
                          %msg                = NEW zcm_tp_travel(
                                 textid =     zcm_tp_travel=>field_empty )
                          %element-CustomerId = if_abap_behv=>mk-on
                           %state_area = c_area )
            TO reported-ZR_tp_i_Travel.
           ELSE.
      SELECT SINGLE FROM /dmo/i_customer
        FIELDS CustomerID
        WHERE CustomerID = @<travel>-CustomerId
        INTO @DATA(dummy).
      IF sy-subrc <> 0.
        APPEND VALUE #(  %tky = <travel>-%tky )
          TO failed-ZR_tp_i_Travel.
        APPEND VALUE #( %tky                = <travel>-%tky
                        %msg                = NEW zcm_tp_travel(
                 textid     = zcm_tp_travel=>customer_not_exist
                 customer = <travel>-CustomerId )
                        %element-CustomerId = if_abap_behv=>mk-on
                        %state_area = c_area )
          TO reported-ZR_tp_i_Travel.
          ENDIF.
        ENDIF.
      ENDLOOP.
      ENDMETHOD.

*---------------------------------------------------------------------------*
*                    Validate description Method                            *
*---------------------------------------------------------------------------*

  METHOD validatedescription.
  CONSTANTS c_area TYPE string VALUE `DESC`.
  READ ENTITIES OF ZR_tp_i_Travel IN LOCAL MODE
  ENTITY ZR_tp_i_Travel
    FIELDS ( Description )
    WITH CORRESPONDING #( keys )
    RESULT DATA(travels).
  LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
   IF <travel>-Description IS INITIAL.

    APPEND VALUE #(  %tky = <travel>-%tky )
      TO failed-ZR_tp_i_Travel.

    APPEND VALUE #(  %tky = <travel>-%tky
                      %msg = NEW zcm_tp_travel(
                                                 textid =   zcm_tp_travel=>field_empty
                                                  )
                      %element-description = if_abap_behv=>mk-on
                       %state_area = c_area                             )
         TO reported-Zr_tp_i_Travel.
  ENDIF.
  ENDLOOP.
  ENDMETHOD.

*---------------------------------------------------------------------------*
*                      Validate Begindate Method                            *
*---------------------------------------------------------------------------*

  METHOD validatebegindate.

   READ ENTITIES OF Zr_tp_i_Travel IN LOCAL MODE
    ENTITY Zr_tp_i_Travel
      FIELDS ( BeginDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).
  LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
    IF <travel>-BeginDate IS INITIAL.
      APPEND VALUE #(  %tky = <travel>-%tky )
        TO failed-Zr_tp_i_Travel.
      APPEND VALUE #( %tky               = <travel>-%tky
                      %msg = NEW zcm_tp_travel(
                                         textid =   zcm_tp_travel=>begin_date_past ) )
             TO reported-Zr_tp_i_Travel.
    ELSEIF <travel>-begindate <
                      cl_abap_context_info=>get_system_date(  ).
      APPEND VALUE #(  %tky = <travel>-%tky )
        TO failed-Zr_tp_i_Travel.
      APPEND VALUE #( %tky               = <travel>-%tky
                      %msg               = NEW zcm_tp_travel(
                         textid =    zcm_tp_travel=>begin_date_past )
                     )
        TO reported-Zr_tp_i_Travel.
    ENDIF.
  ENDLOOP.

  ENDMETHOD.

*---------------------------------------------------------------------------*
*                      Validate Enddate Method                              *
*---------------------------------------------------------------------------*

  METHOD validateenddate.

  READ ENTITIES OF Zr_tp_i_Travel IN LOCAL MODE
    ENTITY Zr_tp_i_Travel
      FIELDS ( BeginDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).
  LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
    IF <travel>-BeginDate IS INITIAL.
      APPEND VALUE #(  %tky = <travel>-%tky )
        TO failed-Zr_tp_i_Travel.
      APPEND VALUE #( %tky               = <travel>-%tky
                      %msg = NEW zcm_tp_travel(
                                         textid =   zcm_tp_travel=>end_date_past ) )
             TO reported-Zr_tp_i_Travel.
    ELSEIF <travel>-begindate <
                      cl_abap_context_info=>get_system_date(  ).
      APPEND VALUE #(  %tky = <travel>-%tky )
        TO failed-Zr_tp_i_Travel.
      APPEND VALUE #( %tky               = <travel>-%tky
                      %msg               = NEW zcm_tp_travel(
                         textid =    zcm_tp_travel=>end_date_past )
                     )
        TO reported-Zr_tp_i_Travel.
    ENDIF.
  ENDLOOP.

  ENDMETHOD.

*---------------------------------------------------------------------------*
*                   Validation For date Method                              *
*---------------------------------------------------------------------------*

  METHOD validateDateSequence.

  READ ENTITIES OF Zr_tp_i_Travel IN LOCAL MODE
    ENTITY Zr_tp_i_Travel
      FIELDS ( BeginDate EndDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).
  LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
    IF <travel>-EndDate < <travel>-BeginDate.
      APPEND VALUE #( %tky = <travel>-%tky )
        TO failed-Zr_tp_i_Travel.

      APPEND VALUE #( %tky     = <travel>-%tky
                      %msg     = NEW zcm_tp_travel(
                        textid =        zcm_tp_travel=>sequence_d )
                      %element = VALUE #(
                               BeginDate = if_abap_behv=>mk-on
                               EndDate   = if_abap_behv=>mk-on ) )
        TO reported-Zr_tp_i_Travel.
    ENDIF.
  ENDLOOP.
ENDMETHOD.

*---------------------------------------------------------------------------*
*                       Early Numbering Method                              *
*---------------------------------------------------------------------------*

  METHOD earlynumbering_create.


    SELECT SINGLE MAX( travel_id ) FROM ztp_travel INTO @DATA(lv_travelid).
    mapped-Zr_tp_i_Travel = CORRESPONDING #( entities ).
    LOOP AT mapped-Zr_tp_i_Travel ASSIGNING FIELD-SYMBOL(<mapping>).

      <mapping>-TravelId = lv_travelid + 1.

    ENDLOOP.
  ENDMETHOD.

*---------------------------------------------------------------------------*
*                  Determination Method for status                          *
*---------------------------------------------------------------------------*

  METHOD determineStatus.


  READ ENTITIES OF ZR_tp_i_Travel IN LOCAL MODE
    ENTITY ZR_tp_i_Travel
      FIELDS ( Status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).
  DELETE travels WHERE Status IS NOT INITIAL.
  CHECK travels IS NOT INITIAL.
  MODIFY ENTITIES OF ZR_tp_i_Travel IN LOCAL MODE
    ENTITY ZR_tp_i_Travel
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR key IN travels ( %tky   = key-%tky
                                         Status = 'N' )  )
      REPORTED DATA(update_reported).
  reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

*---------------------------------------------------------------------------*
*                     Instance Features Method                              *
*---------------------------------------------------------------------------*

  METHOD get_instance_features.

    READ ENTITIES OF ZR_tp_i_Travel IN LOCAL MODE
    ENTITY ZR_tp_i_Travel
    FIELDS ( Status BeginDate EndDate customerid )
    WITH CORRESPONDING #( keys )
    RESULT DATA(travels).
    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
      APPEND CORRESPONDING #( <travel> ) TO result
      ASSIGNING FIELD-SYMBOL(<result>).
*
*    IF <travel>-%is_draft = if_abap_behv=>mk-on.
*
*    READ ENTITIES OF ZR_mm_i_Travel IN LOCAL MODE
*      ENTITY ZR_mm_i_Travel
*        FIELDS ( BeginDate EndDate )
*        WITH VALUE #( ( %key = <travel>-%key ) )
*        RESULT DATA(travels_active).
*
*    IF travels_active IS NOT INITIAL.
*      <travel>-BeginDate = travels_active[ 1 ]-BeginDate.
*      <travel>-EndDate   = travels_active[ 1 ]-EndDate.
*    ELSE.
*      CLEAR <travel>-BeginDate.
*      CLEAR <travel>-EndDate.
*    ENDIF.
*  ENDIF.



      IF <travel>-Status = 'C' OR ( <travel>-EndDate IS NOT INITIAL AND <travel>-enddate < cl_abap_context_info=>get_system_date(  ) ).
        <result>-%update       = if_abap_behv=>fc-o-disabled.
        <result>-%action-cancel_travel       = if_abap_behv=>fc-o-disabled.
      ELSE.
        <result>-%update       = if_abap_behv=>fc-o-enabled.
        <result>-%action-cancel_travel       = if_abap_behv=>fc-o-enabled.
      ENDIF.

      IF <travel>-BeginDate IS NOT INITIAL AND
      <travel>-begindate < cl_abap_context_info=>get_system_date(  ).
        <result>-%field-begindate = if_abap_behv=>fc-f-read_only.
        <result>-%field-CustomerId = if_abap_behv=>fc-f-read_only.
      ELSE.
        <result>-%field-begindate = if_abap_behv=>fc-f-mandatory.
        <result>-%field-CustomerId = if_abap_behv=>fc-f-mandatory.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

*---------------------------------------------------------------------------*
*                           Duration Method                                 *
*---------------------------------------------------------------------------*

  METHOD determineDuration.
  READ ENTITIES OF ZR_tp_i_Travel IN LOCAL MODE
    ENTITY ZR_tp_i_Travel
      FIELDS (  BeginDate EndDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels).
  LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
    <travel>-Duration = <travel>-EndDate - <travel>-BeginDate.
  ENDLOOP.
  MODIFY ENTITIES OF ZR_tp_i_Travel IN LOCAL MODE
    ENTITY ZR_tp_i_Travel
      UPDATE
      FIELDS ( Duration )
      WITH CORRESPONDING #( travels ).
ENDMETHOD.

ENDCLASS.

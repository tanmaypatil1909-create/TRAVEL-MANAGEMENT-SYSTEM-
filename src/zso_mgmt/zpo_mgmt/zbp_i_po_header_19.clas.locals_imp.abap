CLASS lhc_PurchaseOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.


    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR PurchaseOrder RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PurchaseOrder RESULT result.

    METHODS Approve FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~Approve RESULT result.

    METHODS Reject FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~Reject RESULT result.

    METHODS SubmitForApproval FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~SubmitForApproval RESULT result.

    METHODS DetermineApprovalLevel FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PurchaseOrder~DetermineApprovalLevel.
    METHODS ValidateVendor FOR VALIDATE ON SAVE
      IMPORTING keys FOR PurchaseOrder~ValidateVendor.
    METHODS SetPoId FOR DETERMINE ON SAVE
      IMPORTING keys FOR PurchaseOrder~SetPoId.

ENDCLASS.

CLASS lhc_PurchaseOrder IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    result = VALUE #( FOR h IN lt_header
      ( %tky = h-%tky
        %action-SubmitForApproval = COND #( WHEN h-Status = 'D'
                                             THEN if_abap_behv=>fc-o-enabled
                                             ELSE if_abap_behv=>fc-o-disabled )
        %action-Approve           = COND #( WHEN h-Status = '1' OR h-Status = '2'
                                             THEN if_abap_behv=>fc-o-enabled
                                             ELSE if_abap_behv=>fc-o-disabled )
        %action-Reject            = COND #( WHEN h-Status = '1' OR h-Status = '2'
                                             THEN if_abap_behv=>fc-o-enabled
                                             ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
    result = VALUE #( FOR key IN keys
      ( %tky                     = key-%tky
        %update                  = if_abap_behv=>auth-allowed
        %delete                  = if_abap_behv=>auth-allowed
        %action-Approve          = if_abap_behv=>auth-allowed
        %action-Reject           = if_abap_behv=>auth-allowed
        %action-SubmitForApproval = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD SubmitForApproval.
    READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( ApprovalLevelRequired )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_PO_HEADER_19.

    LOOP AT lt_header INTO DATA(ls_header).
      APPEND VALUE #( %tky = ls_header-%tky
                       Status = COND #( WHEN ls_header-ApprovalLevelRequired = 0 THEN 'A' ELSE '1' )
                       CurrentApprovalLevel = 0 )
        TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( Status CurrentApprovalLevel )
        WITH lt_update
      REPORTED DATA(ls_reported).

    result = VALUE #( FOR h IN lt_header ( %tky = h-%tky ) ).
  ENDMETHOD.

  METHOD Approve.
    READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( CurrentApprovalLevel ApprovalLevelRequired )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_PO_HEADER_19.

    LOOP AT lt_header INTO DATA(ls_header).
      DATA(lv_new_level) = ls_header-CurrentApprovalLevel + 1.
      APPEND VALUE #( %tky = ls_header-%tky
                       CurrentApprovalLevel = lv_new_level
                       Status = COND #( WHEN lv_new_level >= ls_header-ApprovalLevelRequired
                                        THEN 'A' ELSE '2' ) )
        TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( Status CurrentApprovalLevel )
        WITH lt_update
      REPORTED DATA(ls_reported).

    result = VALUE #( FOR h IN lt_header ( %tky = h-%tky ) ).
  ENDMETHOD.

  METHOD Reject.
    DATA lt_update TYPE TABLE FOR UPDATE ZI_PO_HEADER_19.

    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( %tky = ls_key-%tky
                       Status = 'R'
                       RejectionReason = ls_key-%param-RejectionReason )
        TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( Status RejectionReason )
        WITH lt_update
      REPORTED DATA(ls_reported).

    result = VALUE #( FOR k IN keys ( %tky = k-%tky ) ).
  ENDMETHOD.

  METHOD DetermineApprovalLevel.
    READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( TotalAmount )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_PO_HEADER_19.

    LOOP AT lt_header INTO DATA(ls_header).
      APPEND VALUE #( %tky = ls_header-%tky
                       ApprovalLevelRequired = COND #(
                         WHEN ls_header-TotalAmount < 10000 THEN 0
                         WHEN ls_header-TotalAmount <= 50000 THEN 1
                         ELSE 2 ) )
        TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( ApprovalLevelRequired )
        WITH lt_update
      REPORTED DATA(ls_reported).
  ENDMETHOD.

 METHOD ValidateVendor.
  READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
    ENTITY PurchaseOrder
      FIELDS ( VendorId )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

  DATA lt_vendor_id TYPE SORTED TABLE OF zpo_vendor_19-vendor_id WITH UNIQUE KEY table_line.
  LOOP AT lt_header INTO DATA(ls_header) WHERE VendorId IS NOT INITIAL.
    INSERT ls_header-VendorId INTO TABLE lt_vendor_id.
  ENDLOOP.

  IF lt_vendor_id IS NOT INITIAL.
    SELECT vendor_id FROM zpo_vendor_19
      FOR ALL ENTRIES IN @lt_vendor_id
      WHERE vendor_id = @lt_vendor_id-table_line
      INTO TABLE @DATA(lt_existing_vendor).
  ENDIF.

  LOOP AT lt_header INTO ls_header.
    APPEND VALUE #( %tky = ls_header-%tky ) TO reported-purchaseorder.

   IF ls_header-VendorId IS INITIAL
       OR NOT line_exists( lt_existing_vendor[ vendor_id = ls_header-VendorId ] ).
      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-purchaseorder.
      APPEND VALUE #( %tky = ls_header-%tky
                       %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = |Vendor { ls_header-VendorId } does not exist| )
                       %element-VendorId = if_abap_behv=>mk-on )
        TO reported-purchaseorder.
    ENDIF.
  ENDLOOP.
ENDMETHOD.

METHOD setpoid.
  DATA lt_update TYPE TABLE FOR UPDATE zi_po_header_19.
  DATA lv_counter TYPE i VALUE 1000.

  LOOP AT keys INTO DATA(ls_key).
    lv_counter = lv_counter + 1.
    APPEND VALUE #( %tky = ls_key-%tky
                     PoId = |PO{ lv_counter }| )
      TO lt_update.
  ENDLOOP.

  MODIFY ENTITIES OF zi_po_header_19 IN LOCAL MODE
    ENTITY purchaseorder
    UPDATE FIELDS ( PoId )
    WITH lt_update
    REPORTED DATA(ls_reported).
ENDMETHOD.
ENDCLASS.

CLASS lhc_PurchaseOrderItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateItemAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR PurchaseOrderItem~CalculateItemAmount.
    METHODS ValidateItemLock FOR VALIDATE ON SAVE
      IMPORTING keys FOR PurchaseOrderItem~ValidateItemLock.

ENDCLASS.

CLASS lhc_PurchaseOrderItem IMPLEMENTATION.

 METHOD CalculateItemAmount.
  READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
    ENTITY PurchaseOrderItem
      FIELDS ( Quantity UnitPrice PoUuid )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

  IF lt_item IS INITIAL.
    RETURN.
  ENDIF.

  DATA lt_item_update TYPE TABLE FOR UPDATE ZI_PO_ITEM_19.
  LOOP AT lt_item INTO DATA(ls_item).
    APPEND VALUE #( %tky = ls_item-%tky
                     ItemAmount = ls_item-Quantity * ls_item-UnitPrice )
      TO lt_item_update.
  ENDLOOP.

  MODIFY ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
    ENTITY PurchaseOrderItem
      UPDATE FIELDS ( ItemAmount )
      WITH lt_item_update
    REPORTED DATA(ls_item_reported).

  " Recalculate header total for each affected PO
  DATA lt_po_uuid TYPE SORTED TABLE OF sysuuid_x16 WITH UNIQUE KEY table_line.
  LOOP AT lt_item INTO ls_item.
    INSERT ls_item-PoUuid INTO TABLE lt_po_uuid.
  ENDLOOP.

  DATA lt_header_update TYPE TABLE FOR UPDATE ZI_PO_HEADER_19.
  LOOP AT lt_po_uuid INTO DATA(lv_po_uuid).
    READ ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
      ENTITY PurchaseOrder BY \_Items
        FIELDS ( ItemAmount )
        WITH VALUE #( ( PoUuid = lv_po_uuid ) )
      RESULT DATA(lt_all_items).

    DATA(lv_total) = REDUCE zpo_header_19-total_amount(
                        INIT sum = 0
                        FOR itm IN lt_all_items
                        NEXT sum = sum + itm-ItemAmount ).

    APPEND VALUE #( PoUuid = lv_po_uuid
                     TotalAmount = lv_total )
      TO lt_header_update.
  ENDLOOP.

  MODIFY ENTITIES OF ZI_PO_HEADER_19 IN LOCAL MODE
    ENTITY PurchaseOrder
      UPDATE FIELDS ( TotalAmount )
      WITH lt_header_update
    REPORTED DATA(ls_header_reported).
ENDMETHOD.

METHOD validateitemlock.
  READ ENTITIES OF zi_po_header_19 IN LOCAL MODE
    ENTITY PurchaseOrderItem
      FIELDS ( PoUuid )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

  DATA lt_po_uuid TYPE SORTED TABLE OF sysuuid_x16 WITH UNIQUE KEY table_line.
  LOOP AT lt_item INTO DATA(ls_item).
    INSERT ls_item-PoUuid INTO TABLE lt_po_uuid.
  ENDLOOP.

  IF lt_po_uuid IS NOT INITIAL.
    READ ENTITIES OF zi_po_header_19 IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( Status )
        WITH VALUE #( FOR uuid IN lt_po_uuid ( PoUuid = uuid ) )
      RESULT DATA(lt_header).
  ENDIF.

  LOOP AT lt_item INTO ls_item.
    READ TABLE lt_header INTO DATA(ls_header)
      WITH KEY PoUuid = ls_item-PoUuid.

    APPEND VALUE #( %tky = ls_item-%tky ) TO reported-purchaseorderitem.

    IF sy-subrc = 0 AND ls_header-Status <> 'D'. " match your actual Draft status literal
      APPEND VALUE #( %tky = ls_item-%tky ) TO failed-purchaseorderitem.
      APPEND VALUE #( %tky = ls_item-%tky
                       %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = |Item cannot be changed once approval has started| ) )
        TO reported-purchaseorderitem.
    ENDIF.
  ENDLOOP.
ENDMETHOD.
ENDCLASS.

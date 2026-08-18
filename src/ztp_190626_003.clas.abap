CLASS ztp_190626_003 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZTP_190626_003 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* DATA number1 TYPE i.
*  DATA number2 TYPE i.
*  DATA result TYPE p LENGTH 8 DECIMALS 2.
    DATA output TYPE TABLE OF string .
*  DATA op TYPE c.
*
*   number1 = 20.
*   number2 =  30.
*   op = '*'.
*
*   CASE op.
*   WHEN '+'.
*   result = number1 + number2.
*   WHEN '-'.
*   result = number1 - number2.
*   WHEN '*'.
*   result = number1 * number2.
*   WHEN '/'.
*    TRY .
*         result = number1 / number2.
*          CATCH cx_sy_zerodivide.
*           output = |Division by zero is not defined|.
*             ENDTRY.
*               WHEN OTHERS.
*                output = |'{ op }' is not a valid operator!|.
*                  ENDCASE.
*
*   IF output IS INITIAL.  "no error so far
*   output = |{ number1 } { op } { number2 } = { result }|.
*   ENDIF.
*
*      out->write( output ).
    CONSTANTS max_count TYPE i VALUE 20.
    DATA numbers TYPE TABLE OF i.

    DO max_count TIMES.




    CASE sy-index.
      WHEN 1.
        APPEND 0 TO numbers.
      WHEN 2.
        APPEND 1 TO numbers.
      WHEN OTHERS.
        APPEND numbers[  sy-index - 2 ]               + numbers[  sy-index - 1 ]
           TO numbers.
    ENDCASE.

ENDDO.



    DATA(counter) = 0.
    LOOP AT numbers INTO DATA(number).

      counter = counter + 1.
      APPEND |{ counter WIDTH = 4 }: { number WIDTH = 10 ALIGN = RIGHT }|
       TO output.
    ENDLOOP.

    out->write(
     data   = output

       name   = |The first { max_count } Fibonacci Numbers|
         ) .

  ENDMETHOD.
ENDCLASS.

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROOT VIEW FOR EMPLOYEE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_TP_I_EMPLOYEE as select from ztp_employee
//composition of target_data_source_name as _association_name
{
    key emp_uuid as EmpUuid,
    emp_id as EmpId,
    fname as Fname,
    lname as Lname,
    currencycode as Currencycode,
     @Semantics.amount.currencyCode : 'currencycode'
    salary as Salary,
    dob as Dob,
    age as Age,
    changedby as Changedby,
    lastchangedat as Lastchangedat 
//    _association_name // Make association public
}

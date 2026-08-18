@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION VIEW ENTITY FOR EMPLOYEE'
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
define root view entity ZC_TP_I_EMPLOYEE 
  provider contract transactional_query as projection on ZR_TP_I_EMPLOYEE
{
    key EmpUuid,
    EmpId,
    Fname,
    Lname,
    Currencycode,
    @Semantics.amount.currencyCode: 'CURRENCYCODE' 
    Salary,
    Dob,
    Age,
    Changedby,
    Lastchangedat
}

//////////////////////////////////////////////////////////////////////
///
/// <summary>
/// </summary>
///
///
/// <remarks>
/// </remarks>
///
///
/// <copyright>
/// Your-Company. All Rights Reserved.
/// </copyright>
///
//////////////////////////////////////////////////////////////////////
#include "..\.assets\xpp-unit\unit-test.ch"

CLASS UnitTestBankHolidayService FROM GenericTestGroup
   EXPORTED:
      METHOD testGetHolidayByIdWhenIdIsNotNil
      METHOD testGetHolidayByIdWhenIdIsNil
ENDCLASS

METHOD UnitTestBankHolidayService:testGetHolidayByIdWhenIdIsNotNil()
   //setup
   LOCAL nId        := 4
   LOCAL dExpected  := "2021-08-03"
   LOCAL dResult, oResult
   //exercise
   oResult := oTest:getHolidayById( nId )
   dResult := oResult:bank_holiday_date
   //verify
   CHECK_STR_EQUAL(dExpected, dResult)
RETURN SELF

METHOD UnitTestBankHolidayService:testGetHolidayByIdWhenIdIsNil()

RETURN SELF


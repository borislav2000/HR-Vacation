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
///
#include "..\.assets\xpp-unit\unit-test.ch"
STATIC CLASS BankHolidayControllerMock FROM BankHolidayController
   EXPORTED:
     VAR Redirections

     METHOD redirect
     METHOD getViewManager
     METHOD setViewManager
ENDCLASS

METHOD BankHolidayControllerMock:setViewManager( oViewManager )
   ::Redirections := {}

   ::Views := oViewManager
RETURN SELF

METHOD BankHolidayControllerMock:getViewManager()
RETURN ::Views

METHOD BankHolidayControllerMock:redirect( cUrl )
   AAdd( ::Redirections, cUrl )
RETURN SELF


CLASS TestBankHolidayController FROM ControllerTestGroup
   PROTECTED:
      VAR dDate
      METHOD removeAllBankHolidaysByDate
      METHOD cleanupData
   EXPORTED:
      METHOD setup()
      METHOD tearDown()

      METHOD testSaveValidInput
      METHOD testSaveInvalidInput

      METHOD testUpdateValidInput
      METHOD testUpdateInvalidInput

      METHOD testDeleteValidInput
      METHOD testDeleteInvalidInput
ENDCLASS

METHOD TestBankHolidayController:removeAllBankHolidaysByDate( dDate )
   LOCAL oBankHoliday

   oBankHoliday := BankHolidayModel():findBy("bank_holiday_date", dDate)
   DO WHILE oBankHoliday != NIL
      BankHolidayModel():delete(oBankHoliday:bank_holiday_id)
      oBankHoliday := BankHolidayModel():findBy( "bank_holiday_date", dDate )
   ENDDO
RETURN SELF

METHOD TestBankHolidayController:cleanupData()
   ::removeAllBankHolidaysByDate(::dDate)
RETURN SELF

METHOD TestBankHolidayController:setup()
   ::dDate := "2021-10-10"

   SUPER

   ::cleanupData()
RETURN SELF

METHOD TestBankHolidayController:tearDown()
    ::cleanupData()
    SUPER
RETURN SELF


METHOD TestBankHolidayController:testSaveValidInput()
   LOCAL oBankHolidayController
   LOCAL aViews

   oBankHolidayController := ::initController( BankHolidayControllerMock() )

   aViews := oBankHolidayController:getViewManager():Calls
   oBankHolidayController:save(::dDate)

   CHECK_INT_EQUAL(1, Len(aViews))
   CHECK_STR_EQUAL( "bankHolidays", aViews[1,1])
   CHECK_EQUAL({}, oBankHolidayController:Redirections)
RETURN SELF




METHOD TestBankHolidayController:testSaveInvalidInput()
   LOCAL oBankHolidayController
   LOCAL aViews, aParams

   oBankHolidayController := ::initController( BankHolidayControllerMock() )
   oBankHolidayController:getViewManager():Calls = {}
   aViews := oBankHolidayController:getViewManager():Calls

   oBankHolidayController:save(NIL)
   aParams := aViews[1,2]

   CHECK_STR_NOCASE_EQUAL("bankholidaysadd", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParams[1])

   oBankHolidayController:save("")
   CHECK_STR_NOCASE_EQUAL("bankholidaysadd", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParams[1])

   oBankHolidayController:save()
   CHECK_STR_NOCASE_EQUAL("bankholidaysadd", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParams[1])

   CHECK_EQUAL({}, oBankHolidayController:Redirections)

RETURN SELF


METHOD TestBankHolidayController:testUpdateValidInput()
   LOCAL oBankHolidayController
   LOCAL oBankHoliday, aViews

   oBankHolidayController := ::initController(BankHolidayControllerMock())
   oBankHolidayController:save(::dDate)

   oBankHolidayController:getViewManager():Calls := {}
   aViews := oBankHolidayController:getViewManager():Calls

   oBankHoliday := BankHolidayModel():findBy("bank_holiday_date", ::dDate )

   oBankHolidayController:update(::dDate, oBankHoliday:bank_holiday_id, "ala-bala")

   CHECK_INT_EQUAL( 1, Len(aViews) )
   CHECK_STR_EQUAL( "bankHolidays", aViews[1,1] )
   CHECK_EQUAL({}, oBankHolidayController:Redirections)
RETURN SELF


METHOD TestBankHolidayController:testUpdateInvalidInput()
   LOCAL oBankHolidayController
   LOCAL cResult

   oBankHolidayController := ::initController(BankHolidayControllerMock())
   oBankHolidayController:save(::dDate)

   oBankHolidayController:getViewManager():Calls = {}


   cResult := oBankHolidayController:update("","")
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oBankHolidayController:update(NIL,"")
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oBankHolidayController:update("",NIL)
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oBankHolidayController:update()
   CHECK_STR_EQUAL("Error", cResult)
RETURN SELF


METHOD TestBankHolidayController:testDeleteValidInput()
   LOCAL oBankHolidayController
   LOCAL oBankHoliday, aViews

   oBankHolidayController := ::initController(BankHolidayControllerMock())
   oBankHolidayController:save(::dDate)

   oBankHolidayController:getViewManager():Calls := {}
   aViews := oBankHolidayController:getViewManager():Calls

   oBankHoliday := BankHolidayModel():findBy("bank_holiday_date", ::dDate )

   oBankHolidayController:delete(oBankHoliday:bank_holiday_id)

   CHECK_INT_EQUAL(1, Len(aViews))
   CHECK_STR_EQUAL("bankHolidays", aViews[1,1])
   CHECK_EQUAL({}, oBankHolidayController:Redirections)
RETURN SELF


METHOD TestBankHolidayController:testDeleteInvalidInput()
   LOCAL oBankHolidayController
   LOCAL cResult

   oBankHolidayController := ::initController(BankHolidayControllerMock())
   oBankHolidayController:getViewManager():Calls = {}

   cResult := oBankHolidayController:delete(NIL)
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oBankHolidayController:delete("")
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oBankHolidayController:delete()
   CHECK_STR_EQUAL("Error", cResult)

   CHECK_EQUAL({}, oBankHolidayController:getViewManager():Calls)

   CHECK_EQUAL({}, oBankHolidayController:Redirections)

RETURN SELF



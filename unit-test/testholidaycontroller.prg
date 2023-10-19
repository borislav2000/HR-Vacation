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

STATIC CLASS HolidayControllerMock FROM HolidayController
   EXPORTED:
      VAR Redirections
      METHOD getViewManager
      METHOD setViewManager
      METHOD redirect
ENDCLASS

METHOD HolidayControllerMock:setViewManager( oViewManager )
   ::Redirections := {}
   ::Views        := oViewManager
RETURN SELF

METHOD HolidayControllerMock:getViewManager()

RETURN ::Views

METHOD HolidayControllerMock:redirect( cUrl )
   AAdd(::Redirections, cUrl)
RETURN SELF


CLASS TestHolidayController FROM ControllerTestGroup
PROTECTED:
      VAR dStartDate
      VAR cEmail
      METHOD deleteAllRequestsByStartDate
      METHOD deleteAllEmployeesByEmail
      METHOD deleteAllUsersByEmail
      METHOD cleanupData
EXPORTED:
   METHOD setup
   METHOD tearDown

   METHOD testCreateValidInput
   METHOD testCreateWhenWrongInput
   METHOD testCreateWhenDaysExceed
   METHOD testCreateWhenDatesAreNotValid


   METHOD testListValidInput
   METHOD testListInvalidInput

   METHOD testApproveValidInput
   METHOD testApproveInvalidInput

   METHOD testDeclineValidInput
   METHOD testDeclineInvalidInput

   METHOD testRetractValidInput
   METHOD testRetractInvalidInput

ENDCLASS

METHOD TestHolidayController:deleteAllRequestsByStartDate(dDate)
   LOCAL oEmployeeHoliday

   oEmployeeHoliday := EmployeeHolidayModel():findBy("start_date", dDate)
   DO WHILE NIL != oEmployeeHoliday
      EmployeeHolidayModel():delete( oEmployeeHoliday:employee_holiday_id )
      oEmployeeHoliday := EmployeeHolidayModel():findBy( "start_date", dDate )
   ENDDO
RETURN SELF

METHOD TestHolidayController:deleteAllEmployeesByEmail(cEmail1)
   LOCAL oEmployee

   oEmployee := EmployeeModel():findBy("email", cEmail1)
   DO WHILE NIL != oEmployee
      EmployeeModel():delete( oEmployee:employee_id )
      oEmployee := EmployeeModel():findBy( "email", cEmail1 )
   ENDDO
RETURN SELF

METHOD TestHolidayController:deleteAllUsersByEmail(cEmail1)
   LOCAL oUser

   oUser := UserAccountModel():findBy("email", cEmail1)
   DO WHILE NIL != oUser
       UserAccountModel():delete( oUser:account_id )
       oUser := UserAccountModel():findBy("email", cEmail1)
   ENDDO
RETURN SELF


METHOD TestHolidayController:cleanupData()
    ::deleteAllRequestsByStartDate(::dStartDate)
    ::deleteAllEmployeesByEmail(::cEmail)
     ::deleteAllUsersByEmail(::cEmail)
RETURN SELF

METHOD TestHolidayController:setup()

   ::dStartDate := "2025-05-05"
   ::cEmail     := "testmail@mail.com"
   SUPER


   ::cleanupData()

RETURN SELF

METHOD TestHolidayController:tearDown()
   ::cleanupData()

   SUPER
RETURN SELF

METHOD TestHolidayController:testCreateValidInput()
   LOCAL oHolidayController, aViews, oUser
   ManagerService():addEmployee("name1", ::cEmail, "pwd", 15, 1)
   oUser := UserService():getByEMail(::cEmail)

   ::addSessionIdToController(oUser:account_id)

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}

   oHolidayController:create(::dStartDate, "2025-05-08", "test")
   aViews := oHolidayController:getViewManager():Calls

   CHECK_STR_NOCASE_EQUAL("myholidaystable", aViews[1,1])

RETURN SELF

METHOD TestHolidayController:testCreateWhenWrongInput()
   LOCAL oHolidayController
   LOCAL aViews
   LOCAL aParams

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}
   aViews := oHolidayController:getViewManager():Calls


   oHolidayController:create("","")
   aParams := aViews[1,2]

   CHECK_STR_NOCASE_EQUAL("employeerequest", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields", aParams[1])
RETURN SELF

METHOD TestHolidayController:testCreateWhenDaysExceed()
   LOCAL oHolidayController, aViews, aParams, oUser
   ManagerService():addEmployee("name2", ::cEmail, "pwd", 4, 1)
   oUser := UserService():getByEMail(::cEmail)

   ::addSessionIdToController(oUser:account_id)

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}
   aViews := oHolidayController:getViewManager():Calls
   oHolidayController:create(::dStartDate, "2026-05-05", "test")
   aParams := aViews[1,2]

   CHECK_STR_NOCASE_EQUAL("employeerequest", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("The requested days exceed the total days per year", aParams[1])

RETURN SELF

METHOD TestHolidayController:testCreateWhenDatesAreNotValid()
   LOCAL oHolidayController, aViews, aParams, oUser
   ManagerService():addEmployee("name", ::cEmail, "pwd",50, 1)
   oUser := UserService():getByEMail(::cEmail)

   ::addSessionIdToController(oUser:account_id)

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}
   aViews := oHolidayController:getViewManager():Calls
   oHolidayController:create(::dStartDate, "2025-05-04", "test")
   aParams := aViews[1,2]

   CHECK_STR_NOCASE_EQUAL("employeerequest", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("The start date must be a future date and the end date should be a date, later than the start date", aParams[1])
RETURN SELF

METHOD TestHolidayController:testListValidInput()
   LOCAL oHolidayController
   LOCAL aViews

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}

   aViews := oHolidayController:getViewManager():Calls

   oHolidayController:list("2005-05-05", "2005-06-05", 0)
   CHECK_STR_NOCASE_EQUAL("calendarlistview", aViews[1,1])

RETURN SELF



METHOD TestHolidayController:testListInvalidInput()
   LOCAL oHolidayController
   LOCAL aViews, aParameters

   oHolidayController := ::initController(HolidayControllerMock())

   oHolidayController:getViewManager():Calls := {}
   aViews := oHolidayController:getViewManager():Calls

   oHolidayController:list("2005-05-05")
   aParameters := aViews[1,2]

   CHECK_STR_NOCASE_EQUAL("holidaycalendar", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParameters[1])

   oHolidayController:list("2005-05-05", "2005-06-05")

   CHECK_STR_NOCASE_EQUAL("holidaycalendar", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParameters[1])

   oHolidayController:list("2005-06-05", 1)

   CHECK_STR_NOCASE_EQUAL("holidaycalendar", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParameters[1])

RETURN SELF

METHOD TestHolidayController:testApproveValidInput()
  LOCAL oHolidayController, oHoliday,aViews
  oHolidayController := ::initController(HolidayControllerMock())

  oHolidayController:create(::dStartDate, "2025-05-06", "test")
  oHoliday := EmployeeHolidayModel():findBy("start_date", ::dStartDate)
  oHolidayController:getViewManager():Calls := {}
  aViews := oHolidayController:getViewManager():Calls

  oHolidayController:approve( oHoliday:employee_holiday_id  )
  CHECK_STR_NOCASE_EQUAL("holidayrequestsmain", aViews[1,1] )

  CHECK_EQUAL({}, oHolidayController:Redirections)

RETURN SELF

METHOD TestHolidayController:testApproveInvalidInput()
   LOCAL oHolidayController

   LOCAL cResult
  oHolidayController := ::initController(HolidayControllerMock())


  oHolidayController:getViewManager():Calls := {}


  cResult := oHolidayController:approve( "" )
  CHECK_UNDEFINED_TYPE(cResult )

  cResult := oHolidayController:approve( NIL )
  CHECK_UNDEFINED_TYPE(cResult )

  CHECK_EQUAL({}, oHolidayController:Redirections)
RETURN SELF

METHOD TestHolidayController:testDeclineValidInput()
   LOCAL oHolidayController
   LOCAL oHoliday
   LOCAL aViews
   LOCAL oUser

    ManagerService():addEmployee("name", ::cEmail, "pwd", 50, 1)
   oUser := UserService():getByEMail(::cEmail)

   ::addSessionIdToController(oUser:account_id)

  oHolidayController := ::initController(HolidayControllerMock())

  oHolidayController:create(::dStartDate, "2025-05-05", "test")
  oHoliday := EmployeeHolidayModel():findBy("start_date", ::dStartDate)
  oHolidayController:getViewManager():Calls := {}
  aViews := oHolidayController:getViewManager():Calls

  oHolidayController:decline( oHoliday:employee_holiday_id  )
  CHECK_STR_NOCASE_EQUAL("holidayrequestsmain", aViews[1,1] )

  CHECK_EQUAL({}, oHolidayController:Redirections)
RETURN SELF



METHOD TestHolidayController:testDeclineInvalidInput()
   LOCAL oHolidayController
   LOCAL cResult

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}


   cResult := oHolidayController:decline( "" )
   CHECK_UNDEFINED_TYPE(cResult )

   cResult := oHolidayController:decline( NIL )
   CHECK_UNDEFINED_TYPE(cResult )

   CHECK_EQUAL({}, oHolidayController:Redirections)
RETURN SELF

METHOD TestHolidayController:testRetractValidInput()
   LOCAL oHolidayController
   LOCAL oHoliday
   LOCAL aViews

   oHolidayController := ::initController(HolidayControllerMock())

   oHolidayController:create(::dStartDate, "2025-05-06", "test")
   oHoliday := EmployeeHolidayModel():findBy("start_date", ::dStartDate)
   oHolidayController:getViewManager():Calls := {}
   aViews := oHolidayController:getViewManager():Calls

   oHolidayController:retract( oHoliday:employee_holiday_id  )
   CHECK_STR_NOCASE_EQUAL("myholidaystable", aViews[1,1] )

   CHECK_EQUAL({}, oHolidayController:Redirections)
RETURN SELF


METHOD TestHolidayController:testRetractInvalidInput()
   LOCAL oHolidayController
   LOCAL cResult

   oHolidayController := ::initController(HolidayControllerMock())
   oHolidayController:getViewManager():Calls := {}


   cResult := oHolidayController:retract( "" )
   CHECK_UNDEFINED_TYPE(cResult )

   cResult := oHolidayController:retract( NIL )
   CHECK_UNDEFINED_TYPE(cResult )

   CHECK_EQUAL({}, oHolidayController:Redirections)
RETURN SELF



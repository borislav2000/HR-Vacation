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

// Readme: Derive a mock class from each controller so the view manager (::Views)
//         can be accessed. This will also collect all invokations to :redirect()
STATIC CLASS EmployeeControllerMock FROM EmployeeController
   EXPORTED:
     VAR Redirections

     METHOD redirect
     METHOD getViewManager
     METHOD setViewManager
ENDCLASS

METHOD EmployeeControllerMock:setViewManager( oViewManager )
   ::Redirections := {}

   ::Views := oViewManager
RETURN SELF

METHOD EmployeeControllerMock:getViewManager()
RETURN ::Views

METHOD EmployeeControllerMock:redirect( cUrl )
   AAdd( ::Redirections, cUrl )
RETURN SELF

/*
 *
 */
CLASS TestEmployeeController FROM ControllerTestGroup
   PROTECTED:
      VAR Email1
      METHOD deleteAllEmployeeByEmail
      METHOD cleanupData
   EXPORTED:
      METHOD setup
      METHOD tearDown

      METHOD testSaveValidInput
      METHOD testSaveInvalidInput
      METHOD testSaveIncorrentParameters

      METHOD testUpdateValidInput
      METHOD testUpdateInvalidInput

      METHOD testDeleteWhenValidInput
      METHOD testDeleteInvalidInput
ENDCLASS

/// <summary>
///
/// </summary>
METHOD TestEmployeeController:deleteAllEmployeeByEmail( cEmail )
   LOCAL oEmployee

   oEmployee := EmployeeModel():findBy( "email", cEmail )
   DO WHILE NIL != oEmployee
      EmployeeModel():delete( oEmployee:Employee_id )
      oEmployee := EmployeeModel():findBy( "email", cEmail )
   ENDDO

RETURN SELF

///Readme: Remove any data that has been added by this test group
/// <summary>
///
/// </summary>
METHOD TestEmployeeController:cleanupData()
   ::deleteAllEmployeeByEmail( ::Email1 )
RETURN SELF

/// <summary>
/// When the test group starts ensure to remove any old data from the backend.
/// </summary>
METHOD TestEmployeeController:setup()

   ::Email1 := "a@noname.dom"

   SUPER

   ::cleanupData()

RETURN SELF

/// <summary>
/// When the test group has finished, all data is removed.
/// </summary>
METHOD TestEmployeeController:tearDown()

   ::cleanupData()

   SUPER

RETURN SELF

/// <summary>
///
/// </summary>
METHOD TestEmployeeController:testSaveValidInput()
   LOCAL oEmployeeController

   oEmployeeController := ::initController( EmployeeControllerMock() )

   oEmployeeController:getViewManager():Calls = {}

   oEmployeeController:save( "Name", ::Email1, "abc", "5", "1" )

   CHECK_INT_EQUAL(1, Len(oEmployeeController:getViewManager():Calls))
   CHECK_STR_EQUAL( "manageEmployees", oEmployeeController:getViewManager():Calls[1,1] )

   // The operation has not executed a redirection
   CHECK_EQUAL( {}, oEmployeeController:Redirections )

RETURN SELF

/// <summary>
///
/// </summary>
METHOD TestEmployeeController:testSaveInvalidInput()
   LOCAL oEmployeeController
   LOCAL cResult

   oEmployeeController := ::initController( EmployeeControllerMock() )
   oEmployeeController:getViewManager():Calls = {}

   cResult := oEmployeeController:save(       , ::Email1, "abc", "5", "1" )
   CHECK_STR_EQUAL( "Error", cResult )

   cResult := oEmployeeController:save( "Name",         , "abc", "5", "1" )
   CHECK_STR_EQUAL( "Error", cResult )

   cResult := oEmployeeController:save( "Name", ::Email1,      , "5", "1" )
   CHECK_STR_EQUAL( "Error", cResult )

   cResult := oEmployeeController:save( "Name", ::Email1, "abc",    , "1" )
   CHECK_STR_EQUAL( "Error", cResult )

   // Todo: Role is optional. Verification required.
   cResult := oEmployeeController:save( "Name", ::Email1, "abc", "5", NIL)
   CHECK_STR_EQUAL( "Error", cResult )

   // None of the operations have processed a view
   CHECK_EQUAL( {}, oEmployeeController:getViewManager():Calls )

   // None of the operations have executed a redirection
   CHECK_EQUAL( {}, oEmployeeController:Redirections )

RETURN SELF


METHOD TestEmployeeController:testSaveIncorrentParameters()
   LOCAL oEmployeeController
   LOCAL aViews, aParams

   oEmployeeController := ::initController( EmployeeControllerMock() )

   oEmployeeController:getViewManager():Calls := {}
   aViews := oEmployeeController:getViewManager():Calls


   oEmployeeController:save("","", "", "")
   aParams := aViews[1,2]

   CHECK_STR_NOCASE_EQUAL("employeeadd", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParams[1])

   oEmployeeController:save()

   CHECK_STR_NOCASE_EQUAL("employeeadd", aViews[1,1])
   CHECK_STR_NOCASE_EQUAL("please fill all fields!", aParams[1])

RETURN SELF

METHOD TestEmployeeController:testUpdateValidInput()
   LOCAL oEmployeeController
   LOCAL oUser, nEmployeeId

   oEmployeeController := ::initController( EmployeeControllerMock() )

   //create new employee before updating
   oEmployeeController:save("Borko", ::Email1, "abc", "22", "1")
    oEmployeeController:getViewManager():Calls := {}

   //retrieve the created employee
   oUser := UserService():getByEMail(::Email1)
   nEmployeeId := EmployeeModel():findBy("curr_account_id", oUser:account_id):employee_id

   oEmployeeController:update(nEmployeeId, "Boris", ::Email1, "20", "3")

   CHECK_STR_EQUAL("manageEmployees", oEmployeeController:getViewManager():Calls[1,1])

   CHECK_EQUAL({}, oEmployeeController:Redirections)
RETURN SELF


METHOD TestEmployeeController:testUpdateInvalidInput()
   LOCAL oEmployeeController, nEmployeeId
   LOCAL cResult, oUser

   oEmployeeController := ::initController( EmployeeControllerMock() )

   //create new employee before updating
   oEmployeeController:save("Borko", ::Email1, "abc", "22", "1")
   oEmployeeController:getViewManager():Calls := {}

   oUser := UserService():getByEMail(::Email1)
   nEmployeeId := EmployeeModel():findBy("curr_account_id", oUser:account_id):employee_id

   cResult := oEmployeeController:update(      ,"Boris", ::Email1, "20", "3")
   CHECK_STR_EQUAL("Error", cResult)


   cResult := oEmployeeController:update(nEmployeeId,      ,::Email1, "20", "3")
   CHECK_STR_EQUAL("Error", cResult)


   cResult := oEmployeeController:update(nEmployeeId ,"Boris",      ,"20", "3")
   CHECK_STR_EQUAL("Error", cResult)


   cResult := oEmployeeController:update(nEmployeeId ,"Boris",::Email1,     , "3")
   CHECK_STR_EQUAL("Error", cResult)


   cResult := oEmployeeController:update(nEmployeeId ,"Boris",::Email1,"20",      )
   CHECK_STR_EQUAL("Error", cResult)

   CHECK_EQUAL({}, oEmployeeController:getViewManager():Calls)

   CHECK_EQUAL({}, oEmployeeController:Redirections)
RETURN SELF


METHOD TestEmployeeController:testDeleteWhenValidInput()
   LOCAL oEmployeeController, oUser
   LOCAL nEmployeeId
   LOCAL aViews

   oEmployeeController := ::initController(EmployeeControllerMock())

   oEmployeeController:save("Borko", ::Email1, "abc", "22", "1")
   oEmployeeController:getViewManager():Calls := {}
   aViews := oEmployeeController:getViewManager():Calls

   oUser := UserService():getByEMail(::Email1)
   nEmployeeId := EmployeeModel():findBy("curr_account_id", oUser:account_id):employee_id

   oEmployeeController:delete(nEmployeeId)

   CHECK_STR_EQUAL("manageEmployees", aViews[1,1])
RETURN SELF


METHOD TestEmployeeController:testDeleteInvalidInput()
   LOCAL oEmployeeController, cResult

   oEmployeeController := ::initController(EmployeeControllerMock())

   cResult := oEmployeeController:delete(NIL)
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oEmployeeController:delete()
   CHECK_STR_EQUAL("Error", cResult)

   cResult := oEmployeeController:delete("")
   CHECK_STR_EQUAL("Error", cResult)
RETURN SELF



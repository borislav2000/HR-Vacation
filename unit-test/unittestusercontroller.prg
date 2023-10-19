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
STATIC CLASS UserControllerMock FROM UserController
   EXPORTED:
     VAR Redirections

     METHOD redirect
     METHOD getViewManager
     METHOD setViewManager
ENDCLASS

METHOD UserControllerMock:setViewManager( oViewManager )
   ::Redirections := {}
   ::Views := oViewManager
RETURN SELF

METHOD UserControllerMock:getViewManager()
RETURN ::Views

METHOD UserControllerMock:redirect( cUrl )
   AAdd( ::Redirections, cUrl )
RETURN SELF

CLASS TestUserController FROM ControllerTestGroup
   PROTECTED:
   EXPORTED:
      METHOD testLoginInvalidData()
ENDCLASS

METHOD TestUserController:testLoginInvalidData()
   LOCAL oUserController
   LOCAL cResult

   oUserController := ::initController(UserControllerMock())

   cResult := oUserController:login("test123@gmail.com", "test")

   CHECK_STR_EQUAL("email or password invalid", cResult)
RETURN SELF


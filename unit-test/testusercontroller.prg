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
      VAR cEmployeeEmail
      VAR cManagerEmail
      VAR cTestEmail
      VAR cPass
      METHOD cleanupData
      METHOD deleteAllUsersByEmail
   EXPORTED:
      METHOD setup
      METHOD tearDown

      METHOD testLoginAsManagerValidInput
      METHOD testLoginAsEmployeeValidInput
      METHOD testLoginInvalidInput
      METHOD testLoginWrongInput

      METHOD testChangePasswordValidInput
      METHOD testChangePasswordMismatchInput
      METHOD testChangePasswordInvalidInput
ENDCLASS

METHOD TestUserController:cleanupData()
   ::deleteAllUsersByEmail(::cEmployeeEmail)
   ::deleteAllUsersByEmail(::cManagerEmail)
   ::deleteAllUsersByEmail(::cTestEmail)
RETURN SELF

METHOD TestUserController:deleteAllUsersByEmail(cEmail1)
   LOCAL oUser

   oUser := UserAccountModel():findBy("email", cEmail1)
   DO WHILE NIL != oUser
       UserAccountModel():delete( oUser:account_id )
       oUser := UserAccountModel():findBy("email", cEmail1)
   ENDDO
RETURN SELF

METHOD TestUserController:setup()
   ::cEmployeeEmail  := "employee@mail.bg"
   ::cManagerEmail   := "manager@mail.bg"
   ::cTestEmail      := "test@mail.bg"
   SUPER

   ::cleanupData()
RETURN SELF

METHOD TestUserController:tearDown()
    ::cleanupData()

    SUPER
RETURN SELF



METHOD TestUserController:testLoginAsManagerValidInput()
   LOCAL oUserController, oUser

   ManagerService():addEmployee("manager", ::cManagerEmail, "pwd123", 1,2)
   oUser := UserService():getByEMail(::cManagerEmail)

   ::addSessionIdToController(oUser:account_id)
   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:login(::cManagerEmail, "pwd123")

   CHECK_STR_NOCASE_EQUAL("/views/managermainview.cxp", oUserController:Redirections[2])

   CHECK_EQUAL({}, oUserController:getViewManager():Calls)
RETURN SELF

METHOD TestUserController:testLoginAsEmployeeValidInput()
   LOCAL oUserController, oUser

   ManagerService():addEmployee("employee", ::cEmployeeEmail, "pwd", 1,1)
   oUser := UserService():getByEMail(::cEmployeeEmail)

   ::addSessionIdToController(oUser:account_id)
   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:login(::cEmployeeEmail, "pwd")

   CHECK_STR_NOCASE_EQUAL("/views/employeemainview.cxp", oUserController:Redirections[2])

   CHECK_EQUAL({}, oUserController:getViewManager():Calls)
RETURN SELF

METHOD TestUserController:testLoginInvalidInput()
   LOCAL oUserController


   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:login(::cManagerEmail, "" )

   CHECK_INT_EQUAL(1, Len(oUserController:Redirections))
   CHECK_STR_EQUAL("/views/loginformview.cxp?error=Please fill all fields!", oUserController:Redirections[1])

   oUserController:Redirections := {}
   oUserController:login("", "pass")

   CHECK_INT_EQUAL(1, Len(oUserController:Redirections))
   CHECK_STR_EQUAL("/views/loginformview.cxp?error=Please fill all fields!", oUserController:Redirections[1])

   oUserController:Redirections := {}
   oUserController:login("", "")

   CHECK_INT_EQUAL(1, Len(oUserController:Redirections))
   CHECK_STR_EQUAL("/views/loginformview.cxp?error=Please fill all fields!", oUserController:Redirections[1])

RETURN SELF


METHOD TestUserController:testLoginWrongInput()
   LOCAL oUserController

   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:login(::cManagerEmail, "wrong")

   CHECK_STR_EQUAL("/views/loginformview.cxp?error=email or password invalid", oUserController:Redirections[2])

RETURN SELF





METHOD TestUserController:testChangePasswordValidInput()
   LOCAL oUserController,oUser

   ManagerService():addEmployee("test", ::cTestEmail, "pwd123", 1,1)
   oUser := UserService():getByEMail(::cTestEmail)

   ::addSessionIdToController(oUser:account_id)

   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:changePassword("pwd", "pwd")

   CHECK_STR_NOCASE_EQUAL("/views/loginformview.cxp", oUserController:Redirections[1])


RETURN SELF


METHOD TestUserController:testChangePasswordMismatchInput()
   LOCAL oUserController,oUser

   ManagerService():addEmployee("test", ::cTestEmail, "pwd123", 1,1)
   oUser := UserService():getByEMail(::cTestEmail)

   ::addSessionIdToController(oUser:account_id)

   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:changePassword("pwd", "pwd123")

   CHECK_STR_NOCASE_EQUAL("/views/changepasswordview.cxp?error=the passwords do not match!", oUserController:Redirections[1])
RETURN SELF


METHOD TestUserController:testChangePasswordInvalidInput()
   LOCAL oUserController,oUser

   ManagerService():addEmployee("test", ::cTestEmail, "pwd123", 1,1)
   oUser := UserService():getByEMail(::cTestEmail)

   ::addSessionIdToController(oUser:account_id)

   oUserController := ::initController(UserControllerMock())

   oUserController:Redirections := {}
   oUserController:changePassword("pwd", "")

   CHECK_STR_NOCASE_EQUAL("/views/changepasswordview.cxp?error=please fill all fields!", oUserController:Redirections[1])
RETURN SELF



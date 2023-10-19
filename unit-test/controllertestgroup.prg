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

/// <summary>
/// The ApplicationMock provides a session to the controller mocks
/// </summary>
STATIC CLASS ApplicationMock
   EXPORTED:
      VAR Session
      METHOD init
ENDCLASS

METHOD ApplicationMock:init()
   ::Session := DataObject():new()
   ::Session:configPath := "C:\Users\Borislav\Documents\Xbase++\projects\HR Vacation\application.config"
RETURN SELF

/// <summary>
/// The ViewManager mock tracks ::View accesses. For example this line of code is catched:
///    ::Views:loginForm( xParam )
/// </summary>
STATIC CLASS ViewManagerMock
   EXPORTED:
      VAR Calls
      METHOD init
      METHOD noMethod
ENDCLASS

METHOD ViewManagerMock:init()
   ::Calls := {}
RETURN SELF

/// <summary>
/// Collect all method calls with parameters (eg. ::Views:login( xParam ))
/// </summary>
METHOD ViewManagerMock:noMethod( cMethodName )
   LOCAL nParam
   LOCAL aParams

   aParams := {}

   FOR nParam := 2 TO PCount()
      AAdd( aParams, PValue(nParam) )
   NEXT

   AAdd( ::Calls, {cMethodName, aParams} )
RETURN SELF

/// <summary>
/// A baseclass for test groups that test WebController instances
/// </summary>
CLASS ControllerTestGroup FROM GenericTestGroup
   PROTECTED:
      VAR Application
      VAR HttpRequest
      VAR HttpResponse
      VAR ViewManager
      VAR ViewsPath

      METHOD setupControlerDependencies
   EXPORTED:
      METHOD setup
      METHOD teardown
      METHOD initController
      METHOD addSessionIdToController
ENDCLASS

/// <summary>
/// Provide instances for controller setup. Some of them are mocks, others
/// are not.
/// </summary>
METHOD ControllerTestGroup:setupControlerDependencies()
   ::Application  := ApplicationMock():new()
   ::HttpRequest  := HttpRequestMessage():new( "http://nonexistdomain.com" )
   ::HttpResponse := HttpResponseMessage():new()
   ::ViewManager  := ViewManagerMock():new()
   ::ViewsPath    := ".\views\"
RETURN SELF

/// <summary>
/// Data connection setup for data binding
/// </summary>
METHOD ControllerTestGroup:setup()
   SUPER
   ConnectionManager():startup( "..\application.config" )
   ::setupControlerDependencies()
RETURN SELF

/// <summary>
/// Todo: ConnectionManager shutdown.
/// </summary>
METHOD ControllerTestGroup:teardown()
   SUPER
RETURN SELF

/// Readme:
/// <summary>
/// Prepare the controller class for producing instances. Stuff dependencies
/// after instantiation.
/// </summary>
METHOD ControllerTestGroup:initController( oControllerClass )
   LOCAL oController

   oControllerClass:setViewsPath( ::ViewsPath )

   oController := oControllerClass:new( ::HttpRequest, ::HttpResponse, ::Application )
   oController:setViewManager( ::ViewManager )

RETURN oController


METHOD ControllerTestGroup:addSessionIdToController( nId )
  ::Application:Session:uid := nId
RETURN SELF



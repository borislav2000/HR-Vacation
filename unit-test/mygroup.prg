//////////////////////////////////////////////////////////////////////
///
/// <summary>
/// Default test group.
/// </summary>
///
///
/// <remarks>
/// Test methods shall have a prefix ignore or test, the runner
/// executes all methods with the name prefix test and does ignore
/// those with the name prefix ignore. However the statistics always
/// inform you about how many tests are currently ignored.
/// In the event you need to establish an order between your tests
/// simple impl. a config method and use addTest()
/// </remarks>
///
///
/// <copyright>
/// &COPYRIGHT
/// </copyright>
///
//////////////////////////////////////////////////////////////////////
#include "..\.assets\xpp-unit\unit-test.ch"
#pragma library("..\helpers\controllers.lib")

CLASS MyGroup FROM GenericTestGroup
 EXPORTED:
   METHOD setup()
   METHOD tearDown()

   // $TODO add your test methods here. Use prefix ignore or test for method names
   METHOD testGiveYourTestPreciseNames()
   METHOD testEchoControllerWithCorrectParameters()
   METHOD testEchoControllerIfParameterIsNil()
ENDCLASS


METHOD MyGroup:testGiveYourTestPreciseNames()
  // $TODO add your code here
RETURN self


METHOD MyGroup:testEchoControllerWithCorrectParameters()
    //setup
   LOCAL cParam1 := "param1"
   LOCAL nParam2 := 111
   LOCAL cParam3 := "param2"
   LOCAL cExpected := "The parameters are " + Var2Char(cParam1) + ", " + Var2Char(nParam2) + " and " + Var2Char(cParam3)
   LOCAL cResult
   LOCAL oEchoController := EchoController():new()

   //exercise
   cResult := Var2Char(oEchoController:reflection(cParam1, nParam2, cParam3))

   //verify
   CHECK_STR_EQUAL(cExpected, cResult)
RETURN SELF

METHOD MyGroup:testEchoControllerIfParameterIsNil()
      //setup
   LOCAL cParam1 := "param1"
   LOCAL nParam2 := NIL
   LOCAL cParam3 := "param2"
   LOCAL cExpected := Var2Char(NIL)
   LOCAL cResult
   LOCAL oEchoController := EchoController():new()

   //exercise
   cResult := Var2Char(oEchoController:reflection(cParam1, nParam2, cParam3))

   //verify
   CHECK_STR_EQUAL(cExpected, cResult)
RETURN SELF

METHOD MyGroup:setup()
   SUPER
   // $TODO Insert setup code for all of your tests
RETURN


METHOD MyGroup:tearDown()
   // $TODO Insert teardown code for all of your tests
   SUPER
RETURN

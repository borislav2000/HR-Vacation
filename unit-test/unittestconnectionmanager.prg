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
#include "Fileio.ch"
#include "dac.ch"

CLASS UnitTestConnectionManager FROM GenericTestGroup
   EXPORTED
      METHOD testStartupConfigNode
      METHOD testStartupXmlFile
ENDCLASS

METHOD UnitTestConnectionManager:testStartupConfigNode()
   LOCAL cAppConfig
   LOCAL cAppConfigFile
   LOCAL xmlAppConfig
   LOCAL xmlConfig
   LOCAL lOk

   cAppConfigFile := "..\application.config"
   CHECK_TRUE( File( cAppConfigFile ) )

   cAppConfig := MemoRead( cAppConfigFile )
   CHECK_FALSE( Empty( cAppConfig ) )

   xmlAppConfig := XmlSimpleParser( cAppConfig )

   CHECK_FALSE( Empty( xmlAppConfig ) )
   CHECK_FALSE( Empty( xmlAppConfig:Config ) )

   xmlConfig := xmlAppConfig:Config
   lOk := ConnectionManager():startup( xmlConfig )

   CHECK_TRUE( lOk )

RETURN SELF

METHOD UnitTestConnectionManager:testStartupXmlFile()
   LOCAL cFile, lOk

   cFile := "..\application.config"

   CHECK_TRUE( File(cFile) )

   lOk := ConnectionManager():startup( cFile )

   CHECK_TRUE( lOk )

RETURN SELF


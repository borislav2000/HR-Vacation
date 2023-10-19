HR Vacation App
===============

Description:
------------

HR Vacation is a web-based application used by employees and managers in a company to plan the holidays. The employees can enter their holiday request and manager can approve or reject them. The system will represent the holiday plan on a list or graphical view

Built with:
-----------

-   Xbase++
-   Bootstrap 4
-   WebUI
-   PostgreSQL

Prerequisites:
--------------

-   Xbase++ 2.00.1103 or higher, with CXP installed.
-   IIS with FastCGI installed
-   PostgreSQL 9.4 or higher, in addition pgAdmin to do maintenance work

Project Targets:
----------------

**smallwebapp.web** The views of our template implemented as CXP pages

**helpers\\accountmgmt.dll** The business logic, deployed as helper dll which implemented a AccountMgmt() and UserService() classes as well as a EmployeeModel and UserAccountModel for data access.

**helpers\\unit-test\\runner.exe** The unti test target for the business logic in the helper dlls.

Setup the IIS (Internet Information Service)
--------------------------------------------

1.  Download and extract the project to a folder of your choice
2.  Open the IIS Manager on your computer and in the left side panel you will find "Sites"
3.  Right click on it and choose "Add Website..."
4.  Add a website name and choose the physical path to the folder where you extracted the project
5.  Change the port to 81 (or any free port)
6.  Add the users IIS\_IUSRS (read and write permission) and IUSR (read permission) to the project directory

Setup the PostgreSQL and import the data-models
-----------------------------------------------

1.  Open the pgAdmin and add a new server called "localhost"
2.  Right click on it and choose "Create" -\> "Database" with the name "hr-vacation"
3.  Right click on the database and select "Query Tool"
4.  On the navigation bar choose "Open File" button and navigate to the project directory and find the folder "Setup"
5.  Execute the script "hr-vacation-model.sql" which implements the data model
6.  Execute the script "hr-vacation-data-sample.sql" which inserts the default data

Run the web application
-----------------------

1.  Open the project.xpj file from your project directory with Notepad or other text editor
2.  Change the SITE\_ROOT to the path of the project directory
3.  Change the port of the SITE\_URL to 81
4.  From the Setup folder execute the appcmd batch file
5.  Open again the project.xpj but this time with Xbase++
6.  From the navigation bar choose "Run" -\> "Execute smallwebapp.web"

Rules:
------

-   Whenever you add business logic to the helper, write unit tests. If you add a new business logic class then add at least a new test group to have your test organized.
-   Do not add business logic to the cxp views, they are just there to have as little logic as possible and bind your data / actions to the views or receive view data and forward it to the AccountMgmt and UserService business logic layers which in turn use for data access the employee model.

The entire sample uses Bootstrap 4 for the UI as well as the following Xbase++ specific features:

-   To avoid repeated html coding a site.layout file to define the generic layout of the web application. All other views (\*.cxp) simple use that layout and this way can can concentrate onto content with each view
-   The application.config file is used in that sample to store application specific config data as well as to bind the helper dll to all CXP/LAYOUT files (lib node).
-   The login / Logout cxp files are special in that sense as they just do a little control flow logic and initiate a page redirect
-   All business logic related to password mgmt, login/logout is implemented in the accountmgmt helper dll.
-   The employee list-view and edit actions are implemented as pure CXP pages and utilize the Employee and UserAccounts models from the AccountMgmt helper dll.
-   You can find all trace/log output at c:\\programdata\\alaska software\\logfiles\\cxp20

Notes about data management
---------------------------

The application uses a PostgreSQL dbms for data storage/management:

-   Data is stored in the hr-vacation database.
-   Access to data is done via a Model Object Framework (MOF), a simple layer on top of SQL to make data access easier
-   Database connection / disconnection is done automatically at application startup/shutdown. For that the AccountMgmt class implements the IAppLifeCycle interface, so onStartup(),onShutdown() are executed automatically.

### Keywords:

SmallWebApp, Cloud, CXP, Helpers, Bootstrap, PostgreSQL

### Author:

Alaska Software

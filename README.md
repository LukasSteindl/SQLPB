# SQLPB

With this Tool you can start a SQL Server Extended Event Trace and Parse the Output to into several correlated tables. Then you can use the Power BI Dashboard with R Components to create a histographic Baseline and perform hypothesis tests.

For example you can test if a certain traceflag improves or degrades performance on average.
Apart from that you can test settings like:
Max degree of parallelism, Cost Threshold for parallelism, creating an index, removing an index, different energy saving settings,
different isolation levels, new hardware components, use of specialized features (SQL InMemory Tables) etc.

Make sure to test one hypothesis at a time and keep all other settings constant.

![alt text](https://github.com/LukasSteindl/SQLPB/blob/master/Demo.png)

Example Call:

declare @db_id int = DB_ID('master')
declare @logfilepath varchar(128)
set @logfilepath = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Log\'

exec [StpandWaitTrace] '00:00:05', 'ScenarioName', @db_id,@logfilepath

You could run this command in a SQL Agent Job on a periodic basis to collect several samples.
After that you can use PowerBI Desktop with R Extension to do an empirical analysis of your performance data.

You can install R from here: https://mran.microsoft.com/open

After installing the R-Framework, make sure that Power BI Desktop finds the R home directory.
In Power-BI-Desktop under File/"Options and Settings"/Options you can find the R scripting tab, where you can select the R home directory.
![alt text](https://github.com/LukasSteindl/SQLPB/blob/master/PowerBI-R-Configuration.PNG)

Now the last step is to install the "ggplot2" library and all dependent R libraries.
To do that you need to start R.exe as an Administrator (by default located here: C:\Program Files\Microsoft\MRO-3.3.1\bin) and execute the following command:

install.packages("ggplot2")

This should install the ggplot2 visualisation library and all dependent libraries to your R environment.
Now you can use the Dashboard.pbix in this Git repository to analyze the data you collected before.

Troubleshooting:
In order to install the R-package ggplot2, your machine needs access to the internet.
If you don`t have access to the internet or ggplot2 does not work for any other reason, you can try to install R on a different machine and then copy the installed library folders to the corresponding folders on the machine where it does not work:
By default libraries in Microsoft R Open will be installed to this directory:
C:/Users/username/Documents/R/win-library/3.3

# SQLPB


With this Tool you can start a SQL Server Extended Event Trace and Parse the Output to into several correlated tables. Then you can use the Power BI Dashboard with R Components to create a histographic Baseline.

![alt text](https://github.com/LukasSteindl/SQLPB/blob/master/Demo.png)


Example Call: 



declare @db_id int = DB_ID('master')
		
declare @logfilepath varchar(128)
         set @logfilepath = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Log\'

exec [StpandWaitTrace] '00:00:05', 'ScenarioName', @db_id,@logfilepath


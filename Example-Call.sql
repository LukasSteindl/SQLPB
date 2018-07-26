
declare @scenarioid int = 30
declare @scenario varchar(255)

while @scenarioid < 40
begin
declare @db_id int = DB_ID('tut_rep')
declare @logfilepath varchar(128) set @logfilepath = 'E:\MSSQL13.VDE_TUT04\MSSQL\Log'
set @scenario = CONCAT(@scenarioid,'_ScenarioName')
print 'collecting' + @scenario
exec [StpandWaitTrace] '00:00:59',@scenario , @db_id,@logfilepath
set @scenarioid+=1
print 'waiting 1 minute...'
	waitfor delay '00:01:00'
end 

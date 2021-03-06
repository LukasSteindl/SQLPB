USE [PowerBITrace]
GO

CREATE DATABASE PowerBITrace
GO
USE PowerBITrace
/****** Object:  Table [dbo].[batch_completed]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[batch_completed](
	[timestamp] [datetime2](7) NULL,
	[cpu_time] [bigint] NULL,
	[duration_in_microseconds] [bigint] NULL,
	[physical_reads] [bigint] NULL,
	[logical_reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[row_count] [bigint] NULL,
	[SqlText] [nvarchar](max) NULL,
	[Correlation] [varchar](256) NULL,
	[transaction_id] [bigint] NULL,
	[SzenarioID] [varchar](255) NOT NULL,
	[Minute] [int] NULL,
	[Second] [int] NULL,
	[Millisecond] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[Task]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [dbo].[Task] 

as 

Select Left(correlation,36) as TaskID, SUM(duration_in_microseconds) as 'Duration_in_microseconds' from batch_completed group by Left(correlation,36)

GO
/****** Object:  View [dbo].[SQLBatchCompleted]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create View [dbo].[SQLBatchCompleted]

as

Select *,Left(correlation,36) as TaskID  from batch_completed

GO
/****** Object:  Table [dbo].[WaitInfo]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WaitInfo](
	[timestamp] [datetime2](7) NULL,
	[wait_type] [varchar](25) NULL,
	[wait_type_duration_ms] [bigint] NULL,
	[wait_type_signal_duration_ms] [bigint] NULL,
	[Correlation] [varchar](256) NULL,
	[Sequence] [int] NULL,
	[Minute] [int] NULL,
	[Second] [int] NULL,
	[Millisecond] [int] NULL,
	[Szenario] [varchar](50) NULL,
	[TransactionID] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[SQLWaitInfo]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create View [dbo].[SQLWaitInfo]

as

Select *,Left(correlation,36) as TaskID  from WaitInfo

GO
/****** Object:  Table [dbo].[capture_stpandwaits_data]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[capture_stpandwaits_data](
	[event_data] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[commit_tran_completed]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[commit_tran_completed](
	[timestamp] [datetime2](7) NULL,
	[Correlation] [varchar](256) NULL,
	[Sequence] [varchar](8000) NULL,
	[transaction_id] [int] NULL,
	[Minute] [int] NULL,
	[Second] [int] NULL,
	[Millisecond] [int] NULL,
	[Szenario] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[commit_tran_starting]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[commit_tran_starting](
	[timestamp] [datetime2](7) NULL,
	[Correlation] [varchar](256) NULL,
	[Sequence] [varchar](8000) NULL,
	[transaction_id] [int] NULL,
	[Minute] [int] NULL,
	[Second] [int] NULL,
	[Millisecond] [int] NULL,
	[Szenario] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcedureExecutionTime]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcedureExecutionTime](
	[timestamp] [datetime2](7) NULL,
	[cpu_time] [bigint] NULL,
	[duration_in_microseconds] [bigint] NULL,
	[physical_reads] [bigint] NULL,
	[logical_reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[row_count] [bigint] NULL,
	[SqlText] [nvarchar](512) NULL,
	[Correlation] [varchar](256) NULL,
	[Sequence] [int] NULL,
	[Minute] [int] NULL,
	[Second] [int] NULL,
	[Millisecond] [int] NULL,
	[Szenario] [varchar](50) NULL,
	[TransactionID] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 26.07.2018 12:12:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[timestamp] [datetime2](7) NULL,
	[duration_in_microseconds] [int] NULL,
	[Correlation] [varchar](256) NULL,
	[Sequence] [varchar](8000) NULL,
	[object_name] [varchar](512) NULL,
	[transaction_state] [varchar](512) NULL,
	[transaction_type] [varchar](512) NULL,
	[transaction_id] [int] NULL,
	[Minute] [int] NULL,
	[Second] [int] NULL,
	[Millisecond] [int] NULL,
	[Szenario] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Parse_XTP]    Script Date: 26.07.2018 12:12:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Parse_XTP] (@szenario varchar(255))

as

begin

	 ---Transaction Commit auswerten:

     --Select * from #capture_stpandwaits_data



    --declare @szenario varchar(255) = 'ABC'

     Insert Into commit_tran_completed    

     Select [timestamp],  

       Correlation,

        REPLACE(RIGHT(Correlation,2),'-','') as 'Sequence', transaction_id

        ,datepart(Minute,timestamp) as [Minute],datepart(second,timestamp) as [Second],datepart(MILLISECOND,timestamp) as [Millisecond],'test' --@szenario as Szenario 

     --   into commit_tran_completed

        from (

               SELECT

                     n.value('(@timestamp)[1]', 'datetime2') AS [timestamp],

                      n.value('(action[@name="attach_activity_id"]/value)[1]', 'varchar(512)') AS Correlation,

                             n.value('(action[@name="transaction_id"]/value)[1]', 'bigint') AS transaction_id

               FROM

               capture_stpandwaits_data

               CROSS APPLY event_data.nodes('event')as q(n)

               where n.value('(@name)[1]', 'varchar(64)') = 'commit_tran_completed'

               )x



   



---    declare @szenario varchar(255) = 'ABC'

      Insert Into commit_tran_starting

      Select [timestamp],  

       Correlation,

        REPLACE(RIGHT(Correlation,2),'-','') as 'Sequence', transaction_id

        ,datepart(Minute,timestamp) as [Minute],datepart(second,timestamp) as [Second],datepart(MILLISECOND,timestamp) as [Millisecond],@szenario as Szenario 

      --  into commit_tran_starting

        from (

               SELECT

                     n.value('(@timestamp)[1]', 'datetime2') AS [timestamp],

                      n.value('(action[@name="attach_activity_id"]/value)[1]', 'varchar(512)') AS Correlation,

                             n.value('(action[@name="transaction_id"]/value)[1]', 'bigint') AS transaction_id

               FROM

               capture_stpandwaits_data

               CROSS APPLY event_data.nodes('event')as q(n)

               where n.value('(@name)[1]', 'varchar(64)') = 'commit_tran_starting'

               )x



-------------------



       Insert into ProcedureExecutionTime

        Select [timestamp], cpu_time, duration_in_microseconds, physical_reads, logical_reads, writes, row_count, SqlText,

     Correlation,

        REPLACE(RIGHT(Correlation,2),'-','') as 'Sequence'

        ,datepart(Minute,timestamp) as [Minute],datepart(second,timestamp) as [Second],datepart(MILLISECOND,timestamp) as [Millisecond],@szenario

           ,transaction_id

        from (

               SELECT

               n.value('(@timestamp)[1]', 'datetime2') AS [timestamp],

                      n.value('(data[@name="cpu_time"]/value)[1]', 'bigint') AS cpu_time,

                      n.value('(data[@name="duration"]/value)[1]', 'bigint') AS duration_in_microseconds,  

                      n.value('(data[@name="physical_reads"]/value)[1]', 'bigint') AS physical_reads,  

                      n.value('(data[@name="logical_reads"]/value)[1]', 'bigint') AS logical_reads,  

                      n.value('(data[@name="writes"]/value)[1]', 'bigint') AS writes,  

                      n.value('(data[@name="row_count"]/value)[1]', 'bigint') AS row_count,  

                      n.value('(data[@name="statement"]/value)[1]', 'nvarchar(512)') AS SqlText,

                      n.value('(action[@name="attach_activity_id"]/value)[1]', 'varchar(512)') AS Correlation,

                       n.value('(action[@name="transaction_id"]/value)[1]', 'bigint') AS transaction_id

               FROM

               capture_stpandwaits_data

               CROSS APPLY event_data.nodes('event')as q(n)

               where n.value('(@name)[1]', 'varchar(64)') = 'rpc_completed'

               )x



---Batch Completed Parser



INSERT INTO batch_completed Select  [timestamp], cpu_time, duration_in_microseconds, physical_reads, logical_reads, writes, row_count, SqlText,

        Correlation,transaction_id,@szenario

        ,datepart(Minute,timestamp) as [Minute],datepart(second,timestamp) as [Second],datepart(MILLISECOND,timestamp) as [Millisecond] --,

             from (

                        SELECT

               n.value('(@timestamp)[1]', 'datetime2') AS [timestamp],

                      n.value('(data[@name="cpu_time"]/value)[1]', 'bigint') AS cpu_time,

                      n.value('(data[@name="duration"]/value)[1]', 'bigint') AS duration_in_microseconds,  

                      n.value('(data[@name="physical_reads"]/value)[1]', 'bigint') AS physical_reads,  

                      n.value('(data[@name="logical_reads"]/value)[1]', 'bigint') AS logical_reads,  

                      n.value('(data[@name="writes"]/value)[1]', 'bigint') AS writes,  

                      n.value('(data[@name="row_count"]/value)[1]', 'bigint') AS row_count,  

                      n.value('(data[@name="batch_text"]/value)[1]', 'nvarchar(512)') AS SqlText,

                      n.value('(action[@name="attach_activity_id"]/value)[1]', 'varchar(512)') AS Correlation,

                       n.value('(action[@name="transaction_id"]/value)[1]', 'bigint') AS transaction_id, @szenario as SzenarioID

               FROM

               capture_stpandwaits_data

               CROSS APPLY event_data.nodes('event')as q(n)

               where n.value('(@name)[1]', 'varchar(64)') = 'sql_batch_completed'

               )x





  -------------------



  --declare @szenario varchar(255) = 'ABC'

        Insert Into WaitInfo

        Select

        [timestamp], wait_type, wait_type_duration_ms, wait_type_signal_duration_ms, Correlation,

        REPLACE(RIGHT(Correlation,2),'-','') as 'Sequence',

        datepart(Minute,timestamp) as [Minute],datepart(second,timestamp) as [Second],

        datepart(MILLISECOND,timestamp) as [Millisecond],@szenario,transaction_id

        from (

        SELECT n.value('(@timestamp)[1]', 'datetime2') AS [timestamp],

                      n.value('(data[@name="wait_type"]/text)[1]', 'varchar(25)') AS wait_type,

                      n.value('(data[@name="duration"]/value)[1]', 'bigint') AS wait_type_duration_ms,  

                      n.value('(data[@name="signal_duration"]/value)[1]', 'bigint') AS wait_type_signal_duration_ms,

                      n.value('(action[@name="attach_activity_id"]/value)[1]', 'varchar(512)') AS Correlation,

                      n.value('(action[@name="transaction_id"]/value)[1]', 'bigint') AS transaction_id

               FROM

               capture_stpandwaits_data

               CROSS APPLY event_data.nodes('event')as q(n)

               where n.value('(@name)[1]', 'varchar(64)') = 'wait_info'

               )x





end

GO
/****** Object:  StoredProcedure [dbo].[StpandWaitTrace]    Script Date: 26.07.2018 12:12:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[StpandWaitTrace] (@duration varchar(10), @szenario varchar(50), @databaseid int,@logfilepath varchar(128))

as

begin

        --Schritt 1) TRACE ANLEGEN:

        IF EXISTS(SELECT * FROM sys.server_event_sessions WHERE name = 'StoredProcedureAndWaitstats')

        DROP EVENT SESSION [StoredProcedureAndWaitstats] ON SERVER

        waitfor delay '00:00:02'



       



       declare @deletecmd nvarchar(4000)= CONCAT('DEL /F "',@logfilepath, 'StoredProcedureAndWaitstats*"')

       exec xp_cmdshell @deletecmd

       declare @cmd nvarchar(4000) = CONCAT('

            CREATE EVENT SESSION [StoredProcedureAndWaitstats] ON SERVER

                ADD EVENT sqlos.wait_info(

                      ACTION(sqlserver.transaction_id)

                      WHERE ([package0].[equal_uint64]([sqlserver].[database_id],(',@databaseid,')) AND [duration]>(0) AND [package0].[not_equal_uint64]([wait_type],(109)) AND [package0].[not_equal_uint64]([wait_type],(96)) AND [package0].[not_equal_uint64]([wait_type],(798)))),

                ADD EVENT sqlserver.commit_tran_completed(

                      ACTION(sqlserver.transaction_id)

                      WHERE ([sqlserver].[database_id]=(',@databaseid,'))),

                ADD EVENT sqlserver.commit_tran_starting(

                      ACTION(sqlserver.transaction_id)

                      WHERE ([sqlserver].[database_id]=(',@databaseid,'))),

                ADD EVENT sqlserver.rpc_completed(SET collect_statement=(1)

                      ACTION(sqlserver.transaction_id)

                      WHERE ([package0].[equal_uint64]([sqlserver].[database_id],(',@databaseid,')) AND [package0].[not_equal_unicode_string]([statement],N''exec sp_reset_connection''))),

                ADD EVENT sqlserver.sql_batch_completed(SET collect_batch_text=(1)

                      WHERE ([sqlserver].[database_id]=(',@databaseid,'))),

                ADD EVENT sqlserver.sql_transaction(

                      ACTION(sqlserver.transaction_id)

                      WHERE ([sqlserver].[database_id]=(',@databaseid,')))

                ADD TARGET package0.event_file(SET filename=N''',@logfilepath,'StoredProcedureAndWaitstats.xel'')

                WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)')

        exec sp_executesql @cmd





       --Schritt 2)  TRACE STARTEN:

  

        ALTER EVENT SESSION StoredProcedureAndWaitstats

        ON SERVER

        STATE = start;

  

        waitfor delay @duration --'00:00:02'

  

  

        --Schritt 3)

        ALTER EVENT SESSION StoredProcedureAndWaitstats

        ON SERVER

        STATE = stop;

  

        waitfor delay '00:00:10' --flushen!

        --in temptable kopieren:

        Truncate table [dbo].[capture_stpandwaits_data]

 

     declare @parsecmd nvarchar(4000) = CONCAT('Insert Into [capture_stpandwaits_data] Select CAST(event_data as xml) AS event_data

        from sys.fn_xe_file_target_read_file(''', @logfilepath ,'StoredProcedureAndWaitstats*.xel'',null,null,null)')

  

   --print @parsecmd

     exec sp_executesql @parsecmd



	 exec Parse_XTP @szenario



end

GO

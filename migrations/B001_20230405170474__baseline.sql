SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemas'
GO
IF SCHEMA_ID(N'Metadata') IS NULL
EXEC sp_executesql N'CREATE SCHEMA [Metadata]
AUTHORIZATION [dbo]'
GO
PRINT N'Creating [Metadata].[Logging]'
GO
CREATE TABLE [Metadata].[Logging]
(
[Logid] [int] NOT NULL IDENTITY(1, 1),
[LogType] [varchar] (10) NULL,
[LogSeverity] [varchar] (1) NULL,
[TSQLProc] [varchar] (50) NULL,
[TSQLStep] [varchar] (200) NULL,
[WhoCalledMe] [varchar] (500) NULL,
[LogMessage] [varchar] (500) NULL,
[RunTimeSecs] [numeric] (18, 0) NULL,
[SQLRowCount] [numeric] (18, 0) NULL,
[LogValue] [varchar] (50) NULL,
[LogDBDateTime] [datetime] NULL CONSTRAINT [DF__Logging__LogDBDa__6FE99F9F] DEFAULT (getdate()),
[ADFUTCTime] [varchar] (50) NULL,
[ADFCallingPipeline] [varchar] (100) NULL,
[ADFCallingPipelineRunId] [varchar] (100) NULL,
[ADFPipeline] [varchar] (100) NULL,
[ADFPipelineParam] [varchar] (100) NULL,
[ADFEnvironment] [varchar] (100) NULL,
[ADFSubscriptionId] [varchar] (100) NULL,
[ADFResourceGroup] [varchar] (100) NULL,
[ADFDataFactory] [varchar] (100) NULL,
[ADFPipelineRunId] [varchar] (100) NULL,
[ADFPipelineTriggername] [varchar] (100) NULL,
[ADFPipelineTriggertime] [varchar] (100) NULL,
[ADFActivityTask] [varchar] (100) NULL,
[ADFActivityType] [varchar] (100) NULL,
[ADFActivityRunId] [varchar] (100) NULL,
[ADFActivityStatus] [varchar] (100) NULL,
[ADFActivityDetails] [varchar] (200) NULL,
[ADFActivityExecutionDetails] [varchar] (1000) NULL,
[ADFActivityError] [varchar] (1000) NULL,
[ADFActivityExecutionStartTime] [varchar] (50) NULL,
[ADFActivityExecutionEndTime] [varchar] (50) NULL,
[ADFRowsRead] [varchar] (10) NULL,
[ADFRowsCopied] [varchar] (10) NULL,
[ADFCopyDuration] [varchar] (10) NULL,
[ADFActivityExecutionTime] [varchar] (10) NULL,
[ADFRowsDiff] [varchar] (50) NULL,
[ADFUTCTDate] [varchar] (50) NULL
)
GO
PRINT N'Creating [Metadata].[sp_Logging]'
GO
---------------------------------------------------------------------------------------------------------------------------------------
-- DATE      AUTHOR               VER   PURPOSE
--
---------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [Metadata].[sp_Logging] 
        @LogType                            VARCHAR(10)   = NULL, -- ADF / TSQL / SSIS / PBI / etc
		@LogSeverity                        VARCHAR(1)    = NULL, -- L=Logging W=Warning E=Error 
		@TSQLProc                           VARCHAR(50)   = NULL, -- TSQL Sproc Name
		@TSQLStep                           VARCHAR(200)  = NULL, -- TSQL Step name within Sproc
		@WhoCalledMe                        VARCHAR(500)  = NULL, -- What called this Sproc (SSMS, or another Sproc, etc)
		@LogMessage                         VARCHAR(500)  = NULL, -- TSQL Sproc Message
		@RunTimeSecs                        NUMERIC       = NULL, -- TSQL SProc runtime or SProc Step Runtime,
	    @SQLRowCount                        NUMERIC       = NULL, -- TSQL Rowcount
        @LogValue                           VARCHAR(50)   = NULL, -- TSQL Sproc Value
		-- ADF Pipeline Specific
		@ADFUTCTime                         VARCHAR(50)   = NULL, -- ADF UTC Time  
        @ADFCallingPipeline                 VARCHAR(100)  = NULL, -- Pipeline Parameter PP_CallingPipeline      (@pipeline().Pipeline in the calling pipeline) 
		@ADFCallingPipelineRunId            VARCHAR(50)   = NULL, -- Pipeline Parameter PP_CallingPipelineRunId (@pipeline().RunId    in the calling pipeline)
		@ADFPipeline                        VARCHAR(100)  = NULL, -- @pipeline().Pipeline 
        @ADFPipelineParam                   VARCHAR(100)  = NULL, -- pipeline().parameters.PP_PipelineParam 
        @ADFEnvironment                     VARCHAR(100)  = NULL, -- pipeline().globalParameters.GP_Environment
        @ADFSubscriptionId                  VARCHAR(50)   = NULL, -- ADF SubscriptionId
        @ADFResourceGroup                   VARCHAR(50)   = NULL, -- ADF ResourceGroup
		@ADFDataFactory                     VARCHAR(100)  = NULL, -- @pipeline().DataFactory
		@ADFPipelineRunId                   VARCHAR(100)  = NULL, -- @pipeline().RunId
		@ADFPipelineTriggerName             VARCHAR(50)   = NULL, -- @pipeline().TriggerName  -- Values are:"ADF Trigger Name"="Name of ADF trigger that ran this" OR "Manual"="An ADF Trigger Now (manual run)"  OR  "Sandbox"="Manual ADF Debug Run";
        @ADFPipelineTriggerTime             VARCHAR(50)   = NULL, -- @pipeline().TriggerTime
		-- ADF Activity Specific
		@ADFActivityTask                    VARCHAR(100)  = NULL, -- hardcoded
		@ADFActivityType                    VARCHAR(100)  = NULL, -- hardcoded
      	@ADFActivityRunId                   VARCHAR(100)  = NULL, -- activity('GM_LogForEach').@ADFActivityRunId
		@ADFActivityStatus                  VARCHAR(100)  = NULL, -- activity('SP_CallMorningLoad').Status
		@ADFActivityDetails                 VARCHAR(200)  = NULL, -- 
		@ADFActivityExecutionDetails        VARCHAR(1000) = NULL, -- activity('SP_CallMorningLoad').ExecutionDetails
		@ADFActivityDuration                VARCHAR(50)   = NULL, -- activity('SP_CallMorningLoad').Duration
		@ADFActivityError                   VARCHAR(1000) = NULL, -- @activity('SP_CallMorningLoad').output.errors[0].Message (Note: errors is an array, even though you only want the 1st element)
		@ADFActivityExecutionStartTime      VARCHAR(50)   = NULL, -- activity('SP_CallMorningLoad').ExecutionStartTime
		@ADFActivityExecutionEndTime        VARCHAR(50)   = NULL, -- activity('SP_CallMorningLoad').ExecutionEndTime
        @ADFRowsRead                        VARCHAR(50)   = NULL, -- activity('C_QLMDb_to_PerennaBlob').Output.rowsRead
        @ADFRowsCopied                      VARCHAR(50)   = NULL, -- activity('C_QLMDb_to_PerennaBlob').Output.rowsCopied
        @ADFCopyDuration                    VARCHAR(50)   = NULL -- activity('C_QLMDb_to_PerennaBlob').Output.copyDuration

AS


INSERT INTO metadata.Logging (
   LogType,
   LogSeverity,
   TSQLProc,
   TSQLStep,
   WhoCalledMe,
   LogMessage,
   RunTimeSecs,
   SQLRowCount,
   LogValue,
   -- ADF Pipeline Specific
   ADFUTCTime,
   ADFCallingPipeline,
   ADFCallingPipelineRunId,
   ADFPipeline,
   ADFPipelineParam,
   ADFEnvironment,
   ADFSubscriptionId,
   ADFResourceGroup,
   ADFDataFactory,
   ADFPipelineRunId,
   ADFPipelineTriggername,
   ADFPipelineTriggertime,
   -- ADF Activity Specific
   ADFActivityTask,
   ADFActivityType,
   ADFActivityRunId,
   ADFActivityStatus,
   ADFActivityDetails,
   ADFActivityExecutionDetails,
   ---------------------------------------ADFActivityDuration,
   ADFActivityError,
   ADFActivityExecutionStartTime,
   ADFActivityExecutionEndTime,
   ADFRowsRead,
   ADFRowsCopied,
   ADFCopyDuration,
   -- Calc Columns
   ADFActivityExecutionTime,
   ADFRowsDiff,
   ADFUTCTDate
)
VALUES (CASE 
            WHEN @ADFDataFactory IS NULL THEN @LogType
			ELSE                              'ADF' 
		END,
        CASE 
		    WHEN @TSQLProc IS NOT NULL                                                                                THEN @LogSeverity -- TSQL passes either L or E
		    WHEN (@ADFDataFactory IS NOT NULL) AND (@ADFActivityStatus = 'Succeeded')                                 THEN 'L'          -- ADF and it Succeeded so it is a Log message
			WHEN (@ADFDataFactory IS NOT NULL) AND (@ADFActivityStatus = 'Failed')                                    THEN 'E'          -- ADF and it Failed so it is an Error message
			WHEN (@ADFDataFactory IS NOT NULL) AND (@ADFActivityError  IS NULL AND @ADFActivityType LIKE 'Pipeline%') THEN 'L'          -- ADF Pipeline so no Status, but Error IS NULL and it is a Pipeline so its a Log message
		END,
		@TSQLProc,
		@TSQLStep,
        @WhoCalledMe,
        @LogMessage,
		@RunTimeSecs,
		@SQLRowCount,
        @LogValue,
	    -- ADF Pipeline Specific
        @ADFUTCTime,
        @ADFCallingPipeline,
		@ADFCallingPipelineRunId,
		@ADFPipeline,
        @ADFPipelineParam,
        @ADFEnvironment,
        @ADFSubscriptionId,
        @ADFResourceGroup,
		@ADFDataFactory,
		@ADFPipelineRunId,
		CASE @ADFPipelineTriggername
		    WHEN 'Sandbox' THEN 'ADF Manually triggered (Debug run)'
			WHEN 'Manual'  THEN 'ADF Manually triggered (Trigger Now)'
			ELSE                'ADF TriggerName: '+@ADFPipelineTriggername
		END,   
		@ADFPipelineTriggerTime,
        -- ADF Activity Specific
		@ADFActivityTask,
		@ADFActivityType,
      	@ADFActivityRunId,
		@ADFActivityStatus,
		@ADFActivityDetails,
		@ADFActivityExecutionDetails,
		-- @ADFActivityDuration,
		REPLACE(REPLACE(@ADFActivityError,
		                '''Type=Microsoft.DataTransfer.Common.Shared.HybridDeliveryException,Message=',
						''),
						',Source=Microsoft.DataTransfer.Common,''',
						''), --@ADFActivityError, -- Humanise Error Message
		@ADFActivityExecutionStartTime,
		@ADFActivityExecutionEndTime,
        @ADFRowsRead,
        @ADFRowsCopied,
        @ADFCopyDuration,
        -- Calculated Columns
        DATEDIFF(SECOND,
		         CONVERT(DATETIME,SUBSTRING(@ADFActivityExecutionStartTime,1,10) + ' ' + SUBSTRING(@ADFActivityExecutionStartTime,12,8)),
				 CONVERT(DATETIME,SUBSTRING(@ADFActivityExecutionEndTime,1,10)   + ' ' + SUBSTRING(@ADFActivityExecutionEndTime,12,8))
                 ),  -- ADFActivityExecutionTime,
        CONVERT(NUMERIC,@ADFRowsRead) - CONVERT(NUMERIC,@ADFRowsCopied),  -- ADFRowsDiff,
        CONVERT(DATE,@ADFUTCTime)       -- ADFUTCTDate
 );
GO
PRINT N'Creating [dbo].[Accounts]'
GO
CREATE TABLE [dbo].[Accounts]
(
[Id] [int] NOT NULL,
[AccountName] [varchar] (20) NULL,
[Status] [varchar] (10) NULL,
[Balance] [decimal] (12, 2) NULL
)
GO
PRINT N'Creating primary key [PK__Accounts__3214EC071537E4F5] on [dbo].[Accounts]'
GO
ALTER TABLE [dbo].[Accounts] ADD CONSTRAINT [PK__Accounts__3214EC071537E4F5] PRIMARY KEY CLUSTERED ([Id])
GO


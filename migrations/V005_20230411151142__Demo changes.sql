﻿SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Altering [dbo].[Accounts]'
GO
ALTER TABLE [dbo].[Accounts] ADD
[TEST] [int] NULL
GO
PRINT N'Creating [dbo].[TEST]'
GO
CREATE PROC [dbo].[TEST] 
AS
SELECT GETDATE()
GO


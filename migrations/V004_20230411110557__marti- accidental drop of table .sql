SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating [dbo].[Accounts]'
GO
CREATE TABLE [dbo].[Accounts]
(
[Id] [int] NOT NULL,
[AccountName] [varchar] (20) NULL,
[Status] [varchar] (10) NULL,
[Balance] [decimal] (12, 2) NULL,
[PreviousMonthBalance] [decimal] (12, 2) NULL
)
GO
PRINT N'Creating primary key [PK__Accounts__3214EC071537E4F5] on [dbo].[Accounts]'
GO
ALTER TABLE [dbo].[Accounts] ADD CONSTRAINT [PK__Accounts__3214EC071537E4F5] PRIMARY KEY CLUSTERED ([Id])
GO


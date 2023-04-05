CREATE TABLE [dbo].[Accounts]
(
[Id] [int] NOT NULL,
[AccountName] [varchar] (20) NULL,
[Status] [varchar] (10) NULL,
[Balance] [decimal] (12, 2) NULL
)
GO
ALTER TABLE [dbo].[Accounts] ADD CONSTRAINT [PK__Accounts__3214EC071537E4F5] PRIMARY KEY CLUSTERED ([Id])
GO

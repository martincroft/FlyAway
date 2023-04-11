CREATE TABLE [dbo].[RefData]
(
[ID] [int] NULL,
[Value] [varchar] (200) NULL
)
GO
CREATE CLUSTERED INDEX [IXC_RefData] ON [dbo].[RefData] ([ID])
GO

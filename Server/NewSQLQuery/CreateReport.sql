USE [Meeple]
GO

/****** Object:  Table [dbo].[Report]    Script Date: 12/20/2011 23:53:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Report](
	[reportId] [nvarchar](30) NULL,
	[problemId] [nvarchar](30) NULL,
	[reason] [ntext] NULL,
	[date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO



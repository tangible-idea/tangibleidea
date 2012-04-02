USE [Meeple]
GO

/****** Object:  Table [dbo].[MenteeInfos]    Script Date: 12/20/2011 23:52:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MenteeInfos](
	[AccountId] [int] NOT NULL,
	[Name] [nvarchar](10) NULL,
	[School] [nvarchar](30) NULL,
	[Grade] [int] NULL,
	[Email] [nvarchar](100) NULL,
	[Comment] [nvarchar](200) NULL,
	[Image] [nvarchar](200) NULL,
	[LastModifiedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_MenteeInfos] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MenteeInfos]  WITH CHECK ADD  CONSTRAINT [FK_MenteeInfos_Accounts] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Accounts] ([Id])
GO

ALTER TABLE [dbo].[MenteeInfos] CHECK CONSTRAINT [FK_MenteeInfos_Accounts]
GO



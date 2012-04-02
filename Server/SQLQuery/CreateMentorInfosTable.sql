USE [Meeple]
GO

/****** Object:  Table [dbo].[MentorInfos]    Script Date: 09/21/2011 20:21:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MentorInfos](
	[AccountId] [int] NOT NULL,
	[Name] [nvarchar](10) NULL,
	[Univ] [nvarchar](30) NULL,
	[Major] [nvarchar](30) NULL,
	[Promo] [int] NULL,
	[Email] [nvarchar](100) NULL,
	[Comment] [nvarchar](200) NULL,
	[Image] [nvarchar](200) NULL,
	[LastModifiedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_MentorInfos] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MentorInfos]  WITH CHECK ADD  CONSTRAINT [FK_MentorInfos_Accounts] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Accounts] ([Id])
GO

ALTER TABLE [dbo].[MentorInfos] CHECK CONSTRAINT [FK_MentorInfos_Accounts]
GO


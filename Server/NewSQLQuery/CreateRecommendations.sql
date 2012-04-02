USE [Meeple]
GO

/****** Object:  Table [dbo].[Recommendations]    Script Date: 12/20/2011 23:53:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Recommendations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MentorAccount] [nvarchar](30) NOT NULL,
	[MenteeAccount] [nvarchar](30) NOT NULL,
	[MentorAccepted] [bit] NOT NULL,
	[MenteeAccepted] [bit] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Recommendations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



USE [Meeple]
GO

/****** Object:  Table [dbo].[Accounts]    Script Date: 09/21/2011 20:20:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Accounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account] [nvarchar](30) NOT NULL,
	[Password] [char](32) NOT NULL,
	[Gender] [int] NOT NULL,
	[IsApple] [bit] NOT NULL,
	[Push] [char](64) NOT NULL,
	[IsMentor] [bit] NOT NULL,
	[LastLoginTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


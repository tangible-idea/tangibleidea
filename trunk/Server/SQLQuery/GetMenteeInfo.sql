USE [Meeple]
GO

/****** Object:  StoredProcedure [dbo].[GetMenteeInfo]    Script Date: 09/02/2011 01:48:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMenteeInfo]
	@Account nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [AccountId], [Name], [School], [Grade], [Email], [Comment], [Image], [LastModifiedTime] from MenteeInfos WHERE [AccountId] = ( SELECT [Id] FROM Accounts WHERE [Account] = @Account );
END

GO


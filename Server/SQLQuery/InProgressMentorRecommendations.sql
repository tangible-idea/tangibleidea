USE [Meeple]
GO
/****** Object:  StoredProcedure [dbo].[AcceptedMentorRecommendation]    Script Date: 09/23/2011 02:09:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AcceptedMentorRecommendation]
	-- Add the parameters for the stored procedure here
	@MentorAccount nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT * FROM Recommendations WHERE [MentorAccount]=@MentorAccount and [MentorAccepted]=1 and [MenteeAccepted]=1;
    RETURN @@ROWCOUNT
END

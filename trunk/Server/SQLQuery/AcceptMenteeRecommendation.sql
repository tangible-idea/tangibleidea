USE [Meeple]
GO
/****** Object:  StoredProcedure [dbo].[AcceptMentorRecommendation]    Script Date: 09/25/2011 01:56:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AcceptMenteeRecommendation]
	-- Add the parameters for the stored procedure here
	@MentorAccount nvarchar(30),
	@MenteeAccount nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF EXISTS ( SELECT * from Recommendations WHERE [MentorAccount]=@MentorAccount and [MenteeAccount]=@MenteeAccount and [MentorAccepted]=1 and [MenteeAccepted]=0 )
    BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE [Meeple].[dbo].[Recommendations]
			   SET [MenteeAccepted] = 1
			 WHERE [MentorAccount]=@MentorAccount and [MenteeAccount]=@MenteeAccount;
		END TRY
		BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		END CATCH
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
	END
	ELSE
	BEGIN
		RETURN -1;
	END
END

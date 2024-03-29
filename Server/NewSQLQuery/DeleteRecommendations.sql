USE [Meeple]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRecommendations]    Script Date: 11/27/2011 21:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteRecommendations]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS ( SELECT * from Recommendations WHERE [MentorAccepted] = 0 OR [MenteeAccepted] = 0 )
    BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM Recommendations WHERE ( [MentorAccepted] = 0 OR [MenteeAccepted] = 0 ) AND DATEDIFF(minute, [UpdatedTime], GETDATE()) > 20
		END TRY
		BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		END CATCH
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
	END
END

USE [Meeple]
GO
/****** Object:  StoredProcedure [dbo].[AddMenteeInfo]    Script Date: 11/30/2011 23:38:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ReportUser]
	-- Add the parameters for the stored procedure here
	@ReportId nvarchar(30),
	@ProblemId nvarchar(30),
	@Reason nText
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [Meeple].[dbo].[Report]
				   ([reportId]
					,[problemId]
					,[reason])
			 VALUES
				   (@ReportId
				   ,@ProblemId
				   ,@Reason);
END

-- =============================================
-- Author:		Alex Mackenzie 
-- Git          https://github.com/Two-Bit
-- Description:	Retrieves today's call stats from Skype 
-- =============================================

CREATE PROCEDURE GET_AEGNT_CALLS
	@Workflow varchar(50)
AS
BEGIN
	SELECT
		UserUri AS [WorkFlow],
		UPPER(DisplayName) AS AgentName, Ext,
		COUNT(Agent) AS CallsTaken,
		SUM(TimeOnCall) AS TotalCallTime
	FROM
		dbo.WB_AllCalls
	WHERE        
			(OriginalCallStartTime > CAST(GETDATE() as date))
		AND UserUri = @Workflow
	GROUP BY UserUri, DisplayName, Agent, Ext
END
GO
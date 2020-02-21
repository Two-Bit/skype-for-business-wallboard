-- =============================================
-- Author:		Alex Mackenzie 
-- Git          https://github.com/Two-Bit
-- Description:	Retrieves call stats from all time for a given workflow
-- =============================================

CREATE PROCEDURE GET_ALLTIME_CALL_STATS
	@Workflow varchar(100)
AS
BEGIN

	SELECT         
		ResponseGroupURI,
		CONVERT(varchar(15),	HourOfCall,100) AS [HourOfCall], 
		COUNT(Calls) AS Calls
	FROM    
		(	SELECT        ResponseGroupURI, CAST(DATEADD(hour, DATEDIFF(hour, 0, CallTime), 0) AS time) AS HourOfCall, COUNT(DATEADD(hour, DATEDIFF(hour, 0, CallTime), 0)) AS Calls
			FROM          dbo.SfB_ResponseGroup_Calls
			GROUP BY ResponseGroupURI, CallTime
		 ) AS cl
	WHERE ResponseGroupURI=@Workflow
	GROUP BY ResponseGroupURI, HourOfCall

END
GO

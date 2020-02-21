CREATE VIEW
	[dbo].[SfB_ResponseGroup_Calls]
AS
    SELECT
        CASE
		WHEN cd.RGTimeZone = 'ACST' THEN
			CONVERT(DATE, DATEADD(MI, 30, DATEADD(HH, 09, cd.OCInviteTime)))
		WHEN cd.RGTimeZone = 'AEST' THEN
			CONVERT(DATE, DATEADD(HH, 10, cd.OCInviteTime))
		WHEN cd.RGTimeZone = 'NZST' THEN
--			CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime))
			CASE
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2019-09-29' AND '2020-04-05' THEN
					CONVERT(DATE, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2020-09-27' AND '2021-04-04' THEN
					CONVERT(DATE, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2021-09-26' AND '2022-04-03' THEN
					CONVERT(DATE, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2022-09-25' AND '2023-04-02' THEN
					CONVERT(DATE, DATEADD(HH, 13, cd.OCInviteTime))
				ELSE
					CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime))
			END
		ELSE
			-- Default to QLD Time
			CONVERT(DATE, DATEADD(HH, 10, cd.OCInviteTime))
	END AS CallDate,
        CASE
		WHEN cd.RGTimeZone = 'ACST' THEN
			CONVERT(TIME, DATEADD(MI, 30, DATEADD(HH, 09, cd.OCInviteTime)))
		WHEN cd.RGTimeZone = 'AEST' THEN
			CONVERT(TIME, DATEADD(HH, 10, cd.OCInviteTime))
		WHEN cd.RGTimeZone = 'NZST' THEN
			CASE
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2019-09-29' AND '2020-04-05' THEN
					CONVERT(TIME, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2020-09-27' AND '2021-04-04' THEN
					CONVERT(TIME, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2021-09-26' AND '2022-04-03' THEN
					CONVERT(TIME, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2022-09-25' AND '2023-04-02' THEN
					CONVERT(TIME, DATEADD(HH, 13, cd.OCInviteTime))
				ELSE
					CONVERT(TIME, DATEADD(HH, 12, cd.OCInviteTime))
			END
		ELSE
			-- Default to QLD Time
			CONVERT(TIME, DATEADD(HH, 10, cd.OCInviteTime))
	END AS CallTime,
        CASE
		WHEN cd.RGTimeZone = 'ACST' THEN
			DATEPART(HOUR, DATEADD(MI, 30, DATEADD(HH, 09, cd.OCInviteTime))) * 100 + DATEPART(MINUTE, DATEADD(MI, 30, DATEADD(HH, 09, cd.OCInviteTime)))
		WHEN cd.RGTimeZone = 'AEST' THEN
			DATEPART(HOUR, DATEADD(HH, 10, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 10, cd.OCInviteTime))
		WHEN cd.RGTimeZone = 'NZST' THEN
			CASE
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2019-09-29' AND '2020-04-05' THEN
					DATEPART(HOUR, DATEADD(HH, 13, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2020-09-27' AND '2021-04-04' THEN
					DATEPART(HOUR, DATEADD(HH, 13, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2021-09-26' AND '2022-04-03' THEN
					DATEPART(HOUR, DATEADD(HH, 13, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 13, cd.OCInviteTime))
				WHEN CONVERT(DATE, DATEADD(HH, 12, cd.OCInviteTime)) BETWEEN '2022-09-25' AND '2023-04-02' THEN
					DATEPART(HOUR, DATEADD(HH, 13, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 13, cd.OCInviteTime))
				ELSE
					DATEPART(HOUR, DATEADD(HH, 12, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 12, cd.OCInviteTime))
			END
		ELSE
			-- Default to QLD Time
			DATEPART(HOUR, DATEADD(HH, 12, cd.OCInviteTime)) * 100 + DATEPART(MINUTE, DATEADD(HH, 12, cd.OCInviteTime)) 
	END AS CallTimeNumber,
        cd.CorrelationId AS CorrelationID,
        cd.CallerUri AS CallerURI,
        cd.RGTimeZone,
        cd.RGSUserUri AS ResponseGroupURI,
        CASE
		WHEN cd.ACResponseCode = 200 THEN
			cd.AgentUri
	END AS AgentURI,
        cd.OCSessionIdTime AS CallerSessionIDTime,
        cd.OCInviteTime AS CallerInviteTime,
        cd.OCSessionEndTime AS CallerSessionEndTime,
        cd.OCResponseTime AS ResponseGroupResponseTime,
        CASE
		WHEN cd.ACResponseCode = 200 THEN
			cd.ACResponseTime
	END AS AgentResponseTime,
        CASE
		WHEN MAX(cd.AgentPickedUpFlag) = 1 THEN
			1
		ELSE
			0
	END AS CallAnsweredCount,
        CASE
		WHEN MAX(cd.AgentPickedUpFlag) = 1 THEN
			0
		ELSE
			1
	END AS CallNotAnsweredCount,
        CASE
		WHEN MAX(cd.AgentPickedUpFlag) = 1 THEN
			0
		ELSE
			CASE
				WHEN DATEDIFF(SS, cd.OCInviteTime, COALESCE(cd.OCSessionEndTime, cd.OCInviteTime)) < 3 THEN
					1
				ELSE
					0
			END
	END AS CallNotAnsweredUnder3SecondsCount,
        CASE
		WHEN MAX(cd.AgentPickedUpFlag) = 1 THEN
			0
		ELSE
			CASE
				WHEN DATEDIFF(SS, cd.OCInviteTime, COALESCE(cd.OCSessionEndTime, cd.OCInviteTime)) > 10 THEN
					1
				ELSE
					0
			END
	END AS CallNotAnsweredOver10SecondsCount,
        1 AS CallTotalCount,
        SUM(CASE
		WHEN cd.ACResponseCode = 200 THEN
			DATEDIFF(SS, cd.OCInviteTime, COALESCE(cd.ACResponseTime, cd.OCResponseTime))
		ELSE
			DATEDIFF(SS, cd.OCInviteTime, COALESCE(cd.OCSessionEndTime, cd.OCInviteTime))
	END) AS CallAnsweredWaitTime,
        SUM(CASE
		WHEN cd.ACResponseCode = 200 THEN
			DATEDIFF(SS, COALESCE(cd.ACResponseTime, cd.OCResponseTime), COALESCE(cd.ACSessionEndTime, cd.ACResponseTime, cd.OCResponseTime))
		ELSE
			DATEDIFF(SS, cd.OCInviteTime, COALESCE(cd.OCResponseTime, cd.OCInviteTime))
	END) AS CallAnsweredCallTime,
        SUM(DATEDIFF(SS, cd.OCInviteTime, COALESCE(cd.ACSessionEndTime, cd.OCSessionEndTime))) AS CallTotalTime

    FROM
        (SELECT
            oc.CorrelationId,
            oc.SessionIdTime AS OCSessionIdTime,
            oc.SessionIdSeq AS OCSessionIdSeq,
            ac.SessionIdTime AS ACSessionIdTime,
            ac.SessionIdSeq AS ACSessionIdSeq,
            CASE
			WHEN CHARINDEX('.co.nz', oc.RGSUserUri) > 0 THEN
				'NZST'
			WHEN CHARINDEX('.com.au', oc.RGSUserUri) > 0 THEN
				'AEST'
			ELSE
				'AEST'
		END AS RGTimeZone,
            oc.CallerUri,
            oc.RGSUserUri,
            ac.UserAgentUri AS AgentUri,
            CASE
			WHEN oc.ResponseCode = 200 THEN
				1
			ELSE
				0
		END AS RGSPickedUpFlag,
            CASE
			WHEN ac.ResponseCode = 200 THEN
				1
			ELSE
				0
		END AS AgentPickedUpFlag,
            oc.InviteTime AS OCInviteTime,
            ac.InviteTime AS ACInviteTime,
            oc.ResponseTime AS OCResponseTime,
            ac.ResponseTime AS ACResponseTime,
            oc.SessionEndTime AS OCSessionEndTime,
            ac.SessionEndTime AS ACSessionEndTime,
            oc.ResponseCode AS OCResponseCode,
            ac.ResponseCode AS ACResponseCode,
            oc.DiagnosticId AS OCDiagnosticId,
            ac.DiagnosticId AS ACDiagnosticId
        FROM
            (SELECT
                sd.SessionIdTime,
                sd.SessionIdSeq,
                sd.InviteTime,
                sd.ResponseTime,
                sd.SessionEndTime,
                sd.CorrelationId,
                sd.SessionStartedById,
                sd.User1Id,
                sd.User2Id,
                u1.UserUri AS User1Uri,
                u2.UserUri AS User2Uri,
                cv1.ClientType AS Client1Type,
                cv1.ClientType AS Client2Type,
                CASE
				WHEN cv1.ClientType = 1024 THEN
					sd.User1Id
				ELSE
					sd.User2Id
			END AS RGSUserId,
                CASE
				WHEN cv1.ClientType = 1024 THEN
					u1.UserUri
				ELSE
					u2.UserUri
			END AS RGSUserUri,
                CASE
				WHEN v.FromMediationServerId IS NOT NULL THEN
					v.FromNumberId
				ELSE
					NULL
			END AS CallerPhoneId,
                CASE
				WHEN v.FromMediationServerId IS NULL THEN
					sd.SessionStartedById
			ELSE
				NULL
			END AS CallerUserId,
                CASE
				WHEN (v.FromMediationServerId IS NOT NULL OR v.FromGatewayId IS NOT NULL) THEN
					p.PhoneUri
				WHEN sd.User1Id = sd.SessionStartedById THEN
					ISNULL(u1.UserUri, p.PhoneUri)
				WHEN sd.User2Id = sd.SessionStartedById THEN
					ISNULL(u2.UserUri, p.PhoneUri)
				ELSE
					ISNULL(u1.UserUri, p.PhoneUri)
			END AS CallerUri,
                sd.ResponseCode,
                sd.DiagnosticId
            FROM
                LcsCDR.dbo.CDRReportsSessionDetailsBaseView sd WITH (NOLOCK)
                LEFT JOIN
                LcsCDR.dbo.VoipDetails v WITH (NOLOCK)
                ON
					sd.SessionIdTime = v.SessionIdTime
                    AND sd.SessionIdSeq = v.SessionIdSeq
                LEFT JOIN
                LcsCDR.dbo.ClientVersions cv1 WITH (NOLOCK)
                ON
				sd.User1ClientVerId = cv1.VersionId
                LEFT JOIN
                LcsCDR.dbo.ClientVersions cv2 WITH (NOLOCK)
                ON
				sd.User2ClientVerId = cv2.VersionId
                LEFT JOIN
                LcsCDR.dbo.Users u1 WITH (NOLOCK)
                ON
				sd.User1Id = u1.UserId
                LEFT JOIN
                LcsCDR.dbo.Users u2 WITH (NOLOCK)
                ON
				sd.User2Id = u2.UserId
                LEFT JOIN
                LcsCDR.dbo.Phones p WITH (NOLOCK)
                ON
				v.FromNumberId = p.PhoneId
            WHERE 
				(	(sd.SessionStartedById = sd.User1Id AND cv2.ClientType = 1024)
                OR (sd.SessionStartedById = sd.User2Id AND cv1.ClientType = 1024)
                OR (	v.FromMediationServerId IS NOT NULL
                AND (	(sd.User1Id IS NOT NULL AND cv1.ClientType = 1024)
                OR (sd.User2Id IS NOT NULL AND cv2.ClientType = 1024))))
                AND sd.ReplacesDialogIdTime IS NULL
                AND sd.ReplacesDialogIdSeq IS NULL
                AND sd.MediaTypes <> 1
                AND (sd.CallFlag & 0x02) = 0) oc
            LEFT JOIN
            (SELECT
                sd.SessionIdTime,
                sd.SessionIdSeq,
                sd.InviteTime,
                sd.ResponseTime,
                sd.SessionEndTime,
                sd.CorrelationId,
                sd.SessionStartedById,
                sd.User1Id,
                sd.User2Id,
                u1.UserUri AS User1Uri,
                u2.UserUri AS User2Uri,
                cv.ClientType,
                ua.UserUri AS UserAgentUri,
                sd.ResponseCode,
                sd.DiagnosticId
            FROM
                LcsCDR.dbo.CDRReportsSessionDetailsBaseView sd WITH (NOLOCK)
                LEFT JOIN
                LcsCDR.dbo.ClientVersions cv WITH (NOLOCK)
                ON
				cv.VersionId =
					(CASE
						WHEN sd.SessionStartedById IS NOT NULL AND sd.SessionStartedById = sd.User1Id THEN
							sd.User1ClientVerId
						WHEN sd.SessionStartedById IS NOT NULL AND sd.SessionStartedById = sd.User2Id THEN
							sd.User2ClientVerId
						WHEN sd.TargetUserId IS NOT NULL AND sd.TargetUserId = sd.User1Id THEN
							sd.User2ClientVerId
						WHEN sd.TargetUserId IS NOT NULL AND sd.TargetUserId = sd.User2Id THEN
							sd.User1ClientVerId
						ELSE
							sd.User1ClientVerId
					END)
                LEFT JOIN
                LcsCDR.dbo.Users u1 WITH (NOLOCK)
                ON
				sd.User1Id = u1.UserId
                LEFT JOIN
                LcsCDR.dbo.Users u2 WITH (NOLOCK)
                ON
				sd.User2Id = u2.UserId
                LEFT JOIN
                LcsCDR.dbo.Users ua WITH (NOLOCK)
                ON
				ua.UserId =
					(CASE
						WHEN sd.SessionStartedById IS NOT NULL AND sd.SessionStartedById = sd.User1Id THEN
							sd.User2Id
						WHEN sd.SessionStartedById IS NOT NULL AND sd.SessionStartedById = sd.User2Id THEN
							sd.User1Id
						WHEN sd.TargetUserId IS NOT NULL AND sd.TargetUserId = sd.User1Id THEN
							sd.User1Id
						WHEN sd.TargetUserId IS NOT NULL AND sd.TargetUserId = sd.User2Id THEN
							sd.User2Id
						ELSE
							sd.User2Id
					END)
            WHERE
				sd.MediaTypes <> 1
                AND sd.ResponseCode = 200) ac
            ON
			oc.CorrelationId = ac.CorrelationId
                AND (	oc.SessionIdTime <> ac.SessionIdTime
                OR oc.SessionIdSeq <> ac.SessionIdSeq)
                AND ac.ClientType = 1024) cd
    GROUP BY
	cd.CorrelationId,
	cd.CallerUri,
	cd.RGTimeZone,
	cd.RGSUserUri,
	CASE
		WHEN cd.ACResponseCode = 200 THEN
			cd.AgentUri
	END,
	cd.OCSessionIdTime,
	cd.OCInviteTime,
	cd.OCSessionEndTime,
	cd.OCResponseTime,
	CASE
		WHEN cd.ACResponseCode = 200 THEN
			cd.ACResponseTime
	END
GO



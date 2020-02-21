
-- =============================================
-- Author:		Alex Mackenzie
-- Git          https://github.com/Two-Bit
-- Description:	Abstract view into Microsoft Skype Database into a human readable format
-- =============================================

CREATE VIEW [dbo].[WB_AllCalls]
AS
    SELECT
        WF.UserUri, OriginCall.RGSUserId,
        OriginCall.Caller,
        u.DisplayName,
        u.Ext,
        UAgent.UserUri AS Agent,
        DATEADD(HOUR, 10, OriginCall.ResponseTime) AS OriginalCallStartTime,
        DATEADD(HOUR, 10, LastCall.ResponseTime) AS FinalAnswerTime,
        DATEADD(HOUR, 10, LastCall.SessionEndTime) AS FinalCallEndTime,
        DATEDIFF(SECOND, DATEADD(HOUR, 10, OriginCall.ResponseTime), 
        DATEADD(HOUR, 10, LastCall.ResponseTime)) AS TimeToAnswer,
        DATEDIFF(SECOND, DATEADD(HOUR, 10, OriginCall.ResponseTime), 
        DATEADD(HOUR, 10, LastCall.SessionEndTime)) AS TimeOnCall
    FROM (
            SELECT
            SD.SessionIdTime,
            SD.SessionIdSeq,
            SD.CorrelationId,
            SD.ResponseTime,
            SD.SessionEndTime,
            (
                    CASE 
                        WHEN CV1.ClientType = 1024 THEN User1Id 
                        ELSE User2Id END
                ) AS RGSUserId,
            (
                    CASE 
                        WHEN CV1.ClientType = 1024 THEN U1.UserUri 
                        ELSE U2.UserUri END
                ) AS RGSUser,
            (
                    CASE 
                        WHEN V.FromMediationServerId IS NOT NULL THEN V.FromNumberId 
                        ELSE NULL END
                ) AS CallerPhoneId,
            (
                    CASE 
                        WHEN V.FromMediationServerId IS NULL THEN SD.SessionStartedById 
                        ELSE NULL END
                ) AS CallerUserId,
            (
                    CASE 
                        WHEN (V.FromMediationServerId IS NOT NULL OR V.FromGatewayId IS NOT NULL) THEN PH.PhoneUri 
                        WHEN SD.User1Id = SD.SessionStartedById THEN IsNull(U1.UserUri, PH.PhoneUri) 
                        WHEN SD.User2Id = SD.SessionStartedById THEN IsNull(U2.UserUri, PH.PhoneUri) 
                        ELSE IsNull(U1.UserUri, PH.PhoneUri) END
                ) AS Caller,
            SD.ResponseCode,
            SD.DiagnosticId
        FROM LcsCDR.dbo.CDRReportsSessionDetailsBaseView AS SD
            LEFT OUTER JOIN
                LcsCDR.dbo.VoipDetails AS V ON SD.SessionIdTime = V.SessionIdTime AND SD.SessionIdSeq = V.SessionIdSeq
            LEFT OUTER JOIN
                LcsCDR.dbo.ClientVersions AS CV1 ON SD.User1ClientVerId = CV1.VersionId
            LEFT OUTER JOIN
                LcsCDR.dbo.ClientVersions AS CV2 ON SD.User2ClientVerId = CV2.VersionId
            LEFT OUTER JOIN
                LcsCDR.dbo.Users AS U1 ON SD.User1Id = U1.UserId
            LEFT OUTER JOIN
                LcsCDR.dbo.Users AS U2 ON SD.User2Id = U2.UserId
            LEFT OUTER JOIN
                LcsCDR.dbo.Phones AS PH ON V.FromNumberId = PH.PhoneId
        WHERE        
            (SD.SessionStartedById = SD.User1Id) 
            AND (CV2.ClientType = 1024) 
            AND (SD.ReplacesDialogIdTime IS NULL) 
            AND (SD.ReplacesDialogIdSeq IS NULL) 
            AND (SD.MediaTypes <> 1) 
            AND (SD.CallFlag & 0x02 = 0) OR (SD.SessionStartedById = SD.User2Id) 
            AND (SD.ReplacesDialogIdTime IS NULL) 
            AND (SD.ReplacesDialogIdSeq IS NULL) 
            AND (SD.MediaTypes <> 1) AND (SD.CallFlag & 0x02 = 0) 
            AND (CV1.ClientType = 1024) OR(SD.ReplacesDialogIdTime IS NULL) 
            AND (SD.ReplacesDialogIdSeq IS NULL) AND (SD.MediaTypes <> 1) 
            AND (SD.CallFlag & 0x02 = 0) 
            AND (CV1.ClientType = 1024) 
            AND (V.FromMediationServerId IS NOT NULL) 
            AND (SD.User1Id IS NOT NULL) OR (CV2.ClientType = 1024) 
            AND (SD.ReplacesDialogIdTime IS NULL) 
            AND (SD.ReplacesDialogIdSeq IS NULL) 
            AND (SD.MediaTypes <> 1) 
            AND (SD.CallFlag & 0x02 = 0) 
            AND (V.FromMediationServerId IS NOT NULL) 
            AND (SD.User2Id IS NOT NULL)) AS OriginCall 
        LEFT OUTER JOIN
        (
                SELECT 
                    SD.SessionIdTime, SD.SessionIdSeq, SD.CorrelationId, SD.ReplacesDialogIdTime, SD.ReplacesDialogIdSeq, SD.User1Id, SD.User2Id, SD.User1EndpointId, SD.User2EndpointId, SD.TargetUserId,
                    SD.SessionStartedById, SD.OnBehalfOfId, SD.ReferredById, SD.ServerId, SD.PoolId, SD.ContentTypeId, SD.User1ClientVerId, SD.User2ClientVerId, SD.User1EdgeServerId, SD.User2EdgeServerId,
                    SD.IsUser1Internal, SD.IsUser2Internal, SD.InviteTime, SD.ResponseTime, SD.ResponseCode, SD.DiagnosticId, SD.CallPriority, SD.User1MessageCount, SD.User2MessageCount, SD.SessionEndTime,
                    SD.MediaTypes, SD.User1Flag, SD.User2Flag, SD.CallFlag, SD.Processed, SD.LastModifiedTime, CV.VersionId, CV.Version, CV.ClientType
                FROM LcsCDR.dbo.CDRReportsSessionDetailsBaseView AS SD 
                LEFT OUTER JOIN
                    LcsCDR.dbo.ClientVersions AS CV ON CV.VersionId = (CASE WHEN SessionStartedById IS NOT NULL 
                    AND SessionStartedById = User1Id THEN User1ClientVerId WHEN SessionStartedById IS NOT NULL 
                    AND SessionStartedById = User2Id THEN User2ClientVerId WHEN TargetUserId IS NOT NULL 
                    AND TargetUserId = User1Id THEN User2ClientVerId WHEN TargetUserId IS NOT NULL 
                    AND TargetUserId = User2Id THEN User1ClientVerId ELSE User1ClientVerId END)
                WHERE        
                    (SD.MediaTypes <> 1) AND (SD.ResponseCode = 200)
        ) AS AgentCall 
                ON OriginCall.CorrelationId = AgentCall.CorrelationId 
                AND (OriginCall.SessionIdTime <> AgentCall.SessionIdTime OR OriginCall.SessionIdSeq <> AgentCall.SessionIdSeq) 
                AND AgentCall.ClientType = 1024 
        LEFT OUTER JOIN
            LcsCDR.dbo.Users AS UAgent ON UAgent.UserId = (CASE WHEN AgentCall.SessionStartedById IS NOT NULL 
            AND AgentCall.SessionStartedById = AgentCall.User1Id THEN AgentCall.User2Id WHEN AgentCall.SessionStartedById IS NOT NULL 
            AND AgentCall.SessionStartedById = AgentCall.User2Id THEN AgentCall.User1Id WHEN AgentCall.TargetUserId IS NOT NULL 
            AND AgentCall.TargetUserId = AgentCall.User1Id THEN AgentCall.User1Id WHEN AgentCall.TargetUserId IS NOT NULL 
            AND AgentCall.TargetUserId = AgentCall.User2Id THEN AgentCall.User2Id ELSE AgentCall.User2Id END)
        JOIN 
            WB_Workflows wf ON OriginCall.RGSUserId=WF.UserId
        LEFT OUTER JOIN
            LcsCDR.dbo.CDRReportsSessionDetailsBaseView AS LastCall ON LastCall.ReplacesDialogIdTime = OriginCall.SessionIdTime 
            AND LastCall.ReplacesDialogIdSeq = OriginCall.SessionIdSeq 
            AND (LastCall.ReferredById = OriginCall.RGSUserId 
            AND LastCall.SessionStartedById = UAgent.UserId OR LastCall.CorrelationId IS NOT NULL 
            AND LastCall.SessionStartedById = OriginCall.RGSUserId) 
            AND LastCall.MediaTypes <> 1
        JOIN 
            WB_UserSIPExt u ON u.SIP=UAgent.UserUri COLLATE SQL_Latin1_General_CP1_CI_AI
WHERE        
    (AgentCall.ResponseCode = 200) 
    AND (LastCall.ResponseCode = 200)
GO



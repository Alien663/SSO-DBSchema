
create    view [dbo].[vd_AuthorizationCodeSession]
as
select
	A.AID, 
	A.[Name] as AppName,
	A.[Description] as AppDes,
	A.[URL] as Domain,
	A.RedirectURL,
	A.APIKEY,
	ACS.AuthorizationCode,
	DATEADD(s, ACS.Expire, ACS.Since) as AuthorizationCodeExpired,
	S.SSID,
	S.Token as AccessToken,
	DATEADD(s, S.Expire, S.Since) as AccessTokenExpired
from APP A
	inner join AuthCode ACS on A.AID = ACS.AID
	inner join SystemSession S on ACS.SSID = S.SSID
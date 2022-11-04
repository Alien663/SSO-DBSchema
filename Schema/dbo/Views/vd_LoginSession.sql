create view [dbo].[vd_LoginSession]
as
select
	M.MID,
	M.Account,
	M.Solt as UUID,
	M.EMail,
	M.NickName,
	S.SSID,
	S.Token,
	RefreshToken,
	DATEADD(ss, S.Expire, S.Since) as Expired,
	[Type]
from SystemSession S
	inner join Member M on S.MID = M.MID
where Expire is not null
and S.[Type] = 1
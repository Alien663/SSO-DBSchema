create   view vd_VerifySession
as
	select
		M.MID,
		M.Solt as [UUID],
		M.Account,
		M.NickName,
		M.EMail,
		M.Verify,
		S.SSID,
		S.Token,
		DATEADD(ss, S.Expire, S.Since) as Expired
	from Member M
		inner join SystemSession S on M.MID = S.MID
	where S.[Type] = 3
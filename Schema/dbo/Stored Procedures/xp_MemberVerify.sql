

CREATE procedure [dbo].[xp_MemberVerify]
	@token uniqueidentifier,
	@guid uniqueidentifier
as begin
	declare @ssid int = (select SSID from vd_VerifySession where UUID = @guid and Token = @token and Verify = 0)
	if @ssid is null
		raiserror('Session not exists', 18, 2)
	else
		if exists(select 1 from vd_VerifySession where SSID = @ssid and Expired >= getdate()) begin
			update Member
				set Verify = 1
				where Solt = @guid
			update SystemSession
				set Expire = null
				where SSID = @ssid
		end
			
		else
			raiserror('Verify Key is Expired', 18, 3)
end
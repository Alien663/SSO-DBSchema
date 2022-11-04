


CREATE   procedure [dbo].[xp_logout]
	@mid int,
	@token uniqueidentifier,
	@refreshtoken uniqueidentifier
as begin
	begin try
		declare @ssid int = (select SSID from vd_LoginSession where MID = @mid and Token = @token and RefreshToken = @refreshtoken)
		if @ssid is null
			raiserror('User had been logout', 18, 2)
		else
			update SystemSession
				set Expire = null
				where SSID = @ssid
	end try
	begin catch
		DECLARE @ErrorMessage As VARCHAR(1000) =ERROR_MESSAGE()
		raiserror(@ErrorMessage, 18, 1)
	end catch
end
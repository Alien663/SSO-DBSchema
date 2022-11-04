

CREATE    procedure [dbo].[xp_loginWithToken]
	@token uniqueidentifier,
	@mid int output
as
begin
    set nocount on;
    begin try
        declare @ssid int = (select SSID from vd_LoginSession where Token = @token)
		if @ssid is null
			raiserror('Session not found', 18, 2)
		else
			if exists(select 1 from vd_LoginSession where SSID = @ssid and Expired < GETDATE())
				set @mid = -1
			else
				set @mid = (select MID from vd_LoginSession where SSID = @ssid)
			return;
    end try
    begin catch
        declare @message varchar(4000) = ERROR_MESSAGE()
        raiserror (@message, 18, 1) ;
    end catch
	set nocount off
end
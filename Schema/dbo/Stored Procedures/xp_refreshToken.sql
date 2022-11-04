create   procedure [xp_refreshToken]
	@token uniqueidentifier,
	@refresh_token uniqueidentifier,
	@new_token uniqueidentifier output,
	@new_refresh_token uniqueidentifier output,
	@mid int output
as
begin
    set nocount on;
	set xact_abort on
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction xp_refreshToken;


       declare @ssid int = (select SSID from vd_LoginSession where Token = @token and RefreshToken = @refresh_token)
		if @ssid is null
			raiserror('Session is not found', 18, 2)
		else begin
			if exists(select 1 from vd_LoginSession where SSID = @ssid and Expired < getdate()) begin
				update SystemSession
					set Expire = null
					where Token = @token
				select @new_refresh_token = NEWID(), @new_token = NEWID()
				set @mid = (select top 1 MID from SystemSession where SSID = @ssid)
				insert into SystemSession(Token, RefreshToken, MID, Expire, [Type])
					select @new_token, @new_refresh_token, MID, 600, 1
					from SystemSession
					where SSID = @ssid
			end else
				raiserror('Session have not been expired.', 18, 3)
			return;
		end

        if @trancount = 0   
            commit;
    end try
    begin catch
        declare @error int, @message varchar(4000), @xstate int;
        select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction xp_refreshToken;

        raiserror ('xp_refreshToken: %d: %s', 16, 1, @error, @message) ;
    end catch
	set xact_abort off
	set nocount off
end
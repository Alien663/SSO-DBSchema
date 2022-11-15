


CREATE    procedure [dbo].[xp_EndpointLoginWithPassword]
	@acc varchar(100),
	@pwd varchar(100),
	@aid int,
	@authcode uniqueidentifier output,
	@isGrant bit output
as
begin
    set nocount on;
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction xp_EndpointLoginWithPassword;

        
		declare @mid int = (select MID from Member where Account = @acc and [Password] = HASHBYTES('SHA2_256', @pwd + REPLACE(CONVERT(varchar(36), Solt), '-', '')))
		if @mid is null
			raiserror('Account or Password is not correct, please check again.', 18, 4)
		else begin
			select @isGrant = isnull(1, 0) from Grants where MID = @mid and AID = @aid

			select @authcode = NEWID()
			declare @ssid int = (select top 1 SSID from vd_LoginSession where MID = @mid and Expired >= GETDATE())
			if @ssid is null begin
				insert into SystemSession(Token, RefreshToken, Expire, MID, [Type])
					values (NEWID(), NEWID(), 600, @mid, 1) -- set 10 minutes alive
				set @ssid = SCOPE_IDENTITY()
			end
			insert into AuthCode(AID, SSID, AuthorizationCode)
				values(@aid, @ssid, @authcode)
		end


        if @trancount = 0   
            commit;
    end try
    begin catch
        declare @message varchar(4000), @xstate int;
        select @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;
        raiserror (@message, 16, 1) ;
    end catch   
end
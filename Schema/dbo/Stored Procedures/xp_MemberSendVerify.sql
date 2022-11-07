create   procedure xp_MemberSendVerify
	@mid int
as
begin
	set nocount on;
	set XACT_ABORT on
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction xp_MemberSendVerify;

		if exists(select 1 from Member where MID = @mid and Verify = 0) begin
			if exists(select 1 from vd_VerifySession where MID = @mid)
				update SystemSession
					set Expire = null
					where MID = @mid and [Type] = 3
			declare @token uniqueidentifier = newid()
			insert into SystemSession(Token, Expire, MID, [Type])
				values(@token, 600, @mid, 3)
			declare @ssid int = SCOPE_IDENTITY()
			select * from vd_VerifySession where SSID = @ssid
		end else
			raiserror('This user had been verified', 18, 2)

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
            rollback transaction xp_MemberSendVerify;
        raiserror (@message, 16, 1);
    end catch 
	set XACT_ABORT off
	set nocount on;
end


create    procedure [dbo].[xp_PasswordSendVerify]
	@email varchar(128),
	@account varchar(100)
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

		declare @mid int = (select MID from MEmber where Account = @account and EMail = @email)
		if @mid is null
			raiserror('Account or EMail is wrong, please check and try again', 18, 2)
		else begin
			if exists(select 1 from vd_ForgePasswordSession where Account = @account)
				update SystemSession
					set Expire = null
					where MID = @mid and [Type] = 2
			declare @token uniqueidentifier = newid()
			insert into SystemSession(Token, Expire, MID, [Type])
				values(@token, 600, @mid, 2)
			declare @ssid int = SCOPE_IDENTITY()
			select * from vd_ForgePasswordSession where SSID = @ssid
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
            rollback transaction xp_MemberSendVerify;
        raiserror (@message, 16, 1);
    end catch 
	set XACT_ABORT off
	set nocount on;
end
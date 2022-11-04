CREATE procedure [dbo].[xp_createNewUser]
	@acc varchar(100),
	@pwd varchar(100),
	@email varchar(127),
	@nickname nvarchar(60),
	@mid int output
as
begin
set nocount on
	begin try 
		if exists(select 1 from Member where Account = @acc)begin
			raiserror('This account has been exist, please change another one', 18 ,10)
			return;
		end else if exists(select 1 from Member where EMail = @email) begin
			raiserror('This EMail has been exist, please change another one', 18 ,10)
			return;
		end else begin
			declare @solt uniqueidentifier = NEWID()
			insert into Member(Account, [Password], EMail, NickName, Solt)
				values(@acc, HASHBYTES('SHA2_256',
						@pwd + REPLACE(convert(varchar(36), @solt), '-', '')),
					@email, @nickname, @solt
				)
			set @mid = SCOPE_IDENTITY()
			return;
		end
	end try
	
	begin catch 
		DECLARE @ErrorMessage As VARCHAR(1000) =ERROR_MESSAGE()
		raiserror(@ErrorMessage, 18, 10)
		return;
	end catch
set nocount off
end




CREATE procedure [dbo].[xp_loginWithPassword]
	@acc varchar(100),
	@pwd varchar(100),
	@token uniqueidentifier output,
	@refreshtoken uniqueidentifier output
as
begin
set nocount on
	begin try
		declare @mid int = (select MID from Member where Account = @acc and [Password] = HASHBYTES('SHA2_256', @pwd + REPLACE(CONVERT(varchar(36), Solt), '-', '')))
		if @mid is null
			raiserror('Account or Password is not correct, please check again.', 18, 2)
		else begin
			if exists(select 1 from vd_LoginSession where MID = @mid and Expired >= GETDATE())
				select top 1 @token=Token, @refreshtoken=RefreshToken from vd_LoginSession where MID = @mid and Expired >= GETDATE()
			else begin
				select @token = NEWID(), @refreshtoken = NEWID()
				insert into SystemSession(Token, RefreshToken, Expire, MID, [Type])
					values(@token, @refreshtoken, 600, @mid, 1) -- set 10 minutes alive
			end
			return;
		end
	end try
	begin catch
		DECLARE @ErrorMessage As VARCHAR(1000) =ERROR_MESSAGE()
		raiserror(@ErrorMessage, 18, 1)
	end catch
set nocount off
end

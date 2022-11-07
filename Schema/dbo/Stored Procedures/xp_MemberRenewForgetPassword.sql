



CREATE   procedure [dbo].[xp_MemberRenewForgetPassword]
	 @token uniqueidentifier,
	 @uuid uniqueidentifier,
	 @newpassword varchar(100)
as begin
	if exists(select * from vd_ForgePasswordSession where UUID = @uuid and Token = @token and Expired >= GETDATE())begin
		declare @newpwd binary(32) = (select HASHBYTES('SHA2_256', @newpassword + REPLACE(CONVERT(varchar(36), Solt), '-', '')) from Member where Solt = @uuid)
		update Member
			set [Password] = @newpwd
			where Solt = @uuid
		update SystemSession
			set Expire = null
			where Token = @token and [Type] = 2
	end else
		raiserror('Wrong or expired session', 18, 2)
end
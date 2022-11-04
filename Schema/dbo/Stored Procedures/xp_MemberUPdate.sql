

CREATE   procedure [dbo].[xp_MemberUpdate]
	@mid int,
	@uuid uniqueidentifier,
	@acc varchar(100),
	@nickname varchar(60),
	@email varchar(127)
as begin
	if exists(select 1 from Member where MID = @mid and Solt = @uuid and Account = @acc)
		update Member
			set NickName = @nickname,
				EMail = @email,
				ModifyDate = GETDATE()
			where MID = @mid
	else
	raiserror('User is not exists', 18, 2)
end
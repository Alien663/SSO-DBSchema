
create   view [dbo].[vd_Member]
as
select
	MID,
	Solt as UUID,
	Account,
	EMail,
	NickName,
	Since,
	ModifyDate
from Member
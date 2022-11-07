/*
Schema_1 的部署指令碼

這段程式碼由工具產生。
變更這個檔案可能導致不正確的行為，而且如果重新產生程式碼，
變更將會遺失。
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Schema_1"
:setvar DefaultFilePrefix "Schema_1"
:setvar DefaultDataPath "C:\Users\11107063\AppData\Local\Microsoft\VisualStudio\SSDT\Schema"
:setvar DefaultLogPath "C:\Users\11107063\AppData\Local\Microsoft\VisualStudio\SSDT\Schema"

GO
:on error exit
GO
/*
偵測 SQLCMD 模式，如果不支援 SQLCMD 模式，則停用指令碼執行。
若要在啟用 SQLCMD 模式後重新啟用指令碼，請執行以下:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'必須啟用 SQLCMD 模式才能成功執行此指令碼。';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'已略過索引鍵為 a1634d87-6244-4e97-b416-73121181890c 的重新命名重構作業，項目 [dbo].[SystemSession].[Token] (SqlSimpleColumn) 將不會重新命名為 AccessToken';


GO
PRINT N'正在建立 資料表 [dbo].[APP]...';


GO
CREATE TABLE [dbo].[APP] (
    [AID]         INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NULL,
    [Description] VARCHAR (256)  NULL,
    [URL]         VARCHAR (1024) NULL,
    [RedirectURL] VARCHAR (1024) NULL,
    [MID]         INT            NULL,
    CONSTRAINT [PK_APP] PRIMARY KEY CLUSTERED ([AID] ASC)
);


GO
PRINT N'正在建立 資料表 [dbo].[Login]...';


GO
CREATE TABLE [dbo].[Login] (
    [MID]  INT NOT NULL,
    [SSID] INT NOT NULL,
    CONSTRAINT [PK_Login] PRIMARY KEY CLUSTERED ([MID] ASC, [SSID] ASC)
);


GO
PRINT N'正在建立 資料表 [dbo].[Member]...';


GO
CREATE TABLE [dbo].[Member] (
    [MID]        INT              IDENTITY (1, 1) NOT NULL,
    [Account]    VARCHAR (100)    NOT NULL,
    [Password]   BINARY (32)      NOT NULL,
    [EMail]      VARCHAR (128)    NULL,
    [NickName]   NVARCHAR (64)    NULL,
    [Solt]       UNIQUEIDENTIFIER NULL,
    [Since]      DATETIME         NULL,
    [ModifyDate] DATETIME         NULL,
    [Verify]     BIT              NULL,
    CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED ([MID] ASC),
    CONSTRAINT [UQ_Member_Account] UNIQUE NONCLUSTERED ([Account] ASC),
    CONSTRAINT [UQ_Member_EMail] UNIQUE NONCLUSTERED ([EMail] ASC)
);


GO
PRINT N'正在建立 資料表 [dbo].[SystemSession]...';


GO
CREATE TABLE [dbo].[SystemSession] (
    [SSID]         INT              IDENTITY (1, 1) NOT NULL,
    [Token]        UNIQUEIDENTIFIER NOT NULL,
    [RefreshToken] UNIQUEIDENTIFIER NOT NULL,
    [Since]        DATETIME         NULL,
    [Expire]       INT              NULL,
    [MID]          INT              NULL,
    [Type]         INT              NULL,
    CONSTRAINT [PK_SystemSession] PRIMARY KEY CLUSTERED ([SSID] ASC)
);


GO
PRINT N'正在建立 資料表 [dbo].[Tag]...';


GO
CREATE TABLE [dbo].[Tag] (
    [TID]         INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (64)  NULL,
    [Description] NVARCHAR (128) NULL,
    CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED ([TID] ASC)
);


GO
PRINT N'正在建立 預設條件約束 [dbo].[Member] 上的未命名條件約束...';


GO
ALTER TABLE [dbo].[Member]
    ADD DEFAULT (getdate()) FOR [Since];


GO
PRINT N'正在建立 預設條件約束 [dbo].[Member] 上的未命名條件約束...';


GO
ALTER TABLE [dbo].[Member]
    ADD DEFAULT (getdate()) FOR [ModifyDate];


GO
PRINT N'正在建立 預設條件約束 [dbo].[SystemSession] 上的未命名條件約束...';


GO
ALTER TABLE [dbo].[SystemSession]
    ADD DEFAULT (getdate()) FOR [Since];


GO
PRINT N'正在建立 外部索引鍵 [dbo].[FK_Member_MID]...';


GO
ALTER TABLE [dbo].[APP] WITH NOCHECK
    ADD CONSTRAINT [FK_Member_MID] FOREIGN KEY ([MID]) REFERENCES [dbo].[Member] ([MID]);


GO
PRINT N'正在建立 外部索引鍵 [dbo].[FK_Login_MID]...';


GO
ALTER TABLE [dbo].[Login] WITH NOCHECK
    ADD CONSTRAINT [FK_Login_MID] FOREIGN KEY ([MID]) REFERENCES [dbo].[Member] ([MID]);


GO
PRINT N'正在建立 外部索引鍵 [dbo].[FK_Login_SSID]...';


GO
ALTER TABLE [dbo].[Login] WITH NOCHECK
    ADD CONSTRAINT [FK_Login_SSID] FOREIGN KEY ([SSID]) REFERENCES [dbo].[SystemSession] ([SSID]);


GO
PRINT N'正在建立 外部索引鍵 [dbo].[FK_SystemSession_MID]...';


GO
ALTER TABLE [dbo].[SystemSession] WITH NOCHECK
    ADD CONSTRAINT [FK_SystemSession_MID] FOREIGN KEY ([MID]) REFERENCES [dbo].[Member] ([MID]);


GO
PRINT N'正在建立 外部索引鍵 [dbo].[FK_SystemSession_Type]...';


GO
ALTER TABLE [dbo].[SystemSession] WITH NOCHECK
    ADD CONSTRAINT [FK_SystemSession_Type] FOREIGN KEY ([Type]) REFERENCES [dbo].[Tag] ([TID]);


GO
PRINT N'正在建立 檢視表 [dbo].[vd_LoginSession]...';


GO
create view [dbo].[vd_LoginSession]
as
select
	M.MID,
	M.Account,
	M.Solt as UUID,
	M.EMail,
	M.NickName,
	S.SSID,
	S.Token,
	RefreshToken,
	DATEADD(ss, S.Expire, S.Since) as Expired,
	[Type]
from SystemSession S
	inner join Member M on S.MID = M.MID
where Expire is not null
and S.[Type] = 1
GO
PRINT N'正在建立 檢視表 [dbo].[vd_Member]...';


GO

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
GO
PRINT N'正在建立 程序 [dbo].[xp_createNewUser]...';


GO
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
GO
PRINT N'正在建立 程序 [dbo].[xp_loginWithPassword]...';


GO




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
GO
PRINT N'正在建立 程序 [dbo].[xp_loginWithToken]...';


GO


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
GO
PRINT N'正在建立 程序 [dbo].[xp_logout]...';


GO



CREATE   procedure [dbo].[xp_logout]
	@mid int,
	@token uniqueidentifier,
	@refreshtoken uniqueidentifier
as begin
	begin try
		declare @ssid int = (select SSID from vd_LoginSession where MID = @mid and Token = @token and RefreshToken = @refreshtoken)
		if @ssid is null
			raiserror('User had been logout', 18, 2)
		else
			update SystemSession
				set Expire = null
				where SSID = @ssid
	end try
	begin catch
		DECLARE @ErrorMessage As VARCHAR(1000) =ERROR_MESSAGE()
		raiserror(@ErrorMessage, 18, 1)
	end catch
end
GO
PRINT N'正在建立 程序 [dbo].[xp_MemberRenewPassword]...';


GO



CREATE   procedure [dbo].[xp_MemberRenewPassword]
	@mid int,
	@oldpassword varchar(100),
	@newpassword varchar(100)
as begin
	if exists(select 1 from Member where MID = @mid and [Password] = (select HASHBYTES('SHA2_256', @oldpassword + REPLACE(CONVERT(varchar(36), Solt), '-', '')))) begin
		declare @newpwd binary(32) = (select HASHBYTES('SHA2_256', @newpassword + REPLACE(CONVERT(varchar(36), Solt), '-', '')) from Member where MID = @mid)
		if exists(select 1 from Member where MID = @mid and [Password] = @newpwd)
			raiserror('New Password is not allow to be the same as the old one', 18, 2)
		else
			update Member
				set [Password] = @newpwd
				where MID = @mid
	end else raiserror('Permission denied', 18, 1)
end
GO
PRINT N'正在建立 程序 [dbo].[xp_MemberUpdate]...';


GO


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
GO
PRINT N'正在建立 程序 [dbo].[xp_refreshToken]...';


GO
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
GO
-- 用於更新含有部署交易記錄之目標伺服器的重構步驟

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a1634d87-6244-4e97-b416-73121181890c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a1634d87-6244-4e97-b416-73121181890c')

GO

GO
PRINT N'正在針對新建立的條件約束檢查現有資料';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[APP] WITH CHECK CHECK CONSTRAINT [FK_Member_MID];

ALTER TABLE [dbo].[Login] WITH CHECK CHECK CONSTRAINT [FK_Login_MID];

ALTER TABLE [dbo].[Login] WITH CHECK CHECK CONSTRAINT [FK_Login_SSID];

ALTER TABLE [dbo].[SystemSession] WITH CHECK CHECK CONSTRAINT [FK_SystemSession_MID];

ALTER TABLE [dbo].[SystemSession] WITH CHECK CHECK CONSTRAINT [FK_SystemSession_Type];


GO
PRINT N'更新完成。';


GO

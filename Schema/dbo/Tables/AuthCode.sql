CREATE TABLE [dbo].[AuthCode] (
    [AID]               INT              NOT NULL,
    [SSID]              INT              NOT NULL,
    [AuthorizationCode] UNIQUEIDENTIFIER NULL,
    [Since]             DATETIME         DEFAULT (getdate()) NULL,
    [Expire]            INT              DEFAULT ((300)) NULL,
    CONSTRAINT [PK_AuthCode] PRIMARY KEY CLUSTERED ([AID] ASC, [SSID] DESC),
    CONSTRAINT [FK_AuthCode_AID] FOREIGN KEY ([AID]) REFERENCES [dbo].[APP] ([AID]),
    CONSTRAINT [FK_AuthCode_SSID] FOREIGN KEY ([SSID]) REFERENCES [dbo].[SystemSession] ([SSID])
);


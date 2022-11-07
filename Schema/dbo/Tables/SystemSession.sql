CREATE TABLE [dbo].[SystemSession] (
    [SSID]         INT              IDENTITY (1, 1) NOT NULL,
    [Token]        UNIQUEIDENTIFIER NOT NULL,
    [RefreshToken] UNIQUEIDENTIFIER NULL,
    [Since]        DATETIME         DEFAULT (getdate()) NULL,
    [Expire]       INT              NULL,
    [MID]          INT              NULL,
    [Type]         INT              NULL,
    CONSTRAINT [PK_SystemSession] PRIMARY KEY CLUSTERED ([SSID] ASC),
    CONSTRAINT [FK_SystemSession_MID] FOREIGN KEY ([MID]) REFERENCES [dbo].[Member] ([MID]),
    CONSTRAINT [FK_SystemSession_Type] FOREIGN KEY ([Type]) REFERENCES [dbo].[Tag] ([TID])
);






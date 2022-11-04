CREATE TABLE [dbo].[Member] (
    [MID]        INT              IDENTITY (1, 1) NOT NULL,
    [Account]    VARCHAR (100)    NOT NULL,
    [Password]   BINARY (32)      NOT NULL,
    [EMail]      VARCHAR (128)    NULL,
    [NickName]   NVARCHAR (64)    NULL,
    [Solt]       UNIQUEIDENTIFIER NULL,
    [Since]      DATETIME         DEFAULT (getdate()) NULL,
    [ModifyDate] DATETIME         DEFAULT (getdate()) NULL,
    [Verify]     BIT              NULL,
    CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED ([MID] ASC),
    CONSTRAINT [UQ_Member_Account] UNIQUE NONCLUSTERED ([Account] ASC),
    CONSTRAINT [UQ_Member_EMail] UNIQUE NONCLUSTERED ([EMail] ASC)
);


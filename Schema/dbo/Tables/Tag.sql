CREATE TABLE [dbo].[Tag] (
    [TID]         INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (64)  NULL,
    [Description] NVARCHAR (128) NULL,
    CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED ([TID] ASC)
);


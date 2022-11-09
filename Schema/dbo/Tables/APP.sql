CREATE TABLE [dbo].[APP] (
    [AID]         INT              IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100)   NULL,
    [Description] VARCHAR (256)    NULL,
    [URL]         VARCHAR (1024)   NULL,
    [RedirectURL] VARCHAR (1024)   NULL,
    [MID]         INT              NULL,
    [APIKEY]      UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_APP] PRIMARY KEY CLUSTERED ([AID] ASC),
    CONSTRAINT [FK_Member_MID] FOREIGN KEY ([MID]) REFERENCES [dbo].[Member] ([MID])
);






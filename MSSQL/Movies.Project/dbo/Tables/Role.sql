CREATE TABLE [dbo].[Role] (
    [RoleID]  INT            IDENTITY (1, 1) NOT NULL,
    [Role]    NVARCHAR (255) NULL,
    [FilmID]  INT            NULL,
    [ActorID] INT            NULL,
    PRIMARY KEY CLUSTERED ([RoleID] ASC),
    CONSTRAINT [FK_Role_Actor] FOREIGN KEY ([ActorID]) REFERENCES [dbo].[Actor] ([ActorID]),
    CONSTRAINT [FK_Role_Film] FOREIGN KEY ([FilmID]) REFERENCES [dbo].[Film] ([FilmID])
);


GO


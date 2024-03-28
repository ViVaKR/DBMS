CREATE TABLE [dbo].[Film]
(
    [FilmID] INT IDENTITY (1, 1) NOT NULL,
    [Title] NVARCHAR (255) NOT NULL,
    [ReleaseDate] DATETIME NULL,
    [DirectorID] INT NULL,
    [StudioID] INT NULL,
    [Review] NVARCHAR (MAX) NULL,
    [CountryID] INT NULL,
    [LanguageID] INT NULL,
    [GenreID] INT NULL,
    [RunTimeMinutes] SMALLINT NULL,
    [CertificateID] INT NULL,
    [BudgetDollars] BIGINT NULL,
    [BoxOfficeDollars] BIGINT NULL,
    [OscarNominations] TINYINT NULL,
    [OscarWins] TINYINT NULL,
    PRIMARY KEY CLUSTERED ([FilmID] ASC),
    CONSTRAINT [FK_Film_Certificate] FOREIGN KEY ([CertificateID]) REFERENCES [dbo].[Certificate] ([CertificateID]),
    CONSTRAINT [FK_Film_Country] FOREIGN KEY ([CountryID]) REFERENCES [dbo].[Country] ([CountryID]),
    CONSTRAINT [FK_Film_Director] FOREIGN KEY ([DirectorID]) REFERENCES [dbo].[Director] ([DirectorID]),
    CONSTRAINT [FK_Film_Genre] FOREIGN KEY ([GenreID]) REFERENCES [dbo].[Genre] ([GenreID]),
    CONSTRAINT [FK_Film_Language] FOREIGN KEY ([LanguageID]) REFERENCES [dbo].[Language] ([LanguageID]),
    CONSTRAINT [FK_Film_Studio] FOREIGN KEY ([StudioID]) REFERENCES [dbo].[Studio] ([StudioID])
);


GO


CREATE TABLE [dbo].[Genre]
(
    [GenreID] INT IDENTITY (1, 1) NOT NULL,
    [Genre] NVARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([GenreID] ASC)
);

GO

CREATE TABLE [dbo].[Director]
(
    [DirectorID] INT IDENTITY (1, 1) NOT NULL,
    [FirstName] NVARCHAR (100) NOT NULL,
    [FamilyName] NVARCHAR (100) NULL,
    [FullName]   AS             ([FirstName]+isnull(' '+[FamilyName],'')),
    [DoB] DATETIME NULL,
    [DoD] DATETIME NULL,
    [Gender] NVARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([DirectorID] ASC)
);


GO


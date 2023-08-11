--? [ spFilmCriteria ] ?--

--* Parameter
-- (1) EXEC spFilmCriteria 170, 180

--* Named Parameter
-- (2) EXEC spFilmCriteria @MinLength = 170, @MaxLength = 180

--* Create Text Parameter
-- (3) EXEC spFilmCriteria @MinLength = 100, @MaxLength = 250, @Title = 'star'

--* Optional Parameter
EXEC spFilmCriteria  @MaxLength = 250, @Title = 'die'

--* Null Parameter
EXEC spFilmCriteria @Title = 'star'
EXEC spFilmCriteria @Title = 'star', @MinLength = 120

--* GENERATE_SERIES

SELECT value 
FROM generate_series(1, 10);

SELECT
    [value]
FROM
    generate_series(0.0, 1.0, 0.1)

SELECT
    [value]
FROM
    generate_series(100, 10, -10)

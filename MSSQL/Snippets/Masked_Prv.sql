--*  권한없는 사용자에게 주요정보 가리기 (마스킹)
--* Refs : `https://blog.sqlauthority.com/2023/08/02/sql-server-introduction-to-dynamic-data-masking/`

USE PlayGround
GO

-- Create a table to store customer data with masked columns
CREATE TABLE CustomerData
(
    ID int IDENTITY PRIMARY KEY,
    FullName nvarchar(100) MASKED WITH (FUNCTION = 'default()') NULL,
    Email nvarchar(100) MASKED WITH (FUNCTION = 'email()') NULL,
    CreditCard varchar(50) MASKED WITH (FUNCTION = 'partial(0,"XXXX-XXXX-XXXX-",4)') NULL,
    BirthDate date MASKED WITH (FUNCTION = 'default()') NULL
);

-- Insert sample data
INSERT INTO CustomerData
    (FullName, Email, CreditCard, BirthDate)
VALUES
    ('John Doe', 'johndoe@example.com', '1234-5678-9012-3456', '1980-01-01');

SELECT
    *
FROM
    CustomerData

-- Create a non-privileged user
CREATE USER NonPrivilegedUser WITHOUT LOGIN;
-- Grant SELECT permission
GRANT SELECT ON CustomerData TO NonPrivilegedUser;
-- Impersonate the user to show initial masked view
EXECUTE AS USER = 'NonPrivilegedUser';
-- Query the data
SELECT *
FROM CustomerData;
-- Revert impersonation
REVERT;
-- Grant UNMASK permission
GRANT UNMASK TO NonPrivilegedUser;
-- Impersonate again to show unmasked view
EXECUTE AS USER = 'NonPrivilegedUser';
-- Query the data
SELECT *
FROM CustomerData;
-- Revert impersonation
REVERT;
-- Remove the user
DROP USER NonPrivilegedUser;
-- Drop the table
DROP TABLE CustomerData;

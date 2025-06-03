-- Create Table
IF NOT EXISTS (
    SELECT *
    FROM sysobjects
    WHERE
        name = 'users'
        and xtype = 'U'
)
CREATE TABLE users (
    id INT IDENTITY (1, 1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT GETDATE ()
);
GO

-- Create (Insert) Operation
INSERT INTO
    users (name, email)
VALUES (
        'John Doe',
        'john@example.com'
    );
GO

-- Read Operations
-- Read all users
SELECT * FROM users;
GO

-- Read specific user
SELECT * FROM users WHERE id = 1;
GO

-- Update Operation
UPDATE users
SET
    name = 'John Updated',
    email = 'john.updated@example.com'
WHERE
    id = 1;
GO

-- Verify Update
SELECT * FROM users;
GO

-- Delete Operation
DELETE FROM users WHERE id = 1;
GO

-- Verify Delete
SELECT * FROM users;
GO

-- Complex Queries
-- Insert multiple users for demonstration
INSERT INTO
    users (name, email)
VALUES (
        'Alice Johnson',
        'alice@example.com'
    ),
    (
        'Bob Smith',
        'bob@example.com'
    ),
    (
        'Carol White',
        'carol@example.com'
    );
GO

-- Show all users after multiple inserts
SELECT * FROM users;
GO

-- Filter specific user
SELECT * FROM users WHERE name LIKE 'Alice%';
GO

-- Update filtered user
UPDATE users
SET
    name = 'Alice Updated',
    email = 'alice.updated@example.com'
WHERE
    name LIKE 'Alice%';
GO

-- Show users after update
SELECT * FROM users;
GO

-- Delete filtered user
DELETE FROM users WHERE name LIKE 'Bob%';
GO

-- Show final state
SELECT * FROM users;
GO
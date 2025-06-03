-- Create Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create (Insert) Operation
INSERT INTO
    users (name, email)
VALUES (
        'John Doe',
        'john@example.com'
    ) RETURNING *;

-- Read Operations
-- Read all users
SELECT * FROM users;

-- Read specific user
SELECT * FROM users WHERE id = 1;

-- Update Operation
UPDATE users
SET
    name = 'John Updated',
    email = 'john.updated@example.com'
WHERE
    id = 1 RETURNING *;

-- Verify Update
SELECT * FROM users;

-- Delete Operation
DELETE FROM users WHERE id = 1;

-- Verify Delete
SELECT * FROM users;

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
    ) RETURNING *;

-- Show all users after multiple inserts
SELECT * FROM users;

-- Filter specific user
SELECT * FROM users WHERE name LIKE 'Alice%';

-- Update filtered user
UPDATE users
SET
    name = 'Alice Updated',
    email = 'alice.updated@example.com'
WHERE
    name LIKE 'Alice%' RETURNING *;

-- Show users after update
SELECT * FROM users;

-- Delete filtered user
DELETE FROM users WHERE name LIKE 'Bob%';

-- Show final state
SELECT * FROM users;
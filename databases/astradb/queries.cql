-- Note: In AstraDB, keyspace is created during database creation
USE default_keyspace;

-- Create Table
CREATE TABLE IF NOT EXISTS default_keyspace.users (
    id timeuuid PRIMARY KEY,
    name text,
    email text,
    created_at timestamp
);

-- Create Materialized View for email queries
CREATE MATERIALIZED VIEW IF NOT EXISTS default_keyspace.users_by_email AS
SELECT id, name, email, created_at
FROM default_keyspace.users
WHERE email IS NOT NULL AND id IS NOT NULL
PRIMARY KEY (email, id);

-- Create (Insert) Operation
INSERT INTO default_keyspace.users (id, name, email, created_at)
VALUES (now(), 'John Doe', 'john@example.com', toTimestamp(now()));

-- Read Operations
-- Read all users
SELECT * FROM default_keyspace.users;

-- Read specific user by email
SELECT * FROM default_keyspace.users_by_email WHERE email = 'john@example.com';

-- Update Operation
UPDATE default_keyspace.users 
SET name = 'John Updated',
    email = 'john.updated@example.com'
WHERE id = <uuid-from-select>;

-- Verify Update
SELECT * FROM default_keyspace.users;

-- Delete Operation
DELETE FROM default_keyspace.users WHERE id = <uuid-from-select>;

-- Verify Delete
SELECT * FROM default_keyspace.users;
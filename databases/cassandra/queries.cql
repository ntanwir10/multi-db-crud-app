-- Create Keyspace
CREATE KEYSPACE IF NOT EXISTS demo
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE demo;

-- Create Table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    name text,
    email text,
    created_at timestamp
);

-- Create Index for email searches
CREATE INDEX IF NOT EXISTS ON users (email);
CREATE INDEX IF NOT EXISTS ON users (name);

-- Create (Insert) Operation
INSERT INTO users (id, name, email, created_at)
VALUES (uuid(), 'John Doe', 'john@example.com', toTimestamp(now()));

-- Read Operations
-- Read all users
SELECT * FROM users;

-- Read specific user (by email since we don't know UUID)
SELECT * FROM users WHERE email = 'john@example.com';

-- Update Operation
UPDATE users 
SET name = 'John Updated',
    email = 'john.updated@example.com'
WHERE id = 'uuid-value';

-- Verify Update
SELECT * FROM users;

-- Delete Operation
DELETE FROM users WHERE id = 'uuid-value';

-- Verify Delete
SELECT * FROM users;

-- Insert multiple users for demonstration
BEGIN BATCH
    INSERT INTO users (id, name, email, created_at)
    VALUES (uuid(), 'Alice Johnson', 'alice@example.com', toTimestamp(now()));
    
    INSERT INTO users (id, name, email, created_at)
    VALUES (uuid(), 'Bob Smith', 'bob@example.com', toTimestamp(now()));
    
    INSERT INTO users (id, name, email, created_at)
    VALUES (uuid(), 'Carol White', 'carol@example.com', toTimestamp(now()));
APPLY BATCH;

-- Show all users after multiple inserts
SELECT * FROM users;

-- Filter specific user
SELECT * FROM users WHERE name = 'Alice Johnson' ALLOW FILTERING;

-- Update filtered user
UPDATE users
SET name = 'Alice Updated',
    email = 'alice.updated@example.com'
WHERE email = 'alice@example.com';

-- Show users after update
SELECT * FROM users;

-- Delete filtered user
DELETE FROM users WHERE email = 'bob@example.com';

-- Show final state
SELECT * FROM users; 
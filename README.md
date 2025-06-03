# Multi-Database CRUD Operations Assignment

This academic project demonstrates CRUD (Create, Read, Update, Delete) operations across six different database systems, showcasing the unique characteristics and query patterns of each database type.

## Assignment Overview
This academic project explores database operations across:
- Relational Database (Microsoft SQL Server)
- Key-Value Store (Redis)
- Document Store (MongoDB)
- Wide-Column Store (Cassandra)
- Serverless SQL (Neon - PostgreSQL)
- Distributed NoSQL (AstraDB)

## Docker Setup

First, create a Docker network for all our databases:
```bash
docker network create db-network
```

### Database Network Configuration

All database containers are connected to the `db-network`, allowing them to communicate with each other using container names as hostnames. This is particularly useful for applications that need to interact with multiple databases.

To connect an existing container to the network:
```bash
docker network connect db-network <container-name>
```

#### Internal Network Hostnames

When containers need to communicate with each other within the `db-network`, use these hostnames and ports:

| Database | Internal Hostname | Port |
| -------- | ----------------- | ---- |
| MongoDB  | mongodb           | 27017 |
| Cassandra | cassandra        | 9042 |
| Redis    | redis             | 6379 |
| MSSQL    | mssql             | 1433 |

For example, if your application container is also connected to the `db-network`, it can connect to MongoDB using `mongodb:27017` as the connection string.

### 1. Microsoft SQL Server (MSSQL)
```bash
# Pull the image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# Create and run container
docker run -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=YourStrong@Passw0rd" \
  -p 1433:1433 \
  --name mssql \
  --network db-network \
  -d mcr.microsoft.com/mssql/server:2022-latest
```
- Connect using: SQL Server Management Studio or Azure Data Studio
- Connection string: `Server=localhost,1433;Database=master;User Id=sa;Password=YourStrong@Passw0rd`

#### MSSQL CRUD Operations
1. Create Table:
```sql
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at DATETIME DEFAULT GETDATE()
);
```

2. Create (Insert):
```sql
INSERT INTO users (name, email) 
VALUES ('John Doe', 'john@example.com');
```

3. Read (Select):
```sql
-- Read all users
SELECT * FROM users;

-- Read specific user
SELECT * FROM users WHERE id = 1;
```

4. Update:
```sql
UPDATE users 
SET name = 'John Updated', email = 'john.updated@example.com'
WHERE id = 1;
```

5. Delete:
```sql
DELETE FROM users WHERE id = 1;
```

### 2. Redis
```bash
# Pull the image
docker pull redis:latest

# Create and run container
docker run --name redis \
  -p 6379:6379 \
  --network db-network \
  -d redis:latest

# To connect using redis-cli within the container
docker exec -it redis redis-cli
```
- Connect using: redis-cli or RedisInsight
- Connection: `localhost:6379`

#### Redis CRUD Operations
1. Create (Set):
```redis
# Store user as hash
HSET user:1 name "John Doe" email "john@example.com" created_at "2024-01-01"

# Store in a sorted set
ZADD users 1 user:1
```

2. Read:
```redis
# Get all fields of user
HGETALL user:1

# Get specific field
HGET user:1 name

# Get all users
ZRANGE users 0 -1
```

3. Update:
```redis
HSET user:1 name "John Updated" email "john.updated@example.com"
```

4. Delete:
```redis
# Delete user hash
DEL user:1

# Remove from sorted set
ZREM users user:1
```

### 3. MongoDB
```bash
# Pull the image
docker pull mongodb/mongodb-community-server:latest

# Create and run container
docker run --name mongodb \
  -p 27017:27017 \
  --network db-network \
  -d mongodb/mongodb-community-server:latest

# To connect using mongosh within the container
docker exec -it mongodb mongosh
```
- Connect using: MongoDB Compass or mongosh
- Connection string: `mongodb://localhost:27017`

#### MongoDB CRUD Operations
1. Create:
```javascript
// Create collection
db.createCollection("users")

// Insert document
db.users.insertOne({
  name: "John Doe",
  email: "john@example.com",
  created_at: new Date()
})
```

2. Read:
```javascript
// Find all users
db.users.find()

// Find specific user
db.users.findOne({ name: "John Doe" })
```

3. Update:
```javascript
db.users.updateOne(
  { name: "John Doe" },
  { 
    $set: { 
      name: "John Updated",
      email: "john.updated@example.com"
    }
  }
)
```

4. Delete:
```javascript
// Delete one document
db.users.deleteOne({ name: "John Updated" })

// Delete all documents
db.users.deleteMany({})
```

### 4. Cassandra
```bash
# Pull the image
docker pull cassandra:latest

# Create and run container
docker run --name cassandra \
  -p 9042:9042 \
  --network db-network \
  -d cassandra:latest

# Wait for Cassandra to fully start (about 30-60 seconds)
# To connect using cqlsh within the container
docker exec -it cassandra cqlsh
```
- Connect using: cqlsh
- Connection: `localhost:9042`

#### Cassandra CRUD Operations
1. Create:
```sql
-- Create keyspace
CREATE KEYSPACE IF NOT EXISTS demo 
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

USE demo;

-- Create table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name text,
    email text,
    created_at timestamp
);

-- Insert data
INSERT INTO users (id, name, email, created_at)
VALUES (uuid(), 'John Doe', 'john@example.com', toTimestamp(now()));
```

2. Read:
```sql
-- Read all users
SELECT * FROM users;

-- Read with filter (requires secondary index)
CREATE INDEX ON users(name);
SELECT * FROM users WHERE name = 'John Doe';
```

3. Update:
```sql
UPDATE users 
SET name = 'John Updated', email = 'john.updated@example.com'
WHERE id = <uuid-from-select>;
```

4. Delete:
```sql
DELETE FROM users WHERE id = <uuid-from-select>;
```

### 5. Neon (PostgreSQL)
1. Sign up at https://neon.tech
2. Create a new project
3. Get connection string from dashboard
- Connect using: psql or any PostgreSQL client

#### PostgreSQL CRUD Operations
1. Create:
```sql
-- Create table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data
INSERT INTO users (name, email)
VALUES ('John Doe', 'john@example.com');
```

2. Read:
```sql
-- Read all users
SELECT * FROM users;

-- Read specific user
SELECT * FROM users WHERE id = 1;
```

3. Update:
```sql
UPDATE users 
SET name = 'John Updated', email = 'john.updated@example.com'
WHERE id = 1;
```

4. Delete:
```sql
DELETE FROM users WHERE id = 1;
```

### 6. AstraDB
1. Sign up at https://astra.datastax.com
2. Create a new database
3. Download secure connect bundle

#### AstraDB CRUD Operations
1. Create:
```sql
-- Create table (similar to Cassandra)
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name text,
    email text,
    created_at timestamp
);

-- Insert data
INSERT INTO users (id, name, email, created_at)
VALUES (uuid(), 'John Doe', 'john@example.com', toTimestamp(now()));
```

2. Read:
```sql
-- Read all users
SELECT * FROM users;

-- Read with filter (requires secondary index)
CREATE INDEX ON users(name);
SELECT * FROM users WHERE name = 'John Doe';
```

3. Update:
```sql
UPDATE users 
SET name = 'John Updated', email = 'john.updated@example.com'
WHERE id = <uuid-from-select>;
```

4. Delete:
```sql
DELETE FROM users WHERE id = <uuid-from-select>;
```

## Screenshots
Store your screenshots of CRUD operations in the `screenshots` directory with the following structure:
```
screenshots/
├── mssql/
│   ├── create.png
│   ├── read.png
│   ├── update.png
│   └── delete.png
├── redis/
│   └── ...
├── mongodb/
│   └── ...
├── cassandra/
│   └── ...
├── neon/
│   └── ...
└── astradb/
    └── ...
```

## Tips for Taking Screenshots
1. For each database operation:
   - Take a screenshot of the command/query
   - Take a screenshot of the result/output
   - Name files descriptively (e.g., `mongodb_insert_result.png`)
2. Include error messages if they occur
3. Show the before and after states for update operations
4. For UI tools (like MongoDB Compass):
   - Capture the full window showing the query and results
   - Include any relevant configuration panels

### Docker Management Commands
```bash
# Start all containers
docker start mssql redis mongodb cassandra

# Stop all containers
docker stop mssql redis mongodb cassandra

# Remove all containers
docker rm mssql redis mongodb cassandra

# View logs
docker logs <container-name>

# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# View container details
docker inspect <container-name>
```
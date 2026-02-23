# Soccer Management System

## Summary

The focus of our project will be a sports management system, particularly for Soccer (Football) which can track various entities and attributes throughout the league. We built a website that enables users to perform actions such as editing or deleting athletes, determining game statistics, or simply viewing the standings & past scores.

We showed team specific statistics such as coach experience, championship contender teams, standings for the league, and statistics for recent games. We implemented search options such as finding games by venue, determining sponsors filtered by their attributes and showing tables from the database given any number of attributes. 

## Examples
![Home](examples/home.png)
![Athletes](examples/athletes.png)
![Athletes Add](examples/athletes-add.png)
![Athletes Delete](examples/athletes-delete.png)
![Athletes Edit](examples/athletes-edit.png)
![Athletes View](examples/athletes-view.png)
![Locator](examples/locator.png)
![Sponsors](examples/sponsors.png)
![Advanced](examples/advanced.png)

## How to Run
This project uses [PostgreSQL](https://www.npmjs.com/package/pg), [Express.js](https://www.npmjs.com/package/express), [React.js](https://www.npmjs.com/package/react), and [Node.js](https://nodejs.org/en).


Clone the project and create a copy of the `template.env` file in the root, renaming it to `.env`. For how to fill it out, read below.

### Setting up Postgres

After Postgres is installed, enter a `psql` instance in any terminal using:

```powershell
psql -U postgres
```

Note that the default username is _postgres_, though it may vary between machines. After entering your password (set upon installation), enter the following:

```sql
CREATE DATABASE football_db
CREATE USER admin WITH PASSWORD 'newpassword01';
GRANT ALL PRIVILEGES ON DATABASE football_db TO admin;
```

Note that these correlate to the `DB_USER`, `DB_PASSWORD`, and `DB_NAME` in the `.env`. So with these arguments, a sample `.env` may look like:

```ini
PORT=65535

DB_USER=admin
DB_PASSWORD="newpassword01"

DB_HOST=localhost
DB_PORT=5432
DB_NAME=football_db
```

Once the DB is set up, we can run `init.sql` to populate the database with athletes, teams, etc. This will initialize the necessary tables needed for the application. From any terminal, enter:

```powershell
psql -U postgres -d football_db -f "C:\...etc...\server\sql-scripts\init.sql"
```

After, enter a Postgres instance again, and enter the following (may be optional but can lead to permission issues otherwise):

```sql
psql -U postgres -d football_db

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin;
```


### Running Backend + Frontend


Now run this in one terminal

```powershell
cd server
npm install
node server.js
```

and this in another

```powershell
cd client
npm install
npm start
```

*Special thanks to teammates [Patrick Hong](https://github.com/patrickhong21) and [Fei Sam](https://github.com/U7F7).*

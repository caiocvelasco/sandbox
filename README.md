# Sandbox (PostgreSQL Database in a Docker Container)

## Table of Contents

- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Build and Run](#build-and-run)
  - [Connecting with a Database Client (e.g., DBeaver, Power BI, Tableau)](#connecting-with-a-database-client-eg-dbeaver-power-bi-tableau)
- [Services](#services)
- [Notes](#notes)

---

## Project Structure

- **name_of_your_project_repo (project-root)/**
  - **pgdata/** (PostgreSQL data directory — persisted data)
  - **.env** (Environment variables for PostgreSQL configuration)
  - **.gitignore**
  - **docker-compose.yml**
  - **README.md**

---

## Setup Instructions

### Prerequisites

Make sure you have the following installed on your local development environment:

- [VSCode](https://code.visualstudio.com/): Lightweight but powerful source code editor.
- [Docker](https://www.docker.com/get-started): Platform for building, sharing, and running containers.

Also include a `.gitignore` file with:  
- pgdata/ (# Ignore PostgreSQL data directory)
- .env (# Ignore environment variable files)

**Environment Variables**

Defined in the `.env` file:

```env
POSTGRES_USER=caio
POSTGRES_PASSWORD=secret
POSTGRES_DB=sandbox_db
POSTGRES_PORT=5432
```

---

## Build and Run

1. **Clone the repository:**

   ```bash
   git clone https://github.com/caiocvelasco/your_repo.git
   cd your_repo
   ```

2. **Start the PostgreSQL service:**

   Run the following command from the root of the project folder (`Sandbox`):

   ```bash
   docker compose up -d
   ```

   This will:
   - Pull the official PostgreSQL 16 image (first time only)
   - Start a container named **sandbox_postgres**
   - Create a persistent data folder (`./pgdata`) on your host machine

3. **Verify that the container is running:**

   ```bash
   docker ps
   ```

   Example output:

   ```
   CONTAINER ID   IMAGE         COMMAND                  PORTS                    NAMES
   abc12345       postgres:16   "docker-entrypoint.s…"   0.0.0.0:5432->5432/tcp   sandbox_postgres
   ```

4. **Test that PostgreSQL is working:**

  Run a simple version check directly from the container:

   ```bash
   docker exec sandbox_postgres psql -U caio -d sandbox_db -c "SELECT version();"
   ```

   Expected output (may vary slightly):

   ```
   PostgreSQL 16.x (Debian 16.x-x.pgdgXX+1)
   ```

5. **Stop the container:**

   ```bash
   docker compose down
   ```

   **Your data will persist** inside the `pgdata/` folder.  
   To remove both the container **and** its data:

   ```bash
   docker compose down -v
   ```

6. **Connecting with a Database Client (e.g., DBeaver, Power BI, Tableau)**

To connect to a database using DBaever, use the following connection details:

| DBeaver Field | Value        | Source (.env variable)        |
| ------------- | ------------ | ----------------------------- |
| **Host**      | `localhost`  | — (Docker exposes it locally) |
| **Port**      | `5432`       | `POSTGRES_PORT`               |
| **Database**  | `sandbox_db` | `POSTGRES_DB`                 |
| **Username**  | `caio`       | `POSTGRES_USER`               |
| **Password**  | `...`        | `POSTGRES_PASSWORD`           |

Go to "Database" > "New Database Connection" in DBeaver and select "PostgreSQL" as the database type. Fill in the connection details as shown above.

> 💡 Don't forget that you need to do `docker compose up -d` to have the PostgreSQL container running before trying to connect!

---

## Services

### **Postgres**

- Provides a local **PostgreSQL 16** database instance.
- Data is persisted in the `pgdata/` folder (mounted from your host).
- Exposes port **5432** on your local machine.

| Context | Hostname | Port | Description |
|----------|-----------|------|--------------|
| **Local (e.g., DBeaver, PowerBI, Tableau)** | `localhost` | `5432` | Connect using the credentials in `.env` |
| **Inside other Docker containers** | `postgres` | `5432` | Use the service name as hostname (`postgres`) |

---

## Important Notes

- The database data **persists between restarts** (stored in `./pgdata`).
- Use `docker compose down -v` only if you want to reset the database completely.

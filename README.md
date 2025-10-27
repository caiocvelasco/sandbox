# Sandbox (PostgreSQL Database in a Docker Container + Python in Virtual Environment)

## Table of Contents

- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Build and Run PostgreSQL in Docker](#build-and-run-postgresql-in-docker)
  - [Build and Run Python and Jupyter Notebook in a Virtual Environment](#build-and-run-python-and-jupyter-notebook-in-a-virtual-environment)
- [Notes](#notes)

---

## Project Structure

- **name_of_your_project_repo (project-root)/**
  - .venv/ (Python virtual environment))
  - **pgdata/** (PostgreSQL data directory - persisted data - this will be created automatically after your first docker compose up command)
  - **.gitignore**
  - **docker-compose.yml**
  - **README.md**

---

## Setup Instructions

### Prerequisites

Make sure you have the following installed on your local computer:

- [Docker](https://www.docker.com/get-started): Platform for building, sharing, and running containers.
- **Ignoring stuff**: Create a `.gitignore` file in the project root (sandbox/.gitignore) with:  
  - pgdata/ (# Ignore PostgreSQL data directory)
* [.venv - Virtual Environment](https://docs.python.org/3/library/venv.html)
  * cd your_repo_folder:
    * cd "C:\your_repo_folder"
  * python -m venv .venv           (This will create a virtual environment for the repo folder)
  * `source .venv/Scripts/activate`  (This will activate your virtual environment)
  * Install everything you need for your project from the `requirements.txt` file:
    * make sure to update pip, this is important to avoid conflicts: `python.exe -m pip install --upgrade pip`
    * `pip install --no-cache-dir -r requirements.txt`  (This will install things inside your virtual environment)
    * Check: `pip list`

---

## Build and Run PostgreSQL in Docker

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your_repo/name_your_repo.git
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

  Run a simple version check directly from the container (change `your_name` and `sandbox_db` if you used different values):

   ```bash
   docker exec sandbox_postgres psql -U your_name -d sandbox_db -c "SELECT version();"
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

| DBeaver Field | Value        |
| ------------- | ------------ |
| **Host**      | `localhost`  |
| **Port**      | `5432`       |
| **Database**  | `sandbox_db` |
| **Username**  | `your_name`       |
| **Password**  | `your_password`        |

Go to "Database" > "New Database Connection" in DBeaver and select "PostgreSQL" as the database type. Fill in the connection details as shown above.

> 💡 Don't forget that you need to do `docker compose up -d` to have the PostgreSQL container running before trying to connect!

---

## Build and Run Python and Jupyter Notebook in a Virtual Environment

1. **Activate your virtual environment:**

   ```bash
   source .venv/Scripts/activate
   ```

2. **Install required packages:**
   ```bash
   pip install -r requirements.txt
   ```


---

## Notes

A few notes on Docker Compose services defined in the `docker-compose.yml` file:

### General Notes

- The database data **persists between restarts** (stored in `./pgdata`).
- Use `docker compose down -v` only if you want to reset the database completely.

### Postgres

- Provides a local **PostgreSQL 16** database instance.
- Data is persisted in the `pgdata/` folder (mounted from your host).
- Exposes port **5432** on your local machine.

| Context | Hostname | Port | Description |
|----------|-----------|------|--------------|
| **Local (e.g., DBeaver, PowerBI, Tableau)** | `localhost` | `5432` | Connect using the credentials in `.env` |
| **Inside other Docker containers** | `postgres` | `5432` | Use the service name as hostname (`postgres`) |



---


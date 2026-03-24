# DentFisto – Dentist Lab Management System

A university project for managing a dental lab: appointment booking, appointment management, and worker administration.

## Tech Stack

| Layer     | Technology                |
|-----------|---------------------------|
| Backend   | Java Servlets (Jakarta EE 10), JSP + JSTL |
| Database  | MySQL 8.0                 |
| Build     | Maven                     |
| Server    | Apache Tomcat 10.1        |
| Infra     | Docker & Docker Compose   |

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/)
- Git

That's it — Docker handles Java, Maven, Tomcat, and MySQL for you.

## Quick Start

```bash
# Clone the repo
git clone <repo-url>
cd dentfisto

# Start everything (first run takes a few minutes to download images)
docker-compose up --build

# App is ready at:        http://localhost:8080
# phpMyAdmin is at:       http://localhost:8081  (login: root / root)
```

### Seed Accounts

| Username    | Password      | Role      |
|-------------|---------------|-----------|
| admin       | password123   | ADMIN     |
| dentist1    | password123   | DENTIST   |
| assistant1  | password123   | ASSISTANT |

### Stopping

```bash
docker-compose down          # Stop containers
docker-compose down -v       # Stop + delete database data
```

## Project Structure

```
dentfisto/
├── pom.xml                          # Maven config
├── Dockerfile                       # Multi-stage build
├── docker-compose.yml               # MySQL + Tomcat + phpMyAdmin
├── sql/
│   └── init.sql                     # DB schema & seed data
└── src/main/
    ├── java/com/dentfisto/
    │   ├── model/                   # POJOs (User, Appointment)
    │   ├── dao/                     # Database access (JDBC)
    │   ├── servlet/                 # HTTP Servlets (APIs)
    │   └── filter/                  # Auth filter
    └── webapp/
        ├── WEB-INF/web.xml
        ├── css/style.css
        ├── js/
        ├── login-assistant.jsp
        ├── login-dentist.jsp
        ├── login-admin.jsp
        ├── assistant/index.jsp      # Assistant dashboard
        ├── dentist/index.jsp        # Dentist dashboard
        └── admin/index.jsp          # Admin dashboard
```

## Git Workflow

We use a single repo with **team-based branches**:

| Branch      | Purpose                           |
|-------------|-----------------------------------|
| `main`      | Stable, deployable code           |
| `dev`       | Integration – all PRs target here |
| `team/db`   | Database team                     |
| `team/api`  | Backend (Servlet) team            |
| `team/ui`   | Frontend (JSP/CSS) team           |

### How to work

```bash
# 1. Always start from the latest dev
git checkout dev
git pull

# 2. Switch to your team branch
git checkout team/db        # or team/api, team/ui

# 3. Merge latest dev into your branch
git merge dev

# 4. Do your work, then commit
git add .
git commit -m "describe your change"

# 5. Push your branch
git push

# 6. Open a Pull Request on GitHub: team/db → dev
```

## Team Responsibilities

| Team       | Owns                           | Key files                            |
|------------|--------------------------------|--------------------------------------|
| Database   | Schema, SQL, DAO classes       | `sql/`, `dao/`, `model/`            |
| Backend    | Servlets, filters, business logic | `servlet/`, `filter/`             |
| Frontend   | JSP pages, CSS, JS             | `webapp/*.jsp`, `css/`, `js/`        |

# Data Plumbing Fundamentals — Part 1 (Northwind)

This is **Part One** of a small “data plumbing” series I’m building to learn how real data teams wire things together.

The idea is simple: pretend you’re a **small company** that’s just starting to get serious about reporting. You already have a database with operational data… now you need a clean, repeatable way to transform it and run it on a schedule, without someone manually clicking buttons every day.

The idea came from my experience at a data company where we had a PG setup, little money and almost 0 to no cloud infracture. We operated using a python script which was responsible for picking up the data from source, doing a bit of transformation and plugging it into PG, this left little room for the data analyst (myself) to explore further transformations without having to go back to the SW engineer. This architecture (on a VM ofcourse) would easily have made life 1000x better for the data team.

So this project simulates the *first steps* of that journey.

---

## What this project does (in plain English)

- Spins up a database with sample business data (Northwind-style).
- Builds a set of transformations that turn raw tables into cleaner “ready for analytics” tables.
- Runs those transformations automatically using a scheduler, the way a small company would.

Think of it like building a tiny factory:
- **Database** = the warehouse (where stuff lives)
- **Transformations** = the assembly line (clean & reshape data)
- **Scheduler** = the factory manager (runs the assembly line on time)

---

## What’s inside

- `postgres/`  
  The database setup + starter data.

- `dbt/`  
  The transformation project (staging models, tests, and outputs).

- `airflow/`  
  The scheduler/orchestrator that triggers the transformation run.

- `docker-compose.yml`  
  The “one switch” that starts the whole environment.

---

## Why I built it

I wanted something that teaches the fundamentals without needing cloud infrastructure first, it's helped me understand basic plumbing and how endineers spend > 70% of their time debugging. 

I guess we could see this as “learn to drive in an empty parking lot” version of data engineering:
- containers
- connections
- repeatable runs
- simple orchestration
- basic testing/quality checks

I plan on moving to a more “company-style” setup (cloud, secrets managers, ephemeral compute, etc.) becomes way less scary.

---

## How to run it (quick start)

1) Start the services:
```bash
docker compose up -d

2) Open the scheduler UI:
Airflow web UI: http://localhost:8080

3) Trigger the pipeline:
Run the DAG that executes the transformation steps.

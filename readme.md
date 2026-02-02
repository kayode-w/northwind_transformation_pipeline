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

## Transformation layer (the part that actually makes reporting possible)

This project uses a simple two-layer transformation approach:

1) Staging schema (analytics_staging)

  This is the “clean-up crew”.
  
  - Basic renaming (turning weird column names into readable ones)
  - Standardized types (dates as dates, ids as ids)
  - Light reshaping so downstream models don’t have to fight the raw structure

  The goal is not “business logic” here — it’s consistency.

2) Business logic / reporting schema (analytics)

  This is the “reporting-ready zone”.

  This layer answers questions the business cares about:

  - What’s our revenue and order totals by product?
  - Who are our customers, what do they spend, when did they first buy?
  - What does a clean fact table look like for BI tools?

  This is where I built the final fact models used for analytics.

## Final models 
  1) orders_facts

  This model prepares order-level reporting by combining orders, order positions, and product details.
  What it’s doing:

  - Starts from orders and joins order positions to calculate totals.
  - Builds metrics like:

    - total_orders (units / quantity)
    - order_total (value)
    - total_shipping_cost

  - Joins to products (via articles) to bring in product metadata like category and gender.

  ### Why this matters for reporting:
  This becomes the “single place” to power dashboards like:

    - Sales by product/category
    - Order trends over time
    - Customer buying behaviour linked to product attributes

  2) customers_fact

  This model turns raw customer rows into something a dashboard can actually use.
  What it’s doing:

  Builds a clean customer profile:
  - full name
  - age (derived)
  - address (assembled from multiple fields)
  - registration date

  Joins aggregated order behaviour onto each customer:
  - first_order_date
  - last_order_date
  - total_orders
  - total_spend

### Why this matters for reporting:
This gives an easy “customer 360” table. It powers things like:

  - customer segmentation
  - repeat purchase metrics
  - lifetime spend / order counts
  - retention-style analysis (even in a basic form)

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

# Zomato Bangalore Restaurants — Data Analysis & Power BI Dashboard

An end-to-end data analysis project on Zomato's Bangalore restaurant listings, taking raw scraped data through cleaning, a SQL Server database, and an interactive Power BI dashboard with AI-assisted analysis.

## Live Dashboards

**[View the interactive dashboard](https://anushar-214.github.io/Zomata-Data-analysis/zomato-analysis-dashboard.html)** — a browser-based version of the analysis (`zomato-analysis-dashboard.html`), viewable without Power BI Desktop.

**[Open the live Power BI report](https://app.powerbi.com/groups/a8b4bc89-bce5-4add-a0cb-f3674a2355e8/reports/3ff9037e-f7d1-48b2-ba69-019d083ac03e?ctid=d3de91d7-5bb6-4ce1-a775-489e8e7143a8&pbi_source=linkShare&bookmarkGuid=450cd111-44b0-49e9-91c6-735f43fa236d)** — the full multi-page report published to the Power BI Service, with all slicers and AI visuals. Requires signing in with a Microsoft account that has access to the workspace.

## Overview

This project answers questions like: *Where are Bangalore's restaurants concentrated? What drives a restaurant's rating up or down? How do cost, cuisine, and service type relate to customer ratings?* The final deliverable is a multi-page interactive Power BI report backed by a SQL Server database.

## Data Source

- **Dataset:** Zomato Bangalore Restaurants (publicly available scraped dataset, ~2019).
- **Raw size:** 51,717 listing-rows × 17 columns (~574 MB, mostly raw review text).
- **Scope:** Bangalore, India only. This is a historical snapshot, not live data.

## Pipeline

```
Raw CSV  →  Data Cleaning (Python)  →  SQL Server  →  Power BI  →  Dashboard + AI visuals
```

### 1. Data Cleaning

The raw file had several quality issues that were resolved before analysis:

- **Duplicate listings.** The raw data repeated each restaurant once per service category (Delivery, Dine-out, Cafes, etc.), inflating 12,464 real restaurants into 51,717 rows. These were collapsed to one row per physical restaurant (by name + address), keeping the highest-voted listing as the representative record and rolling all service categories into a single `Service_Types` field.
- **Text encoding corruption.** Garbled characters (e.g. "Café" rendered as byte-soup) in ~269 names were repaired.
- **Inconsistent rating format.** The `rate` field mixed formats (`"4.1/5"`, `"4.1 /5"`) and placeholder strings (`"NEW"`, `"-"`). It was parsed into a clean numeric `Rating` column plus a separate `Rating_Status` flag (Rated / New / Not rated / Missing) so genuinely-missing data isn't confused with un-rated restaurants.
- **Cost stored as text.** `approx_cost(for two people)` values like `"1,200"` were converted to numbers.
- **Phone formatting.** Multiple numbers per cell were split into `Phone_1` / `Phone_2` and standardized to a consistent `+91 XXXXX XXXXX` format.
- **Oversized text blobs.** The raw review text (up to 1.28 million characters for a single restaurant) was summarized into `Review_Count` and `Review_Rating_Average` rather than carried forward, shrinking the file from 574 MB to ~8 MB.

**Result:** 12,464 rows × 20 columns, fully typed and analysis-ready.

### 2. SQL Server

The cleaned data was loaded into a SQL Server database (`ZomatoProject`). Column types and sizes were defined explicitly to avoid truncation, and SQL views were created for common aggregations (average rating and cost by location, cuisine popularity, online-order impact on ratings).

### 3. Power BI

Power BI Desktop connects to SQL Server via **Import** mode. The data model uses:
- A main fact table (`Zomato_Data`) at one row per restaurant.
- A `Cuisines` dimension and a `CuisineBridge` table to handle the many-to-many relationship between restaurants and cuisines (a restaurant can list several cuisines), so cuisine-level analysis doesn't double-count restaurant metrics.

Key DAX measures: `TotalRestaurants`, `AvgRating`, `AvgCost`, and `%OnlineOrder`.

## Dashboard Pages

1. **Overview** — KPI cards (total restaurants, average rating, average cost, % online order), a restaurants-by-location view, and a top-locations bar chart, with slicers for location, service type, and cuisine.
2. **Cuisine & Cost Analysis** — top cuisines by count and rating, and a cost-vs-rating comparison.
3. **Service Type Breakdown** — Delivery vs Dine-out vs Cafes performance.
4. **Ratings Deep Dive** — rating distribution, `Rating_Status` breakdown, and review-count-vs-rating relationship.
5. **AI Insights** — Power BI's built-in AI visuals (Key Influencers, Decomposition Tree, Q&A).

## Key Findings

- **12,464 restaurants** analyzed, with an **average rating of 3.62 / 5** and an **average cost of ₹488** for two.
- **52%** of restaurants offer online ordering, while only **~8%** support table booking.
- **Restaurant type and price are the strongest rating drivers.** Power BI's Key Influencers analysis found that Casual Dining / Cafe restaurants, and those costing over ₹1,050 for two, are most associated with higher ratings.
- **North Indian, Chinese, and South Indian** are the most common cuisines; the most frequent single offering is a combined **Delivery + Dine-out** service model.
- **Whitefield, Electronic City, and BTM** have the highest restaurant density among Bangalore's areas.
- Roughly **1 in 20 rated restaurants** were flagged as "New" (not yet rated), which were deliberately separated from missing data during cleaning to keep rating averages honest.

## Tools Used

- **Python** (pandas, ftfy) — data cleaning and profiling
- **SQL Server / SSMS** — database and views
- **Power BI Desktop** — data modeling (DAX), visuals, and AI visuals
- **AI assistant (Claude)** — see note below

## Note on AI Assistance

AI assistance (Claude) was used to help draft the data-cleaning script, SQL views, and DAX measures, and to help write this summary. All generated logic was reviewed, tested, and validated before use; the analysis decisions, dashboard design, and interpretation of results are my own. This is documented here in the interest of transparency rather than presenting the work as a black box.

## Repository Contents

- `Zomato_Data_cleaned_fixed.csv` — the cleaned, analysis-ready dataset
- `cleaning_report.md` — detailed log of every cleaning transformation
- `*.pbix` — the Power BI report file
- `README.md` — this file

# RentalAnalytics

**RentalAnalytics** is a SQL‑based analysis project built on the classic DVD Rental dataset. It focuses on customer behavior, category performance, and engagement insights using advanced SQL techniques such as window functions, CTEs, and materialized views.

---

## 📌 Project Overview
This project explores customer engagement, revenue trends, and operational gaps within a rental business. It includes segmentation, performance metrics, content gap analysis, and automated marketing‑target generation.

---

## ✔️ Key Tasks Completed

### 1. Customer Segmentation
Created a report classifying customers into:
- **Top Tier** — high spenders (above‑average total revenue)  
- **Occasional** — active but lower‑frequency renters  
- **At Risk** — no rentals in the last 30 days, using a dynamic current date:

---

### 2. Content Gap Analysis
Identified film categories that exist in the database but have **zero rentals** in specific store locations, highlighting inventory and demand gaps.

---

### 3. Performance Metrics
Calculated **average days between rentals per customer** using window functions (`LAG()`) to measure engagement frequency.

---

### 4. Engagement Tracking
Computed **average rental duration per category** to determine which genres customers keep longer.

---

### 5. Best Categories
Summarized **revenue per category** and filtered results to show only categories generating **above‑average revenue**.

---

### 6. Marketing Targets View
Built a daily‑refreshing materialized view (`marketing_targets_vw`) containing:
- **Platinum customers** (above‑average spenders)  
- Who **haven’t rented since a dynamic cutoff date**  
- Using the dataset’s timeline:

- Scheduled to refresh automatically

---

## 🛠️ Tech Stack
- PostgreSQL  
- SQL Window Functions  
- CTEs  
- Materialized Views  
- Refresh Scheduling




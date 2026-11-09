# 📱 Enterprise E-Commerce Revenue & Retention Analytics Engine

## 🏗️ 1. Database Architecture & Schema Design
This project architectures a relational data platform for a multi-channel **Consumer Electronics & Gadgets** e-commerce ecosystem. The environment is optimized using a **Star Schema** variant deployed natively within **Microsoft SQL Server (T-SQL)** to maximize query performance and ensure seamless schema mapping into modern BI tools.

### 🔒 Enterprise Constraints Implemented:
*   **`PRIMARY KEY CLUSTERED`:** Applied to all entity IDs (`customer_id`, `product_id`, etc.) to physically sort and index data rows for rapid search operations.
*   **`FOREIGN KEY REFERENCES`:** Explicitly links tables to prevent orphaned data records (e.g., an order cannot map to an invalid customer profile).
*   **`CHECK` Constraints:** Hardcoded operational guardrails directly into the engine, including `CHECK (unit_price > 0)` and a strict margin protection constraint named `[chk_prices]` checking that `unit_price >= cost_price`.
*   **`UNIQUE` Data Guard:** Enforced on `customers(email)` to guarantee data cleanliness and block duplicate registrations.

---

## 🧠 2. Core Business Problems Solved via T-SQL

### 💰 Core Queries I: Financial Performance & Revenue (Day 4)
*   **VIP Account Allocation:** Summarized individual order metrics to identify high-value consumer cohorts by total revenue contributions.
*   **Time-Series Income Velocity:** Aggregated day-level orders into structured year-month (`yyyy-MM`) summaries to monitor corporate sales trends over time.
*   **Average Order Value (AOV):** Uncovered the store's baseline basket sizes and item quantities per transaction to guide future cross-selling initiatives.

### 📈 Core Queries II: Growth Momentum & Marketing ROI (Day 5)
*   **Month-over-Month (MoM) Category Velocity:** Leveraged **Common Table Expressions (CTEs)** and advanced window operations (`LAG()`) to compute the net revenue growth rate of different product sectors (Audio, Displays, Peripherals) across sequential months.
*   **Marketing Attribution Performance:** Managed multi-table `LEFT JOIN` logic arrays to measure the exact customer sign-up conversion rate percentage (`conversion_rate_pct`) against actual purchase value across digital ad platforms (Google, Meta, YouTube, Email, Organic).

### 🔄 Core Queries III: Retention Matrix & Value Segmentation (Day 6)
*   **Repeat-Purchase Density:** Calculated the business retention index by filtering one-off test shoppers from highly loyal, repeat buyers.
*   **Critical Churn Alert Logging:** Constructed precise date calculations (`DATEDIFF`) to flag stagnant consumer files that haven't registered an order within a 90-day trailing benchmark boundary.
*   **Audience Portfolio Value Tiering:** Utilized conditional logic structures (`CASE WHEN`) to split the buyer network into actionable marketing management segments based on their absolute **Customer Lifetime Value (LTV)** boundaries.

---

## 📊 3. Primary Analytical Discoveries
*   **High VIP Revenue Concentration:** LTV segmentation verified that Tier 1 VIP shopper profiles (including specific high-value repeat shoppers like *Ubed Ur Rahman*) account for a dominant share of gross platform checkout volume.
*   **Organic Acquisition Superiority:** Attribution matrix analytics proved that **Organic Search** pathways deliver the highest structural customer conversion percentage compared to high-cost programmatic channels (such as YouTube Sponsorships).
*   **Retention Churn Warning:** The aging engine flagged a critical cluster of buyers entering high-risk churn status (over 90 days inactive), indicating a vital opportunity to deploy automated email remarketing campaigns.

---

## 🛠️ 4. Technical Environment & Skills Demonstrated
*   **Engine & Interface:** Microsoft SQL Server Management Studio (SSMS)
*   **SQL Dialect:** Transact-SQL (T-SQL Natively)
*   **Competencies:** Table structures, relational key constraints, multi-stage nested CTE scripts, windowing partitions (`OVER`), time-series date parsing (`FORMAT / DATEDIFF`), logical conditional formatting (`CASE`), and data casting math (`CAST AS DECIMAL`).

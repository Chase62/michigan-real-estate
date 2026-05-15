## Identifying the Best Properties for Investment	

# Executive Summary

A Michigan real estate investment firm seeks to identify high-potential properties and neighborhoods for acquisition in a competitive market characterized by moderate price growth, tight inventory in premium areas, and significant regional variability. The core challenge is moving beyond subjective methods to data-driven decisions: determining which property attributes and location factors most strongly drive higher sale prices and faster time-on-market (TOM), while establishing optimal listing strategies to minimize holding costs and maximize returns.  
Key findings indicate the following attributes have the highest market heat index:

* **Single-family homes** are the strongest investment category, showing the highest market heat (list-to-sold ratio) and sales volume.  
* Within this segment, **new builds (\<10 years)** and **mid-life properties (25–50 years)** sized **1,000–3,000 sqft** perform best.  
* Top-performing markets include **Marquette** (highest market heat with the most affordable entry at \~$133/sqft), **Grand Rapids metro/rural areas** (strong volume, solid heat, and premium pricing), and **Pontiac** (high price-per-sqft upside).  
* New acquisitions should be listed **2–4% below** ZIP-level median price-per-sqft (adjusted for age) to accelerate sales, target properties with historical heat ≥ 0.97, and use minor concessions instead of deep discounts.

Following this **Balanced Growth Investment Framework** will help equip the firm to prioritize high risk-adjusted ROI opportunities, improve acquisition precision, and optimize listing performance in Michigan’s evolving market.

# Problem Statement

A real estate investment firm operating in Michigan faces the challenge of efficiently identifying high-potential properties and neighborhoods for acquisition in a competitive yet opportunity-rich market. With moderate statewide price growth, tight inventory in premium areas, and variability across regions, subjective or outdated selection methods risk suboptimal returns. Key uncertainties persist around which property attributes and neighborhood factors most strongly predict higher sale prices and shorter TOM (Time on Market). Additionally, determining optimal listing prices for new acquisitions or flips remains difficult, as mispricing can lead to prolonged market exposure, price reductions, or missed opportunities in a market where well priced, move-in-ready homes sell faster and closer to (or above) asking price.  
Without rigorous, data-backed analysis of recent sales, the firm cannot maximize ROI through targeted investments, accurate valuation, or effective pricing strategies.

# Objective

The primary objective is to leverage recent Michigan home sales, sourced from publicly available real estate listings, to develop a data driven framework for investment decisions. Specifically: 

* Identify top performing neighborhoods and property characteristics associated with the highest sale prices and fastest TOM.  
* Quantify the relative influence of key factors, such as location metrics, property features like bedrooms/bathrooms/sq ft, lot size, age/condition, proximity to amenities, & economic indicators.  
* Recommend data backed pricing strategies for new listings to optimize speed to sale and net proceeds.

This analysis will enable the firm to prioritize investments with the strongest risk-adjusted returns, improve acquisition targeting, and enhance listing performance, ultimately strengthening competitiveness in Michigan’s evolving real estate landscape.

# Data Sources

Sourced from Kaggle, the Michigan Real Estate: [**Sold Properties Dataset 2026**](https://www.kaggle.com/datasets/kanchana1990/michigan-real-estate-sold-properties-dataset-2026) contains **9,889 verified sold residential properties** across Michigan. The data was collected from publicly available real estate listings in 2026 and includes only closed transactions (confirmed sold properties). All records have been PII-sanitized, with agent names, phone numbers, emails, street addresses, and MLS identifiers redacted for privacy and analytical safety.

* zip \- 5 digit zip code of the property’s location  
* type \- property type  
* year\_built \- year the property was constructed  
* listPrice \- original asking price (USD)  
* lastSoldPrice \- final verified sold price (USD)  
* list\_to\_sold\_ratio \- (lastSoldPrice ÷ listPrice) market heat indicator  
* sqft \- total interior square footage  
* price\_per\_sqft \- (lastSoldPrice ÷ sqft) normalised value metric  
* stories \- number of above ground floors  
* beds \- number of bedrooms  
* baths \- number of bathrooms  
* baths\_full \- number of full bathrooms  
* baths\_full\_calc \- calculated full bath count  
* garage \- garage space available  
* sanitized\_text \- PII-redacted listing description

This dataset performs well across the **ROCCC** criteria:

* **Reliable**: Contains only verified sold (closed) transactions with strong data cleaning, outliers were nulled rather than imputed, and duplicates were removed.  
* **Original**: Curated dataset with custom processing, PII redaction, and useful derived features (price\_per\_sqft and list\_to\_sold\_ratio).  
* **Comprehensive**: Offers good coverage of property types, price ranges ($800 – $10.9M), construction years (1800–2026), and geographic spread across Michigan ZIP codes. Includes rich textual descriptions for NLP analysis.  
* **Current**: Pulled in 2026, representing recently sold properties as of that year.  
* **Cited**: Clearly documented provenance and released under a **CC BY-NC 4.0** (Attribution-NonCommercial) license.

Overall, the dataset is credible and well-suited for investment analysis, price modeling, and market insights. Minor limitations (such as the absence of exact sale dates and lot size) are acknowledged and will be addressed during the analysis phase.

# Data Preparation & Cleaning

**Google Sheets**  
Due to the reasonable size of the dataset, Google Sheets was chosen to perform the initial data prep and cleaning. Much of the dataset was already cleaned, with duplicates removed, null sale prices removed, and out of range values nullified. Formatting was also already performed, with the data consisting of strings for property type and property description, with the remaining fields consisting of floats. 

**Key Preparation Steps:**

* Verified data types and formatting consistency.  
* Handled remaining missing values appropriately (mostly in stories, garage, and baths fields).  
* Conducted basic sanity checks on price, sqft, and ratio fields.

The following new columns were engineered to support the analysis objectives:

* id \- a unique identifier for each property  
* age \- Numerical age of the property, calculated as 2026 \- year\_built  
* age\_category \- categorized property ages (e.g., new: 0–10 years, established: 11–25, mid\_life: 26–50, mature: 51–100, historic: 100+ years)  
* region \- property location by Michigan region, derived from first 3 digits of Zip code  
* primary\_city \- text description based on numeric region   
* garage\_flag \- Boolean value indicating if garage is present (False \= no garage, True \= garage)  
* market\_heat\_category \- categorized list\_to\_sold\_ratio (e.g., discount: \<0.95, normal: 0.95 \- 1.0, premium: \>1.0)

These new features enable better segmentation, visualization, and modeling of factors influencing sale price and market performance.

# Analysis

Utilizing BigQuery, I ran the following SQL queries to further analyze the data.

**Most popular property types:**  
`SELECT`    
  `type,`  
  `COUNT (*) AS id`  
`` FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned` ``  
`GROUP BY type`  
`ORDER BY id DESC;`

**Average Sold price by property type:**  
`SELECT`    
  `type,`  
  `ROUND(AVG(lastSoldPrice), 2) AS avg_sold_price`  
`` FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned` ``  
`GROUP BY type`  
`ORDER BY avg_sold_price DESC;`

**Top Regions by Sales Volume & Performance:**  
`SELECT`    
  `primary_city,`  
  `COUNT(*) AS property_count,`  
  `AVG(list_to_sold_ratio) AS avg_list_to_sold_ratio,`  
  `AVG(lastSoldPrice) AS avg_sold_price,`  
  `AVG(price_per_sqft) AS avg_price_per_sqft`  
`` FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned` ``  
`GROUP BY primary_city`  
`ORDER BY avg_list_to_sold_ratio DESC;`

**Top ZIP Codes (Best Neighborhoods by Volume \+ Heat):**  
`SELECT`    
  `zip,`  
  `COUNT(*) AS property_count,`  
  `AVG(lastSoldPrice) AS avg_sold_price,`  
  `AVG(price_per_sqft) AS avg_price_per_sqft,`  
  `AVG(list_to_sold_ratio) AS avg_list_to_sold_ratio,`  
  `MIN(lastSoldPrice) AS min_price,`  
  `MAX(lastSoldPrice) AS max_price`  
`` FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned` ``  
`GROUP BY zip`  
`HAVING property_count >= 30          -- filter for statistical relevance`  
`ORDER BY avg_list_to_sold_ratio DESC`  
`LIMIT 20;`

**Property Age Performance:**  
`SELECT`    
  `age_category,`  
  `COUNT(*) AS property_count,`  
  `AVG(lastSoldPrice) AS avg_sold_price,`  
  `AVG(price_per_sqft) AS avg_price_per_sqft,`  
  `AVG(list_to_sold_ratio) AS avg_list_to_sold_ratio`  
`` FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned` ``  
`GROUP BY age_category`  
`ORDER BY avg_list_to_sold_ratio DESC;`

**Market Heat Categories Pricing:**  
`SELECT`    
  `market_heat_category,`  
  `COUNT(*) AS property_count,`  
  `AVG(list_to_sold_ratio) AS avg_ratio,`  
  `AVG(lastSoldPrice) AS avg_sold_price`  
`` FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned` ``  
`GROUP BY market_heat_category`  
`ORDER BY avg_ratio DESC;`

# Key Findings

<img width="1589" height="849" alt="Property Type" src="https://github.com/user-attachments/assets/df340736-8b13-44e7-b156-19028a629885" />

The graph above shows which property types had the highest market heat indicator (lastSoldPrice ÷ listPrice), with the thickness of the bars indicating the number of properties sold for each type. Viewing this we can see that not only do single family homes have the highest market heat indicator, but they also have sold the most compared to other property types. This suggests that single family homes are the safer property type for investment.

<img width="513" height="945" alt="Age Category" src="https://github.com/user-attachments/assets/51a8baf0-44d3-44de-9a13-45d726a34821" />

In this graph we can see that for single family homes; new (\<10yrs old) & mid life (25 \- 50 yrs old) had the highest market heat indicator, with historic having the lowest.

<img width="1126" height="883" alt="Home Size" src="https://github.com/user-attachments/assets/fe678a58-16c1-4251-a57e-6c3d77c8a2db" />

This graph displays the most popular single family home size, categorized by sqft, with the thickness of the bars indicating the number of homes sold for each size.

<img width="1478" height="866" alt="Hottest Regions" src="https://github.com/user-attachments/assets/3e12120f-564f-4f6c-b0f4-b6801d22667a" />

Now looking at regions, we see that Marquette and Grand Rapids both had market heat indicators above 1.0, suggesting high profitability. With Ann Arbor, Rural Flint, Pontiac, Rural Lansing, and Rural Grand Rapids not far behind, all scoring above 0.99.

<img width="629" height="883" alt="Avg Sqft Price" src="https://github.com/user-attachments/assets/b6974596-4619-44c1-ac07-7bf54406f3c6" />

Looking at those that scored higher than 0.99, we see that surprisingly Marquette had the lowest average price per sqft at $133.19 while Pontiac had the highest at $221.64.

After analyzing the data, the following inferences can be determined:

1. **Single Family homes are a good & safe choice for future investment**, they saw the highest market heat indicator and sold the most compared to other property types.  
2. When deciding which houses to invest in, single family homes that are **New (\<10 years) and Mid-Life (25–50 years)** that are between **1000 to 3000 sqft should be prioritized.**  
3. **Marquette** stands out as the **hottest market** overall (highest list-to-sold ratio), while also offering the **most affordable entry price** per square foot (\~$133) among the top-performing regions.  
4. **Grand Rapids** and its surrounding areas (including Rural Grand Rapids) offer a strong combination of **high volume**, solid market heat, and **premium pricing** (\~$213–$228 per sqft).  
5. **Pontiac** delivered one of the highest price-per-sqft values (\~$221) among markets with strong heat, suggesting robust buyer willingness to pay.

# Recommendations & Next Steps

When determining which properties to pursue, the real estate investment firm should adopt a **Targeted “Balanced Growth” Investment Framework** focused on single-family homes in high-heat, mid-to-high price-per-sqft markets. Specifically, properties that meet the following criteria:

* Single Family homes between **1,000 \- 3,000 sqft** should be prioritized.  
* Focus on **New (\<10 years)** or **Mid-Life (25–50 years)** properties.  
* Target the following regions in priority order:  
  * **Grand Rapids Metro & Rural Grand Rapids** \- Best balance of volume, appreciation, and pricing power.  
  * **Marquette** \- Highest market heat with very attractive entry pricing (\~$133/sqft).  
  * **Pontiac and select Southeast Michigan pockets** \- For higher price-per-sqft upside.

When determining **Pricing Strategy** for these properties, it is recommended that:

* New acquisitions are listed **2–4% below** the current ZIP-level median price\_per\_sqft for the property’s age bracket to maximize speed-to-sale and reduce holding costs.  
* Use the market heat indicator of comparable recent sales as a benchmark. Aim for properties with historical ratios ≥ 0.97.  
* Offer minor concessions (e.g., flexible closing dates or small seller credits) rather than deep price cuts if initial offers are slow.

# Tools Used

* Google Sheets  
* SQL  
* Tableau  
* Github

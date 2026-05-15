-- most popular property types
SELECT  
  type,
  COUNT (*) AS id
FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned`
GROUP BY type
ORDER BY id DESC;

-- average sold price by property type
SELECT  
  type,
  ROUND(AVG(lastSoldPrice), 2) AS avg_sold_price
FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned`
GROUP BY type
ORDER BY avg_sold_price DESC;

-- top regions by sales volume & performance
SELECT  
  primary_city,
  COUNT(*) AS property_count,
  AVG(list_to_sold_ratio) AS avg_list_to_sold_ratio,
  AVG(lastSoldPrice) AS avg_sold_price,
  AVG(price_per_sqft) AS avg_price_per_sqft
FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned`
GROUP BY primary_city
ORDER BY avg_list_to_sold_ratio DESC;

-- top zip codes
SELECT  
  zip,
  COUNT(*) AS property_count,
  AVG(lastSoldPrice) AS avg_sold_price,
  AVG(price_per_sqft) AS avg_price_per_sqft,
  AVG(list_to_sold_ratio) AS avg_list_to_sold_ratio,
  MIN(lastSoldPrice) AS min_price,
  MAX(lastSoldPrice) AS max_price
FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned`
GROUP BY zip
HAVING property_count >= 30          -- filter for statistical relevance
ORDER BY avg_list_to_sold_ratio DESC
LIMIT 20;

-- property age performance
SELECT  
  age_category,
  COUNT(*) AS property_count,
  AVG(lastSoldPrice) AS avg_sold_price,
  AVG(price_per_sqft) AS avg_price_per_sqft,
  AVG(list_to_sold_ratio) AS avg_list_to_sold_ratio
FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned`
GROUP BY age_category
ORDER BY avg_list_to_sold_ratio DESC;

-- market heat categories pricing
SELECT  
  market_heat_category,
  COUNT(*) AS property_count,
  AVG(list_to_sold_ratio) AS avg_ratio,
  AVG(lastSoldPrice) AS avg_sold_price
FROM `test-project-1-492916.michigan_real_estate.michigan_ultimate_cleaned`
GROUP BY market_heat_category
ORDER BY avg_ratio DESC;

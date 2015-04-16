-- load database prepared at previous step
.read ../step2/sources.sql

.mode csv
.headers on

-- a query to group
.once nytimes_manga_bestsellers_grouped_by_title.csv
SELECT DISTINCT
  `Primary ISBN10`,
  `Primary ISBN13`,
  `Title`,
  `Author`
FROM nytimes_manga_best_seller_lists
ORDER BY Title, Author
;


-- SQL PROJECT - EDA
-- Exploratory Data Analysis
-- Here im just going to explore the data and try to find trends and patterns or anything interesting

SELECT *
FROM world_layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs_staging2;


-- checking companies that laid off 100% of their employees & had the highest funds raised
SELECT *
FROM world_layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- checking total number of people laid off per company from highest to lowest 
SELECT company, SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- date range, that is when people started losing their jobs and when it ended (covid era)
SELECT MIN(`Date`), MAX(`date`)
FROM world_layoffs_staging2;

-- A summary of people that were laid off per industry from highest to lowest
SELECT industry , SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT *
FROM world_layoffs_staging2;

-- A summary of people that were laid of in each country from highest to lowest
SELECT country , SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- time series, summary of people laid off per year starting from the latest year
SELECT year(`date`), SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 DESC;

-- A summary of people that were laid off per stage of the company
SELECT stage, SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT *
FROM world_layoffs_staging2;

SELECT stage, SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- rolling total_laid_offs ( Progression of layoffs from when it started to the end)

-- total number of people laid off each month per year from 2020 to 2023
SELECT substr(`date`,1,7) AS MONTH, sum(total_laid_off)
FROM world_layoffs_staging2
WHERE substr(`date`,1,7) IS NOT NULL
GROUP BY substr(`date`,1,7)
ORDER BY 1 ASC;


-- A rolling sum of the rolling total/progression of the laid offs
WITH Rolling_Total as 
(SELECT substr(`date`,1,7) AS `MONTH`, sum(total_laid_off) AS Total_Off
FROM world_layoffs_staging2
WHERE substr(`date`,1,7) IS NOT NULL
GROUP BY substr(`date`,1,7)
ORDER BY 1 ASC)

SELECT `MONTH`,Total_Off,
 sum(Total_Off) over(order by `MONTH`) as rolling_total
FROM Rolling_Total;


SELECT company, SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- How many people companies were laying off per year, highest to lowest

SELECT company, year(`date`), SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY company, year(`date`)
order by 3 desc;

-- Rank which years companies laid off the most people, highest one based on laid offs should RANK1

With Company_year (Company, Years, Total_laid_off) AS
(SELECT company, year(`date`), SUM(total_laid_off)
FROM world_layoffs_staging2
GROUP BY company, year(`date`)
), Company_year_rank as

(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY Total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL)

select *
from Company_year_rank
where ranking <= 5;




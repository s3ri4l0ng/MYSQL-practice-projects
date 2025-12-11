
-- SQL Project - Data Cleaning 

select *
From world_layoffs;

-- First thing to do is create a staging table,this is the one I will be working on and clean the data. We want to keep the original table incase something happens 
CREATE TABLE world_layoffs_staging
LIKE world_layoffs;

INSERT world_layoffs_staging
select * 
From world_layoffs;

-- When data cleaning we usually follow the following steps
  -- 1. Remove Duplicates
  -- 2. Standardize the data
  -- 3. Null/blank values
  -- 4. Remove unimportant columns 
  
  
  -- 1. Remove Duplicates 
  
# check for duplicates 

SELECT * 
FROM world_layoffs_staging;

SELECT company, industry, total_laid_off, `date`,
      ROW_NUMBER() 
      OVER( PARTITION BY company, industry, total_laid_off, `date`) AS row_num
      FROM world_layoffs_staging;
      
SELECT *
FROM (SELECT company, industry, total_laid_off, `date`,
      ROW_NUMBER() 
      OVER( PARTITION BY company, industry, total_laid_off, `date`) AS row_num
      FROM world_layoffs_staging) duplicates
      WHERE
           row_num > 1;
           
-- look at company named oda to confirm
	
    select * 
    FROM world_layoffs_staging
    WHERE company = 'Oda'; -- these are real entries and shouldn't be deleted
    
-- these are real duplicates


SELECT *
FROM ( SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
     ROW_NUMBER () OVER ( PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
     `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs_staging) duplicates
WHERE row_num > 1;  -- these are the ones we want to delete where the row number is greater than 1

SELECT *
FROM world_layoffs_staging;

-- I am going to create another table and add row num column to make it easy to delete the duplicates
CREATE TABLE world_layoffs_staging2
Like world_layoffs_staging;

ALTER TABLE  world_layoffs_staging2
ADD COLUMN row_num INT;

INSERT INTO world_layoffs_staging2
SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
     `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs_staging;


SELECT *
FROM world_layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM world_layoffs_staging2
where row_num > 1;

SELECT *
FROM world_layoffs_staging2; -- I will be using this table without duplicates going forward
-- DONE WITH DUPLICATES

-- 2. STANDARDIZE DATA
SELECT country
FROM world_layoffs_staging2;

SELECT distinct company, (TRIM(company))
FROM world_layoffs_staging2;

UPDATE world_layoffs_staging2
SET company = (TRIM(company)); -- I used trim to remove spaces on both ends


SELECT distinct country, count(*)
FROM world_layoffs_staging2
group by country
order by 1; -- looks like there is United States with a period and one without a period that needs fixing

UPDATE world_layoffs_staging2
set country = 'United States'
where country like 'United States%';

-- I need to change date into a correct format since its written in text 
SELECT `date`,
STR_TO_DATE( `date`, '%m/%d/%Y')
FROM world_layoffs_staging2;

UPDATE world_layoffs_staging2
SET `date` = STR_TO_DATE( `date`, '%m/%d/%Y');

-- Now convert the data type properly
ALTER TABLE world_layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM world_layoffs_staging2; -- Done with DATE

SELECT distinct industry, count(*) 
from world_layoffs_staging2
group by industry 
order by 1; -- It looks like Crypto industry is written in different variations and needs to be fixed

update world_layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

SELECT *
FROM world_layoffs_staging2
WHERE industry IS NULL
OR industry = ''
ORDER BY industry; -- lets look at Bally

SELECT *
FROM world_layoffs_staging2
WHERE company LIKE 'Bally%'; -- there's nothing wrong here

-- lets look at 'airbnb'
SELECT *
FROM world_layoffs_staging2
WHERE company LIKE 'Airbnb'; -- Looks like airbnb is travel industry so NULL values under airbnb need to be populated

-- I am about to write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- Firstly I need to set blanks into NULL values because they are easy to work with

UPDATE world_layoffs_staging2
set industry = NULL
WHERE industry = '';

select t1.industry, t2.industry
FROM world_layoffs_staging2 t1
	join world_layoffs_staging2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL  OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- now we check all those nulls
SELECT *
FROM world_layoffs_staging2
WHERE industry IS NULL
OR industry = ''
order by industry;

-- And then we populate those nulls where possible 
UPDATE world_layoffs_staging2 t1
      JOIN world_layoffs_staging2 t2
      ON t1.company = t2.company 
      SET t1.industry = t2.industry 
      WHERE t1.industry IS NULL
      AND t2.industry IS NOT NULL; -- Looks like Bally was the only who's nulls can't be populated
      
      SELECT *
      FROM world_layoffs_staging2;
      
-- 3. Look at null values 
-- Null values in total_laid_off, percentage_laid_off and funds_raised_millions look normal making it easy for EDA
-- So there is really nothing to change


-- 4. Delete unimportant columns OR rows
SELECT *
FROM world_layoffs_staging2
WHERE total_laid_off IS NULL;

SELECT *
FROM world_layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- DELETE USELESS DATA WE CANT USE
DELETE FROM world_layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

  SELECT *
  FROM world_layoffs_staging2;
  
  ALTER TABLE world_layoffs_staging2
  DROP COLUMN row_num;
    
SELECT *
FROM world_layoffs_staging2;



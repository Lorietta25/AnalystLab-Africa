 SELECT * FROM netflix_titles


----    Check Dataset Structure


----  Number of Rows

SELECT COUNT(*) AS TotalRows
FROM netflix_titles;


----  Number of Columns

SELECT COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'netflix_titles';

---- Data Types

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'netflix_titles';
                  
                  
                  --- Check for Duplicate Records

SELECT show_id, COUNT(*) AS DuplicateCount
FROM netflix_titles 
GROUP BY show_id
HAVING COUNT(*) > 1;
  

 SELECT COUNT(*) - COUNT(DISTINCT show_id) AS DuplicateRows
FROM netflix_titles;


                      -- FILTERING MISSING VALUES
SELECT
    SUM(CASE WHEN show_id IS NULL OR show_id = '' THEN 1 ELSE 0 END) AS Missing_ShowID,
    SUM(CASE WHEN type IS NULL OR type = '' THEN 1 ELSE 0 END) AS Missing_Type,
    SUM(CASE WHEN title IS NULL OR title = '' THEN 1 ELSE 0 END) AS Missing_Title,
    SUM(CASE WHEN director IS NULL OR director = '' THEN 1 ELSE 0 END) AS Missing_Director,
    SUM(CASE WHEN cast IS NULL OR cast = '' THEN 1 ELSE 0 END) AS Missing_Cast,
    SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS Missing_Country,
    SUM(CASE WHEN date_added IS NULL OR date_added = '' THEN 1 ELSE 0 END) AS Missing_DateAdded,
    SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS Missing_Rating,
    SUM(CASE WHEN duration IS NULL OR duration = '' THEN 1 ELSE 0 END) AS Missing_Duration,
    SUM(CASE WHEN listed_in IS NULL OR listed_in = '' THEN 1 ELSE 0 END) AS Missing_ListedIn,
    SUM(CASE WHEN description IS NULL OR description = '' THEN 1 ELSE 0 END) AS Missing_Description
FROM netflix_titles ;

----- Replace Missing Values


UPDATE netflix_titles 
SET director = 'Unknown'
WHERE director IS NULL;


UPDATE netflix_titles 
SET cast = 'Unknown'
WHERE cast IS NULL;

UPDATE netflix_titles 
SET country = 'Unknown'
WHERE country IS NULL;


UPDATE netflix_titles 
SET rating = 'Not Rated'
WHERE rating IS NULL;

UPDATE netflix_titles 
SET duration = 'Not Given'
WHERE duration IS NULL;

UPDATE netflix_titles 
SET description = 'Unknown'
WHERE description IS NULL;


---- Remove Leading and Trailing Spaces (Inconsistency check)


-- Show_ID
SELECT *
FROM netflix_titles
WHERE show_id <> LTRIM(RTRIM(show_id));

-- Type
SELECT *
FROM netflix_titles
WHERE type <> LTRIM(RTRIM(type));

-- Title
SELECT *
FROM netflix_titles
WHERE title <> LTRIM(RTRIM(title));

-- Director
SELECT *
FROM netflix_titles
WHERE director <> LTRIM(RTRIM(director));

-- Cast
SELECT *
FROM netflix_titles
WHERE cast <> LTRIM(RTRIM(cast));

-- Country
SELECT *
FROM netflix_titles
WHERE country <> LTRIM(RTRIM(country));

-- Rating
SELECT *
FROM netflix_titles
WHERE rating <> LTRIM(RTRIM(rating));

-- Duration
SELECT *
FROM netflix_titles
WHERE duration <> LTRIM(RTRIM(duration));

-- Listed_In
SELECT *
FROM netflix_titles
WHERE listed_in <> LTRIM(RTRIM(listed_in));

-- Description
SELECT *
FROM netflix_titles
WHERE description <> LTRIM(RTRIM(description));

-- Date_Added
SELECT *
FROM netflix_titles
WHERE date_added <> LTRIM(RTRIM(date_added));


--Show ID

UPDATE netflix_titles
SET show_id = LTRIM(RTRIM(show_id));

--Type

UPDATE netflix_titles
SET type = LTRIM(RTRIM(type));

--Title

UPDATE netflix_titles
SET title = LTRIM(RTRIM(title));

--Director

UPDATE netflix_titles
SET director = LTRIM(RTRIM(director));

--Cast

UPDATE netflix_titles
SET cast = LTRIM(RTRIM(cast));

--Country
UPDATE netflix_titles
SET country = LTRIM(RTRIM(country));

--Duration

UPDATE netflix_titles
SET duration = LTRIM(RTRIM(duration));

--Listed In

UPDATE netflix_titles
SET listed_in = LTRIM(RTRIM(listed_in));

--Date_added

UPDATE netflix_titles
SET date_added = LTRIM(RTRIM(date_added));


---   Check Invalid Country Formatting

-- Leading Comma

SELECT DISTINCT country
FROM netflix_titles
WHERE country LIKE ',%';

-- Trailing Comma

SELECT DISTINCT country
FROM netflix_titles
WHERE country LIKE '%,';

  --  Remove Leading Commas

UPDATE netflix_titles
SET country = STUFF(country,1,1,'')
WHERE country LIKE ',%';

--- Remove Trailing Commas

UPDATE netflix_titles
SET country = LEFT(country,LEN(country)-1)
WHERE country LIKE '%,';


   --- Validate Release Year

SELECT *
FROM netflix_titles
WHERE release_year < 1900
OR release_year > YEAR(GETDATE());


---  Check Duration Stored in Rating Column


   SELECT title, rating, duration
FROM netflix_titles
WHERE duration = 'Unknown';

UPDATE netflix_titles
SET
    duration = rating,
    rating = 'Not Rated'
WHERE duration = 'Unknown'
  AND rating LIKE '%min';

  SELECT title, rating, duration
FROM netflix_titles
WHERE title LIKE '%Louis C.K%';


---- Create Clean Date Column


ALTER TABLE netflix_titles
ADD Date_Added_Clean DATE;


--- Populate Clean Date Column


UPDATE netflix_titles
SET Date_Added_Clean = TRY_CONVERT(DATE,date_added);

ALTER TABLE netflix_titles
DROP COLUMN date_added;

---  Standardize Rating Values


UPDATE netflix_titles
SET rating = 'Not Rated'
WHERE rating IN ('NR','UR');


---  Total Movies

SELECT COUNT(*) AS TotalMovies
FROM netflix_titles
WHERE type = 'Movie';


---  Total TV Shows

SELECT COUNT(*) AS TotalTVShows
FROM netflix_titles
WHERE type = 'TV Show';

---  Distinct Countries

SELECT COUNT(DISTINCT country) AS TotalCountries
FROM netflix_titles;




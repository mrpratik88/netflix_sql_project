DROP TABLE IF EXISTS netflix; 
CREATE TABLE netflix1
(
	show_id VARCHAR(6),
	type	VARCHAR(10),
	title	VARCHAR(150),
	director	VARCHAR(220),
	castS	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description  VARCHAR(250)
);

select * from netflix1;

SELECT DISTINCT type FROM netflix1;

SELECT 
  COUNT(*) AS Total_content
FROM netflix1;

--15 Business Problems
--1. Count the number of Movies VS TV Shows

SELECT type,COUNT(*) as total_content
FROM netflix1
GROUP BY type;

--2. Find the most common rating for movies and TV shows
SELECT 
   type,
   rating
FROM
(
    SELECT
	  type,
	  rating,
	  COUNT(*),
	  RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking 
	FROM netflix1
	GROUP BY 1,2 
)as t1 
WHERE
	 ranking=1


--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflix1
 WHERE 
	 type='Movie' 
     AND 
	 release_year=2020;

--4. Find the top 5 countries with the most content on Netflix

SELECT 
     UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
     COUNT(show_id) AS total_content
FROM netflix1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5



--5. Identify the longest movie
SELECT * FROM netflix1
WHERE type = 'Movie'
AND duration=(SELECT MAX (duration)FROM netflix1)

--6. Find content added in the last 5 years
SELECT
	*
FROM
	NETFLIX1
WHERE
	TO_DATE(DATE_ADDED, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix1
WHERE director LIKE '%Rajiv Chilaka%'



--8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix1
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;


--9. Count the number of content items in each genre

SELECT listed_in AS genre,
       COUNT(*) AS total_content
FROM netflix1
GROUP BY listed_in;

--10.Find each year and the average numbers of content release in India on netflix.

SELECT
EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
COUNT(*),
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix1 WHERE country = 'India')::numeric * 100 as avg_content_per_year
FROM netflix1
WHERE country = 'India'
GROUP BY 1

--11. List all movies that are documentaries

SELECT * 
FROM netflix1
WHERE listed_in ILIKE '%Documentaries%';

--12. Find all content without a director

SELECT * 
FROM netflix1
WHERE director IS NULL;



--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * 
FROM netflix1
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix1
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix1
) AS categorized_content
GROUP BY category;



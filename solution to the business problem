
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

--1. Count the number of Movies vs TV Shows
select type,count(*)from netflix
group by type ;

-- 2. Find the most common rating for movies and TV shows
SELECT 
    type, 
    rating
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS rating_count,
        RANK() OVER (
            PARTITION BY type 
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM netflix
    GROUP BY type, rating
) AS t1
WHERE ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT 
    type, 
    title, 
    release_year
FROM netflix
WHERE type = 'Movie' 
  AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT 
    UNNEST(string_to_array(country, ',')) AS new_country, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY new_country
ORDER BY content_count DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT 
    type, 
    title, 
    duration
FROM netflix
WHERE type = 'Movie' 
  AND duration = (
      SELECT MAX(duration) 
      FROM netflix
      WHERE type = 'Movie'
  );

-- 6. Find content added in the last 5 years
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT 
    type, 
	title,
    director 
    
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons
SELECT 
    type, 
    title, 
    duration
FROM netflix
WHERE type = 'TV Show' 
  AND split_part(duration, ' ', 1)::int > 5;

--9.Count the number of content items in each genre
-- 9. Count the number of content items in each genre
SELECT 
    UNNEST(string_to_array(listed_in, ',')) AS genre, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY genre
ORDER BY content_count DESC;

-- 10. Find each year and the average numbers of content release in India on Netflix. 
-- Return top 5 years with highest avg content release!
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) AS cont_year,
    COUNT(*) AS content_count,
    ROUND(
        COUNT(*)::NUMERIC / (
            SELECT COUNT(*) 
            FROM netflix
            WHERE country ILIKE '%india%'
        ), 
        2
    ) * 100 AS avg_percentage
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY cont_year;

-- 11. List all movies that are documentaries
SELECT 
    type, 
    title, 
    listed_in
FROM netflix
WHERE type = 'Movie' 
  AND listed_in ILIKE '%Documentaries%';

 
-- 12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
--14.Find the top 10 actors who have appeared in the highest number
--of movies produced in India.
SELECT 
    UNNEST(string_to_array(casts, ',')) AS actor, 
    COUNT(*) AS content_count
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actor
ORDER BY content_count DESC
LIMIT 10;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.--

SELECT 
    CASE
        WHEN description ILIKE '%kill%' 
          OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS label,
    COUNT(*)
FROM netflix
GROUP BY 1;

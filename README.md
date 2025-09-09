# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT 
    type, 
    title, 
    release_year
FROM netflix
WHERE type = 'Movie' 
  AND release_year = 2020;

```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
    UNNEST(string_to_array(country, ',')) AS new_country, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY new_country
ORDER BY content_count DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
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
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT 
    type, 
	title,
    director 
    
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT 
    type, 
    title, 
    duration
FROM netflix
WHERE type = 'TV Show' 
  AND split_part(duration, ' ', 1)::int > 5;
```


**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(string_to_array(listed_in, ',')) AS genre, 
    COUNT(*) AS content_count
FROM netflix
GROUP BY genre
ORDER BY content_count DESC;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
    type, 
    title, 
    listed_in
FROM netflix
WHERE type = 'Movie' 
  AND listed_in ILIKE '%Documentaries%';

```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT *
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
    UNNEST(string_to_array(casts, ',')) AS actor, 
    COUNT(*) AS content_count
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actor
ORDER BY content_count DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
SELECT 
    CASE
        WHEN description ILIKE '%kill%' 
          OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS label,
    COUNT(*)
FROM netflix
GROUP BY 1;

```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

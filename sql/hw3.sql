SELECT 'ФИО: Непочатых Александр Анатольевич';

-- windows functions
SELECT userId, movieId,
	   (rating - MIN(rating) OVER (PARTITION BY userId)) /
	   (MAX(rating) OVER (PARTITION BY userId) - MIN(rating) OVER (PARTITION BY userId)) normed_rating, 
	   AVG(rating) OVER (PARTITION BY userId) avg_rating 
  FROM public.ratings
 LIMIT 30;

 -- extract - create table 
DROP TABLE IF EXISTS keywords;
CREATE TABLE
keywords (
    id bigint,
    tags text
);

-- extract get the table from csv file
psql -c "\\copy keywords FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER"

-- transform
WITH top_rated as ( 
	SELECT movieId, AVG(rating) avg_rating 
	  FROM public.ratings
	 WHERE movieId IN ( SELECT movieId 
						  FROM public.ratings 
						 GROUP BY movieId 
						HAVING COUNT(rating) > 50
					   )
	 GROUP BY movieId
	 ORDER BY avg_rating DESC, movieId
	 LIMIT 150
)
SELECT t1.*, t2.* 
  FROM top_rated t1
       JOIN public.keywords t2 ON (t1.movieId = t2.id)
;

-- load - create table
WITH top_rated as ( 
	SELECT movieId, AVG(rating) avg_rating 
	  FROM public.ratings
	 WHERE movieId IN ( SELECT movieId 
						  FROM public.ratings 
						 GROUP BY movieId 
						HAVING COUNT(rating) > 50
					   )
	 GROUP BY movieId
	 ORDER BY avg_rating DESC, movieId
	 LIMIT 150
)
SELECT t1.movieId, t2.tags INTO top_rated_tags
  FROM top_rated t1
       JOIN public.keywords t2 ON (t1.movieId = t2.id)
;

-- load - move to csv
psql -c "\\copy (SELECT * FROM top_rated_tags LIMIT 100) TO '/usr/local/share/netology/raw_data/top_rated_tags.csv' WITH CSV HEADER DELIMITER as ',';"


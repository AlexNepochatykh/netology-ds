SELECT 'ФИО: Непочатых Александр Анатольевич';

-- 1.1
SELECT * 
  FROM public.ratings 
 LIMIT 10;

-- 1.2
SELECT * 
  FROM public.links 
 WHERE imdbid LIKE '%42' 
   AND movieid BETWEEN 100 and 1000
 LIMIT 10;

-- 2.1
SELECT * 
  FROM public.links AS t1
       INNER JOIN public.ratings AS t2 ON t1.movieid = t2.movieid   
  WHERE t2.rating = 5
 LIMIT 10;

-- 3.1
SELECT COUNT(1) 
  FROM public.ratings
 WHERE rating IS NULL;

-- 3.2
SELECT userid, AVG(rating) 
  FROM public.ratings
 GROUP BY userid
HAVING AVG(rating) > 3.5
 LIMIT 10; 

-- 4.1
SELECT DISTINCT imdbId
  FROM public.links
 WHERE movieid in (SELECT movieid
			         FROM public.ratings
			        GROUP BY movieid 
			       HAVING AVG(rating) > 3.5)
 LIMIT 10;			        

-- 4.2
WITH users_more_than_10 AS (
  SELECT userid
    FROM public.ratings 
   GROUP BY userId
  HAVING COUNT(rating) > 10
)
SELECT AVG(rating) 
  FROM public.ratings
 WHERE userId in (SELECT userId 
 	                FROM users_more_than_10)
;


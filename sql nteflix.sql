select * from netflix;
select distinct type from netflix;

--1
select type,count(*)from netflix
group by type ;

--2
select type,rating from
(select type,rating,count(*),
rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
) as t1
where ranking=1
;

--3
select type,release_year from netflix
where type = 'Movie' and release_year='2020';

--4
select unnest(string_to_array(country,',')) as new_country ,count(*) from netflix
group by country
order by count(*) desc
limit 5;


--5
select type ,title,duration from netflix
where type='Movie' and duration =
(select max(duration) from netflix);




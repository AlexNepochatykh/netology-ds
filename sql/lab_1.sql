--Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов
select de.id, de.name, count(distinct em.chief_doc_id) count_chief
  from Employee em
  	   join Department de on (em.department_id = de.id)
 group by de.id, de.name
 order by de.id, de.name
 ;

--Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)
select de.id, de.name, count(em.id) total_employees
  from Employee em
  	   join Department de on (em.department_id = de.id)
 group by de.id, de.name
having count(em.id) >= 3
 order by total_employees desc;

--Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)
with publics as (
  select distinct de.id, de.name, 
  		 sum(em.num_public) over (partition by de.id, de.name) total_publics
    from Employee em
         join Department de on (em.department_id = de.id)
), ranked_publics as (
  select p.id, p.name, p.total_publics,
         rank() over (order by p.total_publics desc) rn
    from publics p
) 
select t.id, t.name, t.total_publics 
  from ranked_publics t
 where rn = 1
 ;

--Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)
with t as (
  select de.id, de.name dep_name, em.name em_name, em.num_public,
         row_number() over (partition by de.id, de.name order by em.num_public) rn
    from Employee em
         join Department de on (em.department_id = de.id)
)
select id, dep_name, em_name, num_public
  from t
 where rn = 1
;

--Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название --департамента, среднее количество публикаций)
with dep as (
  select de.id, de.name
    from Employee em
         join Department de on (em.department_id = de.id)
   group by de.id, de.name
  having count(distinct em.chief_doc_id) > 1
)
select distinct de.id, de.name, 
	   avg(em.num_public) over (partition by de.id, de.name) avg_publics
  from Employee em
  	   join dep de on (em.department_id = de.id)
;





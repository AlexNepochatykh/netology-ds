-- Написать не менее 10 SQL запросов к базе данных

-- 1. Подсчитать общее количесво сотрудников
select count(1) from public.employees;

-- 2. Подсчитать количество заказов, обработанных каждым сотрудником
select e.employee_id, e.first_name, e.last_name, count(o.order_id) cnt_orders
  from public.employees e
       join public.orders o on (e.employee_id = o.employee_id)
 group by e.employee_id, e.first_name, e.last_name
 order by e.employee_id
;

-- 3. Подсчитать общее количество клиентов
select count(1) from public.customers;

-- 4. Вывести 10 клиентов и количество сделанных ими заказов. Отсортировать по первичному ключу
select c.customer_id, c.company_name, count(o.order_id) cnt_orders
  from public.customers c
       join public.orders o on (c.customer_id = o.customer_id)
 group by c.customer_id, c.company_name
 order by c.customer_id
 limit 10
;

-- 5. Вывести 10 клиентов, у которых количество заказов больше 12. Отсортировать по максимальному количеству заказов
select c.customer_id, c.company_name, count(o.order_id) cnt_orders
  from public.customers c
       join public.orders o on (c.customer_id = o.customer_id)
 group by c.customer_id, c.company_name
having count(o.order_id) > 12 
order by cnt_orders desc
 limit 10
;

-- 6. Вывести 10 заказов с максимальным количество единиц товара внутри одного заказа
select d.order_id, sum(product_id * quantity) sum_total
  from public.order_details d
 group by d.order_id
 order by sum_total desc 
 limit 10
;

-- 7. Вывести 10 клиентов с максимальным числом заказов и показать среднее количество каждого продука, которое они заказывают. 
-- Отранжировать по среднему количеству каждого продукта
with top_10 as (
	select c.customer_id
	  from public.customers c
	       join public.orders o on (c.customer_id = o.customer_id)
	 group by c.customer_id
	 order by count(o.order_id) desc
    limit 10
)
select o.customer_id, avg(d.quantity) avg_quantity
  from public.orders o 
       join public.order_details d on (o.order_id = d.order_id) 
 where o.customer_id in (select customer_id from top_10)
 group by o.customer_id
 order by avg_quantity desc
;

-- 8. Присвоить степень важности каждому клиенту в зависимости от количества заказов для топ 10 заказчиков
with top_10 as (
	select c.customer_id, c.company_name, count(o.order_id) cnt_orders
	  from public.customers c
	       join public.orders o on (c.customer_id = o.customer_id)
	 group by c.customer_id, c.company_name
	order by cnt_orders desc
	 limit 10
) 
select t.customer_id, t.company_name, t.cnt_orders,
	   row_number() over (order by t.cnt_orders desc) importance_degree
  from top_10 t
; 

-- 9. Вывести последние 10 заказов и их даты у клиента с максимальным количеством заказов. Указать заказ и предыдущие 2
with top_1 as (
	select c.customer_id, c.company_name, count(o.order_id) cnt_orders
	  from public.customers c
	       join public.orders o on (c.customer_id = o.customer_id)
	 group by c.customer_id, c.company_name
	order by cnt_orders desc
	 limit 1
) 
select t.customer_id, t.company_name,
	   last_value(o.order_id) over (partition by o.customer_id order by o.order_date desc) last_order, 
	   last_value(o.order_date) over (partition by o.customer_id order by o.order_date desc) last_order, 
	   lag(o.order_id, 1) over (partition by o.customer_id order by o.order_date desc) last_order_1,
	   lag(o.order_date, 1) over (partition by o.customer_id order by o.order_date desc) last_order_1_date,
	   lag(o.order_id, 2) over (partition by o.customer_id order by o.order_date desc) last_order_2, 
	   lag(o.order_date, 2) over (partition by o.customer_id order by o.order_date desc) last_order_2_date
  from public.orders o 
  	   join top_1 t on (o.customer_id = t.customer_id)
 limit 10
;

-- 10. Указать количество клиентов, обработанных каждым сотрудником 
select distinct
       e.employee_id, e.first_name, e.last_name,
       count(c.customer_id) over (partition by e.employee_id) customers_per_employee 
  from public.employees e 
       join public.orders o on (e.employee_id = o.employee_id)
       join public.customers c on (c.customer_id = o.customer_id)
 order by e.employee_id
;

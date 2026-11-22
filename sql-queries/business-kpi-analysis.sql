USE CATALOG databricks_wanderbricks_dataset_dais_2025;
USE SCHEMA wanderbricks;
select
 (select count(*) from users) as total_users,
 (select count(*) from properties) as total_properties,
 (select count(*) from bookings) as total_bookings,
 (select count(*) from hosts) as total_hosts,
 (select count(*) from cities) as total_cities,
 (select count(*) from amenities) as total_amenities,
 (select count(*) from employees) as total_employees;

-- check Booking status

 select status,count(*) as total_bookings
 from bookings
 group by status;

-- what percentage of total booking are cancelled?
-- cancelled booking /total booking * 100
with cancelled as (
    select count(*) as cancelled_count
    from bookings
    where status = 'cancelled'
),
total as (
       select count(*) as total_count
       from bookings
)
select round(cancelled_count/ total_count * 100,2 )as cancelled_percent from cancelled,total;

-- avg property price 
select round(avg(base_price),2) as avg_property_price
from properties;

-- top 5 cities from properties count
select c.city ,count(*) as total_properties from properties p
join cities c
on p.city_id = c.city_id
group by c.city_id,c.city
order by total_properties desc
limit 5

-- top 5 hosts by property count 
 select h.host_id,h.name,count(*) as total_properties from properties p
 join hosts h
 on p.host_id = h.host_id 
 group by h.host_id,h.name
 order by total_properties desc
 limit 5;

-- top 5 cities by revenue 
 select c.city,round(sum(b.total_amount),2) as total_revenue from bookings b
 join properties p
 on b.property_id = p.property_id
 join cities c 
on c.city_id = p.city_id 
group by c.city,c.city_id  
order by total_revenue desc 
limit 5;

-- booking by property type
 select p.property_type,count(*) as total_bookings from bookings b
 join properties p
 on p.property_id =b.property_id
 group by p.property_type
 order by total_bookings desc;

-- monthly booking trend 
 select year(created_at) as year,
 month(created_at) as month,
count(*) as total_bookings
from bookings
group by year,month 
order by year,month; 

-- booking cancellation by city
select c.city,count(*) as total_bookings,count_if(b.status = 'cancelled') as cancelled_bookings
from bookings b
join properties p
on  p.property_id = b.property_id
join cities c
on c.city_id = p.city_id
group by c.city_id,c.city
order by total_bookings desc;

-- most popular ameneties
select a.name,count(*) as total_amenities
from amenities a
join property_amenities p
on a.amenity_id = p.amenity_id
group by a.name
order by total_amenities desc;

#Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region.
select distinct market from dim_customer where customer = "Atliq Exclusive" and region = "APAC";

#What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,
#unique_products_2020
#unique_products_2021
#percentage_chg

with unique_products_2020 as (
	select count(distinct product_code) as unique_products_2020  from fact_sales_monthly where fiscal_year = '2020'),
unique_products_2021 as (
	select count(distinct product_code) as unique_products_2021 from fact_sales_monthly where fiscal_year = '2021')

select unique_products_2020.unique_products_2020, 
unique_products_2021.unique_products_2021, 
round(((unique_products_2021.unique_products_2021 - unique_products_2020.unique_products_2020) / unique_products_2020.unique_products_2020 * 100)) as percentage_chg
from unique_products_2020, unique_products_2021;

#Provide a report with all the unique product counts for each segment and sort them in descending order of product counts. 
#The final output contains 2 fields,
#segment
#product_count

select segment, count(segment) as product_count
from dim_product
group by segment
order by product_count desc;

#Follow-up: Which segment had the most increase in unique products in 2021 vs 2020? The final output contains these fields,
#segment
#product_count_2020
#product_count_2021
#difference

SELECT 
d.segment, 
count(distinct case when f.fiscal_year = '2020' then d.product_code end) as product_count_2020, 
count(distinct case when f.fiscal_year = '2021' then d.product_code end) as product_count_2021
from dim_product d
join fact_sales_monthly f 
on f.product_code = d.product_code
group by segment; 

#Get the products that have the highest and lowest manufacturing costs. 
#The final output should contain these fields,
#product_code, product, manufacturing_cost
select fmc.product_code, dp.product, fmc.manufacturing_cost 
from fact_manufacturing_cost fmc
join dim_product dp 
on dp.product_code = fmc.product_code 
where manufacturing_cost in (
(select min(manufacturing_cost) from fact_manufacturing_cost), 
(select max(manufacturing_cost) from fact_manufacturing_cost)); 
 
#Generate a report which contains the top 5 customers who received an average 
#high pre_invoice_discount_pct for the fiscal year 2021 and in the Indian market. 
#The final output contains these fields,
#customer_code
#customer
#average_discount_percentage

#requires all non aggregated values to be in the group by 
select fpid.customer_code, dc.customer, avg(fpid.pre_invoice_discount_pct) as average_discount_percentage
from fact_pre_invoice_deductions fpid
join dim_customer dc
on dc.customer_code = fpid.customer_code
where fpid.fiscal_year = '2021' and dc.market='India' 
group by dc.customer_code, dc.customer
order by avg(pre_invoice_discount_pct) desc
limit 5; 

#Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. 
#This analysis helps to get an idea of low and high-performing months and take strategic decisions.
#The final report contains these columns:
#Month
#Year
#Gross sales Amount
select month(date) as month, year(date) as year, sum(fgp.gross_price * fsm.sold_quantity) as gross_sales_amount
from dim_customer dc
join fact_sales_monthly fsm
on fsm.customer_code = dc.customer_code
join fact_gross_price fgp
on fgp.product_code = fsm.product_code 
where dc.customer = 'Atliq Exclusive' and fgp.fiscal_year = fsm.fiscal_year
group by month(date), year(date);

#In which quarter of 2020, got the maximum total_sold_quantity? 
#The final output contains these fields sorted by the total_sold_quantity,
#Quarter
#total_sold_quantity






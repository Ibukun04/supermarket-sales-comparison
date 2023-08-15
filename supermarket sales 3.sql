/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Invoice_ID]
      ,[Total]
      ,[Date]
      ,[Time]
      ,[Payment]
      ,[cogs]
      ,[gross_margin_percentage]
      ,[gross_income]
      ,[Rating]
  FROM [supermarket data].[dbo].[supermarket_sales 2] sup2

  SELECT [Invoice_ID]
      ,[Branch]
      ,[City]
      ,[Customer_type]
      ,[Gender]
      ,[Product_line]
      ,[Unit_price]
      ,[Quantity]
      ,[Tax 5%]
  FROM [supermarket data].[dbo].[supermarket_sales 1] sup1

  select *
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  order by branch

  --total number of customers

  select gender,count(gender) as CountOfGender
  from [supermarket data]..[supermarket_sales 1]
  group by gender

  --total number of product lines

  select Product_line, count(product_line) as Total
  from [supermarket data]..[supermarket_sales 1]
  group by Product_line

 --top selling product line in each city

  select product_line,sum(quantity) as TopSellingProductLine,city
  from [supermarket data]..[supermarket_sales 1]
  group by product_line,city
 --having city = 'mandalay'
  order by sum(quantity) desc

  --avg unit price between the different branches

   select city, product_line, round(avg(unit_price),2) as AVG_price
  from [supermarket data]..[supermarket_sales 1]
  group by city,product_line

  --most payment method often used by gender

 select gender,payment,count(gender) as MostUsedPaymentMethodByGender
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id 
  group by gender,payment
  order by gender

  --branch with the highest gross income

   select city, round(gross_income,2) as GrossIncome
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id 
  group by city,gross_income
  order by gross_income desc


  --average rating by gender in different branches

   select city, gender, count(gender) as CountofGender, round(avg(rating),2)as AvgRating,
   case
        when avg(rating) > 7.15 then 'Excellent'
	   when avg(rating) between 6.75 and 7.14 then 'Good'
	   else 'poor'
	  end as remark
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id 
  group by city,gender
  order by city

  --time of the day with the highest sales volume

  --select city,gender,quantity,time,payment,
  --case
  --when time between  '1899-12-30 10:00:00.000' and  '1899-12-30 11:59:00.000' then 'Morning'
  --when time between  '1899-12-30 12:00:00.000' and  '1899-12-30 15:59:00.000' then 'Afternoon'
  --when time between  '1899-12-30 16:00:00.000' and  '1899-12-30 18:59:00.000' then 'Evening'
  --else 'Night'
  --end as TimeOfTheDay
  --from [supermarket data]..[supermarket_sales 1] sup1
  --join [supermarket data]..[supermarket_sales 2] sup2
  --on sup1.invoice_id = sup2.invoice_id
  --order by quantity desc


with TimeSalesVolume as
(select city,gender,quantity,time,payment,
  case
  when time between  '1899-12-30 10:00:00.000' and  '1899-12-30 11:59:00.000' then 'Morning'
  when time between  '1899-12-30 12:00:00.000' and  '1899-12-30 15:59:00.000' then 'Afternoon'
  when time between  '1899-12-30 16:00:00.000' and  '1899-12-30 18:59:00.000' then 'Evening'
  else 'Night'
  end as TimeOfTheDay
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  )
 select TimeOfTheDay,sum(quantity) as TotalQuantitySold
 from TimeSalesVolume
 group by TimeOfTheDay
 order by sum(quantity) desc

 --Shopping Time Preference by Gender In different Branches

 with TimeSalesVolume as
(select city,gender,quantity,time,payment,
  case
  when time between  '1899-12-30 10:00:00.000' and  '1899-12-30 11:59:00.000' then 'Morning'
  when time between  '1899-12-30 12:00:00.000' and  '1899-12-30 15:59:00.000' then 'Afternoon'
  when time between  '1899-12-30 16:00:00.000' and  '1899-12-30 18:59:00.000' then 'Evening'
  else 'Night'
  end as TimeOfTheDay
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  )
 select gender,city,TimeOfTheDay,sum(quantity) as TotalQuantitySold
 from TimeSalesVolume
 group by gender,TimeOfTheDay, city
 order by sum(quantity) desc

 --product line with the highest gross income on average

 select Product_line,round(avg(gross_income),2) as AvgGrossIncome
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  group by Product_line
  --order by round(avg(gross_income),2)

  --comparison between weekdays and weekends shopping

  select city,Gender,datename(dw, date) as DaysOfTheWeek,(Quantity),Customer_type
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  group by DATENAME(dw, date),gender,quantity,Customer_type,city
  
  with WeekdaysWeekendsShopping as
  (select city,gender,datename(dw, date) as DaysOfTheWeek,Quantity,Customer_type
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  group by DATENAME(dw, date),gender,quantity,Customer_type,city
  )
  select DaysOfTheWeek, city, count(quantity) as CustomersCheckInCount,sum(quantity) as TotalQuantityBought,
   case 
  when DaysOfTheWeek = 'tuesday' then 'weekday'
  when DaysOfTheWeek = 'monday' then 'weekday'
  when DaysOfTheWeek = 'wednesday' then 'weekday'
  when DaysOfTheWeek = 'thursday' then 'weekday'
  when DaysOfTheWeek = 'friday' then 'weekday'
  else 'weekend'
  end as weekday_weekend
  from weekdaysweekendsshopping
 group by DaysOfTheWeek,city

 --weekday mostly preferred by genders to come shopping

  with WeekdaysWeekendsShopping as
  (select city,gender,datename(dw, date) as DaysOfTheWeek,Quantity,Customer_type
  from [supermarket data]..[supermarket_sales 1] sup1
  join [supermarket data]..[supermarket_sales 2] sup2
  on sup1.invoice_id = sup2.invoice_id
  group by DATENAME(dw, date),gender,quantity,Customer_type,city
  )
  select city,DaysOfTheWeek,gender,count(gender) as GenderNumberRecorded,sum(quantity) as TotalQuantityBought
  from weekdaysweekendsshopping
 group by DaysOfTheWeek,gender,city
 order by DaysOfTheWeek

 --relationship between gender and quantities of product bought

 select gender, round(avg(Quantity),2) as AvgNumberOfQuantityPurchasedPerEntry
  from [supermarket data]..[supermarket_sales 1] sup1
  group by gender
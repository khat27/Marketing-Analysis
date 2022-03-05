----------------See how the data looks like----------------------
select * from Marketing_data

----------------See if there are any 'weird' values
select distinct Country from Marketing_data
select distinct Education from Marketing_data
select distinct Marital_Status from Marketing_data


----------------Cleaning data----------------------

--update educations
update Marketing_Data
	set Education = case
						when Education = 'PhD' then Education
						when Education = 'Master' then Education
						else 'Bachelors and below'
					end
	from Marketing_data

--update marital statuses
update Marketing_Data
	set Marital_Status = case
						when Marital_Status = 'Together' then 'Married'
						else 'Single'
					end
	from Marketing_data


--Change Year_Birth to Age
Update Marketing_data
	set Age = 	YEAR(getdate()) - Year_Birth
	from Marketing_data

--create new table to see if there are anyone who's not accepting any offer
alter table Marketing_data
	add Accepting_any_offer varchar(100)

Update Marketing_data
	set Accepting_any_offer = case when AcceptedCmp1 = 'Yes' then 'True'
									when AcceptedCmp2 = 'Yes' then 'True'
									when AcceptedCmp3 = 'Yes' then 'True'
									when AcceptedCmp4 = 'Yes' then 'True'
									when AcceptedCmp5 = 'Yes' then 'True'
									when AcceptedCmp6 = 'Yes' then 'True'
									else 'False'
								end

--removing outliers
delete from Marketing_data where Age > 100


select * from Marketing_data




----------------Analyzing data----------------------


--adding age bins to the dataset
alter table Marketing_data
	add age_bin varchar(100)

update Marketing_data
	set age_bin = case
						when age between 1 and 10 then '1 - 10'
						when age between 11 and 20 then '11 - 20'
						when age between 21 and 30 then '21 - 30'
						when age between 31 and 40 then '31 - 40'
						when age between 41 and 50 then '41 - 50'
						when age between 51 and 60 then '51 - 60'
						when age between 61 and 70 then '61 - 70'
						when age between 71 and 80 then '71 - 80'
						when age between 81 and 90 then '81 - 90'
					end

--see how many people accepted offer for each campaign
select
	COUNT(case AcceptedCmp1 when 'yes' then 1 else null end) as Campaign_1,
	COUNT(case AcceptedCmp2 when 'yes' then 1 else null end) as Campaign_2,
	COUNT(case AcceptedCmp3 when 'yes' then 1 else null end) as Campaign_3,
	COUNT(case AcceptedCmp4 when 'yes' then 1 else null end) as Campaign_4,
	COUNT(case AcceptedCmp5 when 'yes' then 1 else null end) as Campaign_5,
	COUNT(case AcceptedCmp6 when 'yes' then 1 else null end) as Campaign_6,
	Not_accepting_offers
from Marketing_data,
(
select
	count(*) as Not_accepting_offers
from Marketing_data
where AcceptedCmp1 = 'No' and AcceptedCmp2 = 'No' and AcceptedCmp3 = 'No' and AcceptedCmp4 = 'No' and AcceptedCmp5 = 'No' and AcceptedCmp6 = 'No'
)t1
group by Not_accepting_offers


--see totals of people accepting and rejecting campaigns for each age group
with CTE as(
	select
		ID,
		Age, 
		case
			when age between 1 and 10 then '1 - 10'
			when age between 11 and 20 then '11 - 20'
			when age between 21 and 30 then '21 - 30'
			when age between 31 and 40 then '31 - 40'
			when age between 41 and 50 then '41 - 50'
			when age between 51 and 60 then '51 - 60'
			when age between 61 and 70 then '61 - 70'
			when age between 71 and 80 then '71 - 80'
			when age between 81 and 90 then '81 - 90'
		end as age_bin
	from Marketing_data
)
select
	CTE.age_bin, 
	COUNT(CTE.age) as total_count,
	count(case Accepting_any_offer when 'True' then 1 else null end) as Accepting_any,
	count(case Accepting_any_offer when 'False' then 1 else null end) as Rejecting_all,
	count(case AcceptedCmp1 when 'Yes' then 1 else null end) as Accepted_Campaign_1,
	count(case AcceptedCmp2 when 'Yes' then 1 else null end) as Accepted_Campaign_2,
	count(case AcceptedCmp3 when 'Yes' then 1 else null end) as Accepted_Campaign_3,
	count(case AcceptedCmp4 when 'Yes' then 1 else null end) as Accepted_Campaign_4,
	count(case AcceptedCmp5 when 'Yes' then 1 else null end) as Accepted_Campaign_5,
	count(case AcceptedCmp6 when 'Yes' then 1 else null end) as Accepted_Campaign_6
from CTE
join Marketing_data on Marketing_data.ID = CTE.ID
group by CTE.age_bin
order by CTE.age_bin

--Accepted campaigns per country
select
	Country, 
	COUNT(ID) as total_count,
	count(case Accepting_any_offer when 'True' then 1 else null end) as Accepting_any,
	count(case Accepting_any_offer when 'False' then 1 else null end) as Rejecting_all,
	count(case AcceptedCmp1 when 'Yes' then 1 else null end) as Accepted_Campaign_1,
	count(case AcceptedCmp2 when 'Yes' then 1 else null end) as Accepted_Campaign_2,
	count(case AcceptedCmp3 when 'Yes' then 1 else null end) as Accepted_Campaign_3,
	count(case AcceptedCmp4 when 'Yes' then 1 else null end) as Accepted_Campaign_4,
	count(case AcceptedCmp5 when 'Yes' then 1 else null end) as Accepted_Campaign_5,
	count(case AcceptedCmp6 when 'Yes' then 1 else null end) as Accepted_Campaign_6
from Marketing_data
where Age>40
group by Country

select 
	age_bin, 
	SUM(MntFruits) as Fruits, 
	SUM(MntWines) as Wines, 
	Sum(MntFishProducts) as Fishes, 
	Sum(MntGoldProds) as Golds,
	Sum(MntMeatProducts) as Meats,
	Sum(MntSweetProducts) as Sweets,
	SUM(MntFruits) + SUM(MntWines) + Sum(MntFishProducts) + Sum(MntGoldProds) + Sum(MntMeatProducts) + Sum(MntSweetProducts) as totals
from Marketing_data
group by age_bin
order by age_bin


select * from Marketing_data



declare @startDate datetime = '2023-10-15';


with prCuisine as (
select 'American' as SpecialCuisine, 'American' as NetworkCuisine union all
select 'Asian' as SpecialCuisine, 'Asian' as NetworkCuisine union all
select 'Bars & Breweries' as SpecialCuisine, 'Pub/Tavern' as NetworkCuisine union all
select 'BBQ' as SpecialCuisine, 'BBQ' as NetworkCuisine union all
select 'Brunch' as SpecialCuisine, 'Breakfast' as NetworkCuisine union all
select 'Chinese' as SpecialCuisine, 'Chinese' as NetworkCuisine union all
select 'Drinks' as SpecialCuisine, 'Pub/Tavern' as NetworkCuisine union all
select 'French' as SpecialCuisine, 'French' as NetworkCuisine union all
select 'Global' as SpecialCuisine, 'Theme/Specialty' as NetworkCuisine union all
select 'Greek' as SpecialCuisine, 'Greek/Mediterranean' as NetworkCuisine union all
select 'Indian' as SpecialCuisine, 'Indian' as NetworkCuisine union all
select 'Italian' as SpecialCuisine, 'Italian' as NetworkCuisine union all
select 'Japanese' as SpecialCuisine, 'Asian' as NetworkCuisine union all
select 'Korean' as SpecialCuisine, 'Asian' as NetworkCuisine union all
select 'Kosher' as SpecialCuisine, 'Theme/Specialty' as NetworkCuisine union all
select 'Latin American' as SpecialCuisine, 'Cuban/Latin' as NetworkCuisine union all
select 'Mediterranean' as SpecialCuisine, 'Greek/Mediterranean' as NetworkCuisine union all
select 'Mexican' as SpecialCuisine, 'Mexican' as NetworkCuisine union all
select 'Pizza' as SpecialCuisine, 'Pizza' as NetworkCuisine union all
select 'Ramen' as SpecialCuisine, 'Asian' as NetworkCuisine union all
select 'Seafood' as SpecialCuisine, 'Seafood' as NetworkCuisine union all
select 'Spanish' as SpecialCuisine, 'Cuban/Latin' as NetworkCuisine union all
select 'Steakhouse' as SpecialCuisine, 'Steakhouse' as NetworkCuisine union all
select 'Sushi' as SpecialCuisine, 'Sushi' as NetworkCuisine union all
select 'Thai' as SpecialCuisine, 'Asian' as NetworkCuisine union all
select 'Vegan / Vegetarian' as SpecialCuisine, 'Theme/Specialty' as NetworkCuisine 
)


, newFile as (
SELECT distinct 
	   ResSpecialSiteId 
      ,[Name]
      ,trim('"' from [description]) [description]
      ,FullAddress
	  ,LEFT(FullAddress, CHARINDEX(',', FullAddress) - 1) StreetAddress
      --,[street_address]
      --,[Billing City]
	  ,SUBSTRING(FullAddress, CHARINDEX(',', FullAddress) + 2, CHARINDEX(',', FullAddress, CHARINDEX(',', FullAddress) + 1) - CHARINDEX(',', FullAddress) - 2)  [BillingCity]
      ,Country
      --,[state_code]
	  ,left(right(FullAddress, 8),2) as StateCode
      --,[postal_code]
	  ,right(FullAddress,5) as postalcode
      ,[latitude]
      ,[longitude]
      ,[CuisineImageUrl]
      ,[LogoURL]
      --,[monday_oh]
      --,[tuesday_oh]
      --,[wednesday_oh]
      --,[thursday_oh]
      --,[friday_oh]
      --,[saturday_oh]
      --,[sunday_oh]
      --,[photo1]
      --,[photo2]
      --,[photo3]
      --,[photo4]
      --,[photo5]
      ,[menuurl]
      ,[reservationprovidername]
      ,[reservationproviderurl]
      ,[WebsiteUrl]
      ,[phonenumber]
      ,[primarycuisine]
      ,[AllowsReservations]
  FROM [Sandbox].ResSpecial.RestaurantLocations r
  where ResSpecialSiteId is not null
  and (StreetAddress is null
  or [BillingCity] is null
  or country is null
  or statecode is null
  or postalcode is null)
  and IsExcluded = 0
  --and TargetStartDate = @startDate
 )
 							 --SELECT FullAddress FROM [Sandbox].ResSpecial.RestaurantLocations
 -- 

 , newFile2 as (
SELECT distinct
	   ResSpecialSiteId
      ,[name]
      ,trim('"' from [description]) [description]
      ,[fulladdress]
	  --,LEFT([full_address], CHARINDEX(',', [full_address]) - 1) street_address_clean
      ,[streetaddress]
      ,[BillingCity]
	  --,SUBSTRING([full_address], CHARINDEX(',', [full_address]) + 2, CHARINDEX(',', [full_address], CHARINDEX(',', [full_address]) + 1) - CHARINDEX(',', [full_address]) - 2)  [Billing City Clean]
      ,[country]
      ,[statecode]
	  --,left(right(full_address, 8),2) as [state_code_cleaned]
      ,[postalcode]
	  --,right(full_address,5) as postal_code_cleaned
      ,[latitude]
      ,[longitude]
      ,[CuisineImageUrl]
      ,[LogoURL]
      --,[monday_oh]
      --,[tuesday_oh]
      --,[wednesday_oh]
      --,[thursday_oh]
      --,[friday_oh]
      --,[saturday_oh]
      --,[sunday_oh]
      --,[photo1]
      --,[photo2]
      --,[photo3]
      --,[photo4]
      --,[photo5]
      ,[menuurl]
      ,[reservationprovidername]
      ,[reservationproviderurl]
      ,[WebsiteUrl]
      ,[phonenumber]
      ,[primarycuisine]
      ,[AllowsReservations]
  FROM [Sandbox].ResSpecial.RestaurantLocations_2 r
  inner join (select distinct restaurant_id  from  sandbox.ResSpecial.restaurantsstaging) s on s.restaurant_id = r.ResSpecialSiteId 
  where ResSpecialSiteId is not null
  and IsExcluded = 0
  --and (r.streetaddress is not null
  --and  r.[BillingCity] is not null
  --and  r.country is not null
  --and  r.statecode is not null
  --and  r.postalcode is not null)


  --and IsExcluded = 0
  --and TargetStartDate = @startDate
 )

 , final_locs as (
 --select *
 --from newFile 
 --union all

 select *
 from newFile2
 )


 --select * ,len(CuisineImageUrl),len(LogoUrl),len(WebsiteUrl) -- max(len(CuisineImageUrl)), max(len(LogoUrl)),max(len(MenuUrl))
 --from final_locs
 --order by len(WebsiteUrl) desc

 , finList as (

 select ResSpecialSiteId restaurant_id , [name], description, fulladdress, streetaddress, [BillingCity], country, statecode, right(concat('0000', ltrim(rtrim(postalcode))),5) postalcode,
 latitude, longitude, [CuisineImageUrl] cuisine_image, [LogoURL] logo_url,
 --photo1, photo2, photo3, photo4, photo5, menu_url, 
 reservationprovidername, reservationproviderurl, case when  [WebsiteUrl] like '%https://www.google.com/search%' then null else WebsiteUrl end website, phonenumber, pr.NetworkCuisine as primary_cuisine, f.[primarycuisine],
 case when [AllowsReservations] = 'True' then 1 else 0 end as allows_reservations
 from final_locs f
 left join prCuisine pr on pr.SpecialCuisine = f.primarycuisine
 )

 , geo as (
 select distinct state as stateCode, StateFullName
 from Shared.Geography.ZipCodes

 )
 , prc as (
	 select *
 from Master.dbo.din_restaurant_cuisines
 where primary_type = 1
 --order by 2
 )

 
 , ffTT as (
 select 
 6325 as [Parent_ID],
 3907 [Restaurant_Group_ID],
 8705 as Billing_Group_id,
 '20240715_SMartin_20240709144712' as Contract_Id,
 'ResSpecial Restaurant Channel' as Owner_Legal_Entity,
 cuisine_image,
 logo_url,

 restaurant_id as ResSpecialLocationId, 
 ltrim(rtrim(name)) as Restaurant_Name, 
 ltrim(rtrim(name)) as _Name,
 ltrim(rtrim(streetaddress)) as [Address_1],
 dbo.initcap(ltrim(rtrim([BillingCity]))) [City], -- UDF
 g.StateFullName [State],
 ltrim(rtrim(postalcode)) [Zip],
 'United States' as [Country],
 ltrim(rtrim(description)) as [Web_Introdution_Paragraph],
 latitude,
 longitude,
 --phone_number as Phone,
 STUFF(STUFF(phonenumber, 4, 0, '-'), 8, 0, '-') Phone,
 1 as [Active_Partner],
 format(@startDate,'yyyy-MM-dd') [Start_Date_1],
 '2075-12-31' [OOB_Date],
 p.ID as [Primary_Cuisine_Type],
 1 as [Entity_Type],
 website [Website],
 allows_reservations as [Reservations_Accepted],
 reservationproviderurl [Reservations_Link]
 from finList f
 left join prc p on replace(p.Cuisine,'Breakfast/Brunch','Breakfast') = f.primary_cuisine
 left join geo g on g.stateCode = f.statecode
 )
 select *,
 concat('insert into Din_Restaurant_Locations_Primary (
 Parent_ID,	Restaurant_Group_ID,	ResSpecialLocationId,	Restaurant_Name,	_Name,	Address_1,	City,	State,	Zip,	Country,	Web_Introduction_Paragraph,	latitude,	longitude,	Phone,
 Active_Partner,	Start_Date_1,	OOB_Date,	Primary_Cuisine_Type,	Entity_Type,	Website,	Reservations_Accepted,	Reservations_Link, Contract_ID, Image, Cuisine_Image, 
 BillingGroupId, Owner_Legal_Entity, _Networks, Facebook_Link) select ',Parent_ID,',',Restaurant_Group_ID,
 
 ',',ResSpecialLocationId, ',''',	replace(Restaurant_Name,'''',''''''),''',''', replace(_Name,'''',''''''),''',''',	replace(Address_1,'''','''''')	,''',''',City,''',''',	State,''',''',	Zip	,''',''',
 Country	,''',''',replace(Web_Introdution_Paragraph,'''',''''''),''',''',	latitude
 ,''',''',longitude,''',''',	Phone	,''',''',
 Active_Partner,''',''',	format(@startDate,'yyyy-MM-dd') ,''',''',	OOB_Date,''',''',	Primary_Cuisine_Type,''',''',	Entity_Type,''',''',	isnull(Website,'null')	,''',''',Reservations_Accepted	,''',''',Reservations_Link,
 ''',''',Contract_Id,''',''',logo_url,''',''',cuisine_image,''',''',Billing_Group_id,''',''',Owner_Legal_Entity,''' ,''|2|1|3|'', null;'
 
 )
 from ffTT  -- relates to concat() function from 222

 -- beautified SQL and explanation 
 
 --This SQL script dynamically generates an INSERT INTO statement based on the data in the ffTT table. Let's break it down step by step:

 --2. The CONCAT Function:
 --Purpose: This part of the query uses the CONCAT function to construct an INSERT INTO statement dynamically. Each field from the ffTT table 
 --is concatenated into this string.
 
 --3. The Insert Statement Breakdown:
 --Purpose: This starts building the INSERT INTO statement for the Din_Restaurant_Locations_Primary table, listing all the columns that will 
 --be inserted.


 -- to quotes usage 
 -- explanation Replace() function replaces any single quotes within the Restaurant_Name value with double single quotes to escape them
 --Example: If Restaurant_Name is O'Reilly's, the replace function converts it to O''Reilly''s.
 --'''','''  This combination of quotes and commas ensures that the string value is correctly enclosed within single quotes and separated by commas. Example: Translates to ','
 SELECT *,
       Concat(
'insert into Din_Restaurant_Locations_Primary (  Parent_ID, Restaurant_Group_ID, 
ResSpecialLocationId, Restaurant_Name, _Name, Address_1, City, State, Zip, Country, 
Web_Introduction_Paragraph, latitude, longitude, Phone,  Active_Partner, Start_Date_1, 
OOB_Date, Primary_Cuisine_Type, Entity_Type, Website, Reservations_Accepted, Reservations_Link, 
Contract_ID, Image, Cuisine_Image,   BillingGroupId, Owner_Legal_Entity, _Networks, Facebook_Link)
select ',
-- 4. The Columns and Values:
--For each column, the corresponding value from the ffTT table is selected:
--Purpose:

--Each field from the ffTT table is included in the INSERT INTO statement.

--Special handling for strings: The REPLACE function is used to escape single quotes in string fields (e.g., Restaurant_Name, _Name, etc.).
--ISNULL function is used to handle null values in the Website field. Formatting: The format function is used to convert @startDate to the yyyy-MM-dd format.

parent_id, ',', restaurant_group_id, ',', ResSpeciallocationid, ',''', Replace(
restaurant_name, '''', ''''''), ''',''', Replace(_name, '''', ''''''),
''',''', Replace(address_1, '''', ''''''), ''',''', city, ''',''', state,
''',''', zip, ''',''', country, ''',''',
Replace(web_introdution_paragraph, '''', ''''''), ''',''', latitude, ''',''',
longitude, ''',''', phone, ''',''', active_partner, ''',''',
Format(@startDate, 'yyyy-MM-dd'), ''',''', oob_date, ''',''',
primary_cuisine_type, ''',''', entity_type, ''',''', Isnull(website, 'null'),
''',''', reservations_accepted, ''',''', reservations_link, ''',''', contract_id
, ''',''', logo_url, ''',''', cuisine_image, ''',''', billing_group_id, ''',''',
owner_legal_entity, ''' ,''|2|1|3|'', null;')
FROM   fftt 

--5. Example Output:
--An example of the dynamically generated SQL INSERT INTO statement might look like this:
insert into Din_Restaurant_Locations_Primary (
    Parent_ID, Restaurant_Group_ID, ResSpecialLocationId, Restaurant_Name, _Name, Address_1, City, State, Zip, Country, Web_Introduction_Paragraph, latitude, longitude, Phone,
    Active_Partner, Start_Date_1, OOB_Date, Primary_Cuisine_Type, Entity_Type, Website, Reservations_Accepted, Reservations_Link, Contract_ID, Image, Cuisine_Image,
    BillingGroupId, Owner_Legal_Entity, _Networks, Facebook_Link) 
select 12345, 'Restaurant Group', 67890, 'Restaurant''s Name', '''s Name', '123 Main St', 'City Name', 'ST', '12345', 'Country', 'Web Introduction', 12.345, 67.890, '123-456-7890',
1, '2024-12-01', '2025-01-01', 'Cuisine Type', 'Entity Type', 'https://website.com', '1', 'https://reservations.com', 'Contract123', 'https://logo.com', 'https://cuisine_image.com', 98765, 'Legal Entity', '|2|1|3|', null;
--6. Putting It All Together:
--The full query selects all fields from ffTT and constructs a dynamic INSERT INTO statement for each row in ffTT. This allows for batch processing of 
--insertions into the Din_Restaurant_Locations_Primary table based on the data from ffTT.

--Combined Usage in Dynamic SQL Generation:
--The overall goal is to construct a valid INSERT INTO statement with properly formatted values. Here's how the combination works in context:
--Plain Comma , is used for separating numerical values or column names. Quoted Commas ''',''' are used for enclosing and separating string values
--within the SQL syntax, ensuring that single quotes within string values are properly escaped (meaning, singe quotes are doubled). 
--This careful use of delimiters ensures the generated SQL statement is syntactically correct and handles both string and numerical values appropriately


 --select *
 --from Master.dbo.din_restaurant_cuisines
 --where primary_type = 1
 --order by 2


 --select *
 --from Master.dbo.Din_Restaurant_Types


-- , c2 as (
-- select case when s.RestaurantId is not null then 1 else 0 end as InFirstExport,
-- s.SalesForceId [ExistingOnFirstMatching_SalesForceId],
-- case when s.SalesForceId is null and a.LeadDetail is not null then 1 else 0 end [NonExistingAndImported],
-- a.LeadDetail,
-- isnull(a.Id,s.SalesForceId) as SalesForceId,
-- isnull(a.ParentId, sf.ParentAccountID) AS ParentId,
-- isnull(a.Type, sf.Type) as [Type],
-- n.*,
-- pr.NetworkCuisine
-- from newFile n
--left join dbo.ResSpecialRestaurantsListing s on s.restaurantid = n.[restaurant_id]
--left join Integrations.SalesForce.Accounts a on replace(a.LeadDetail,'ResSpecial_','') = cast(ltrim(rtrim(n.restaurant_id)) as varchar(25))
--left join prCuisine pr on pr.SpecialCuisine = n.primary_cuisine
--left join Integrations.SalesForce.SfSync sf on sf.AccountID collate latin1_general_cs_as = s.SalesForceId collate latin1_general_cs_as
--)

--select 
--c.InFirstExport	
--,c.ExistingOnFirstMatching_SalesForceId	
--,c.NonExistingAndImported	
--,c.LeadDetail	
--,c.SalesForceId	
--,c.ParentId
--,count(distinct sfP2.AccountId collate latin1_general_cs_as) as AccountsUnderParent
--,c.Type	
--,c.restaurant_id	
--,c.name	
--,c.description	
--,c.full_address	
--,c.street_address	
--,c.[Billing City]	
--,c.country	
--,c.state_code	
--,c.postal_code	
--,c.latitude	
--,c.longitude	
--,c.[Cuisine Image]
--,c.[Logo URL]	
--,c.monday_oh	
--,c.tuesday_oh	
--,c.wednesday_oh	
--,c.thursday_oh	
--,c.friday_oh	
--,c.saturday_oh	
--,c.sunday_oh	
--,c.photo1	
--,c.photo2	
--,c.photo3	
--,c.photo4	
--,c.photo5	
--,c.menu_url	
--,c.reservation_provider_name	
--,c.reservation_provider_url	
--,c.[Website Url]
--,c.phone_number	
--,c.[Allows Reservations]	
--,c.NetworkCuisine

--from c2 c
----left join Integrations.SalesForce.SfSync sfP on c.ParentId collate latin1_general_cs_as = sfP.AccountID collate latin1_general_cs_as
--left join Integrations.SalesForce.SfSync sfP2 on c.ParentId collate latin1_general_cs_as = sfP2.ParentAccountID collate latin1_general_cs_as

--group by c.InFirstExport	
--,c.ExistingOnFirstMatching_SalesForceId	
--,c.NonExistingAndImported	
--,c.LeadDetail	
--,c.SalesForceId	
--,c.ParentId	
--,c.Type	
--,c.restaurant_id	
--,c.name	
--,c.description	
--,c.full_address	
--,c.street_address	
--,c.[Billing City]	
--,c.country	
--,c.state_code	
--,c.postal_code	
--,c.latitude	
--,c.longitude	
--,c.[Cuisine Image]
--,c.[Logo URL]	
--,c.monday_oh	
--,c.tuesday_oh	
--,c.wednesday_oh	
--,c.thursday_oh	
--,c.friday_oh	
--,c.saturday_oh	
--,c.sunday_oh	
--,c.photo1	
--,c.photo2	
--,c.photo3	
--,c.photo4	
--,c.photo5	
--,c.menu_url	
--,c.reservation_provider_name	
--,c.reservation_provider_url	
--,c.[Website Url]
--,c.phone_number	
--,c.[Allows Reservations]	
--,c.NetworkCuisine
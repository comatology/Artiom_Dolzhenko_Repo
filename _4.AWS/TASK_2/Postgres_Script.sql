------------------------------------------------------------
---------------------V I E W  S C R I P T-------------------
------------------------------------------------------------

create table country (
country_name VARCHAR ( 50 ) NOT NULL, 
country_name_eng VARCHAR ( 50 ) NOT NULL, 
country_code VARCHAR ( 3 ) NOT NULL);
						
INSERT INTO country (country_name, country_name_eng, country_code) VALUES ('Deutschland', 'Germany', 'DEU');
INSERT INTO country (country_name, country_name_eng, country_code) VALUES ('Srbija', 'Serbia', 'SRB');
INSERT INTO country (country_name, country_name_eng, country_code) VALUES ('Hrvatska', 'Croatia', 'HRV');
INSERT INTO country (country_name, country_name_eng, country_code) VALUES ('United Stated of America', 'United Stated of America', 'USA');
INSERT INTO country (country_name, country_name_eng, country_code) VALUES ('Polska', 'Poland', 'POL');

CREATE OR REPLACE view countries_with_l as
select country_name, country_name_eng, country_code 
from public.country 
where country_name like '%l%';



------------------------------------------------------------
------------P R O C E D U R E   S C R I P T-----------------
------------------------------------------------------------


CREATE TABLE Product
(ProductID INT, ProductName VARCHAR(100) );


CREATE TABLE ProductDescription
(ProductID INT, ProductDescription VARCHAR(800) );


INSERT INTO Product VALUES (680,'HL Road Frame - Black, 58')
,(706,'HL Road Frame - Red, 58')
,(707,'Sport-100 Helmet, Red');
 
INSERT INTO ProductDescription VALUES (680,'Replacement mountain wheel for entry-level rider.')
,(706,'Sturdy alloy features a quick-release hub.')
,(707,'Aerodynamic rims for smooth riding.');



CREATE PROCEDURE GetProductDesc as 
BEGIN
SET NOCOUNT ON
SELECT P.ProductID,P.ProductName,PD.ProductDescription  
FROM Product P
INNER JOIN ProductDescription PD ON P.ProductID=PD.ProductID
end;
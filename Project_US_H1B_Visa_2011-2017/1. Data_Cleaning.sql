--Data Reviewing
select * from h1b_data;

--If we need, we can divide the data into different years in order to analyze it in details.
select distinct case_year
from h1b_data;

-- Try to find the unique value
SELECT *
FROM h1B_2011
ORDER BY soc_code ASC;	
-- It is not the unqiue value, can't be primary key. It is likely the data did not contain a unique value.

--It is better to drop columns we are not going to analyze first.
ALTER TABLE h1b_data
DROP COLUMN lat;

ALTER TABLE h1b_data
DROP COLUMN lng;

ALTER TABLE h1b_data
DROP COLUMN emp_h1b_dependent;

ALTER TABLE h1b_data
DROP COLUMN emp_willful_violator;

ALTER TABLE h1b_data
DROP COLUMN emp_country;

ALTER TABLE h1b_data
DROP COLUMN wage_unit;

ALTER TABLE h1b_data
DROP COLUMN pw_level;

ALTER TABLE h1b_data
DROP COLUMN pw_unit;

--We may want to get the processing time of each case.
ALTER TABLE h1b_data
ADD Processing_Time SMALLINT;

UPDATE h1b_data
SET Processing_Time = JULIANDAY(decision_date) - julianday(case_submitted);

--Generate an updated table the previous one may keep it as back up. This time, we will only analyze the cases which had been approved. 
CREATE TABLE h1b_data_2 as
	SELECT *
	FROM h1b_data
	WHERE (case_status='C' or case_status='CW') AND (full_time_position='Y' or full_time_position='NA');

-- We may want to classific the job industry, first let us see the top 30 job titles.

SELECT soc_name, COUNT(soc_name)
FROM h1b_data_2
GROUP BY soc_name
ORDER by COUNT(soc_name) DESC
LIMIT 30;

CREATE TABLE top_30_soc_name as
	SELECT soc_name, COUNT(soc_name)
FROM h1b_data_2
GROUP BY soc_name
ORDER by COUNT(soc_name) DESC
LIMIT 30;

ALTER TABLE h1b_data_2
ADD Industry TINYTEXT;

--We classific the job title according to Standard Industrial Classification (SIC) System.
UPDATE h1b_data_2
SET Industry = 'Information'
WHERE soc_name = 'COMPUTER SYSTEMS ANALYSTS' 
or soc_name = 'SOFTWARE DEVELOPERS, APPLICATIONS' 
or soc_name = 'COMPUTER PROGRAMMERS'
or soc_name = 'COMPUTER OCCUPATIONS, ALL OTHER'
or soc_name = 'SOFTWARE DEVELOPERS, SYSTEMS SOFTWARE'
or soc_name = 'NETWORK AND COMPUTER SYSTEMS ADMINISTRATORS'
or soc_name = 'DATABASE ADMINISTRATORS'
or soc_name = 'ELECTRONICS ENGINEERS, EXCEPT COMPUTER'
or soc_name = 'COMPUTER SOFTWARE ENGINEERS, APPLICATIONS'
or soc_name = 'COMPUTER AND INFORMATION SYSTEMS MANAGERS'
or soc_name = 'COMPUTER OCCUPATIONS, ALL OTHER*'
or soc_name = 'COMPUTER SYSTEMS ANALYST'
or soc_name = 'WEB DEVELOPERS' 
;

UPDATE h1b_data_2
SET Industry = 'Management of Companies and Enterprises'
WHERE soc_name = 'MANAGEMENT ANALYSTS' 
;

UPDATE h1b_data_2
SET Industry = 'Finance and Insurance'
WHERE soc_name = 'FINANCIAL ANALYSTS' 
or soc_name = 'ACCOUNTANTS AND AUDITORS' 
or soc_name = 'MARKETING MANAGERS'
;

UPDATE h1b_data_2
SET Industry = 'Professional, Scientific, and Technical Services'
WHERE soc_name = 'MECHANICAL ENGINEERS' 
or soc_name = 'OPERATIONS RESEARCH ANALYSTS' 
or soc_name = 'ELECTRICAL ENGINEERS'
or soc_name = 'MARKET RESEARCH ANALYSTS AND MARKETING SPECIALISTS'
or soc_name = 'BIOCHEMISTS AND BIOPHYSICISTS'
or soc_name = 'INDUSTRIAL ENGINEERS'
or soc_name = 'STATISTICIANS'
or soc_name = 'BIOLOGICAL SCIENTISTS, ALL OTHER'
or soc_name = 'CIVIL ENGINEERS'
;

UPDATE h1b_data_2
SET Industry = 'Health Care and Social Assistance'
WHERE soc_name = 'PHYSICIANS AND SURGEONS, ALL OTHER' 
or soc_name = 'MEDICAL SCIENTISTS, EXCEPT EPIDEMIOLOGISTS'
or soc_name = 'PHYSICAL THERAPISTS'
;

-- Start to divide Tables in different year 2011 - 2017
CREATE TABLE h1B_2011 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2011;
	
CREATE TABLE h1B_2012 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2012;
	
CREATE TABLE h1B_2013 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2013;

CREATE TABLE h1B_2014 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2014;
	
CREATE TABLE h1B_2015 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2015;
	
CREATE TABLE h1B_2016 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2016;
	
CREATE TABLE h1B_2017 as
	SELECT *
	from h1b_data_2
	WHERE case_year = 2017;
	
-- Since the data are clear enought, we can import it into tableau for data visualization.

--It is a project to pratice SQL skills. Trying to find the mean and the median of IT industry salary first amd see what kind of insight it brings

--Improt 2016_IT_Industry_Salary(Raw).csv as data base "NA_IT_Salary".
--Data Reviewing
SELECT * FROM NA_IT_Salary;

PRAGMA table_info(NA_IT_Salary);
/* 
pk = 0 which means PRIMARY KEY has not been set
The data type of index and salary_id is INTEGER, it is likely to set it as PRIMARY KEY
The data type of total_experience_years, employer_experience_years and annual_bonus is REAL(Floating Num)
The rest of data they are text.
*/

--Data Cleaning
/*Since we just want to know more about the salary range, as a result location latitude, location longitude, comments, and submitted_at not important during the analyzing. */
ALTER TABLE NA_IT_Salary 
DROP location_latitude;

ALTER TABLE NA_IT_Salary 
DROP location_longitude;

ALTER TABLE NA_IT_Salary 
DROP comments;

ALTER TABLE NA_IT_Salary 
DROP submitted_at;

SELECT * FROM NA_IT_Salary;
/*After reviewing the data again, we can find a lot of NULL values on TABLE(NA_IT_Salary)*/

SELECT count (*) FROM NA_IT_Salary
WHERE annual_base_pay is NULL;
/*We found that NULL exists in the annual_base_pay column.
Since we are aiming to analyze the salary of the industry, we need to clean the NULL data on annual_base_pay.
Before that, we need to find out how many rows with NULL values first. */

SELECT * FROM NA_IT_Salary
WHERE annual_base_pay is NULL;

/* We can locate 4 rows of null data, we need to delete all of them before analyzing. */
DELETE FROM NA_IT_Salary
WHERE annual_base_pay is NULL;

/* We have cleaned the null data set on annual_base_pay, we need to deal with the outstanding data as well.*/
SELECT * FROM NA_IT_Salary
ORDER BY annual_base_pay ASC
LIMIT 20;

/* We find out that the data contained multiple sources, and some of the respondents are self-employed. In that case, the annual payment would be flexible.
We need to remove this data however there is no specific way to finish the task. It would be better to narrow down our objective, focusing on data from the US first. */
DELETE FROM NA_IT_Salary
WHERE location_country is NOT 'US';

SELECT * FROM NA_IT_Salary
ORDER BY annual_base_pay ASC
LIMIT 20;

/* We can find some outstanding dates but we don't have an appropriate way to solve them, we will handle them with Python.  */
SELECT * FROM NA_IT_Salary
ORDER by annual_base_pay ASC;

/* We have 547 rows of data right now. */
SELECT count (salary_id) FROM NA_IT_Salary;

/* There are serval incomes that should be counted in order to generate the total income of an employee, not only annual base pay but also signing bonus and annual bonus.*/
UPDATE NA_IT_Salary
SET annual_base_pay= 0.0
WHERE annual_base_pay is NULL;

UPDATE NA_IT_Salary
SET signing_bonus = 0.0
WHERE signing_bonus is NULL;

UPDATE NA_IT_Salary
SET annual_bonus = 0.0
WHERE annual_bonus is NULL;

UPDATE NA_IT_Salary
SET Total_Income = annual_base_pay + signing_bonus + annual_bonus ;

--As I mentioned above, the table still needs a PRIMARY KEY and FOREIGN KEY in order to function.
--The unique value "salary_id" would be a sufficient item to define as a PRIMARY KEY.
ALTER TABLE NA_IT_Salary
Add primary KEY (salary_id);

--Double confirm the PRIMARY KEY
SHOW INDEX FROM NA_IT_Salary WHERE Key_name = 'PRIMARY';

/* We are going to analyze the data by using Python. */


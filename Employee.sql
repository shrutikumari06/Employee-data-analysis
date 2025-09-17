Use emp;
 -- count total employee
SELECT Count(*) FROM emp.`employee sample data(data clean)`;

-- avg salary--
SELECT 
    Department,
    COUNT(*) as employee_count,
    AVG(`Annual Salary`) as avg_salary,
    MIN(`Annual Salary`) as min_salary,
    MAX(`Annual Salary`) as max_salary
FROM emp.`employee sample data(data clean)`
GROUP BY Department
ORDER BY avg_salary DESC;

-- top 10 highest paid employee --
SELECT *
FROM (
    SELECT 
        EEID,
        `Full Name`,
        `Job Title`,
        Department,
        `Annual Salary`,
        RANK() OVER (ORDER BY `Annual Salary` asc) AS emp_rank
    FROM emp.`employee sample data(data clean)`
) AS ranked
WHERE emp_rank <= 10;

-- gender distribution by department--
select Gender,Department,count(*) as gender_cnt,
AVG(CAST(REPLACE(REPLACE(`Annual Salary`, '$', ''), ',', '') AS DECIMAL(10,2))) as avg_salary
from emp.`employee sample data(data clean)`
group by Gender,Department;

-- gender avg salary--
SELECT Department, `Annual Salary`, Gender
FROM emp.`employee sample data(data clean)`
WHERE Department IN ('Engineering', 'Sales')
LIMIT 10;

-- Convert salary to numeric and handle potential formatting issues
SELECT Gender, Department, 
       COUNT(*) as gender_cnt,
       AVG(CAST(REPLACE(REPLACE(`Annual Salary`, '$', ''), ',', '') AS DECIMAL(10,2))) as avg_salary
FROM emp.`employee sample data(data clean)`
WHERE `Annual Salary` IS NOT NULL 
  AND `Annual Salary` != ''
  AND `Annual Salary` != '0'
GROUP BY Gender, Department
ORDER BY Department, Gender;


-- age range--
select case 
     when Age < 30  then 'Under 30'
     when Age between  30 and 40 then '30- 40'
     when age between 41 and 50 then '41-50'
     when age between 51 and 60 then '51-60'
     when age>60 then 'over 60'
     end as age_group,
     COUNT(*) as employee_count,
    AVG(CAST(REPLACE(REPLACE(`Annual Salary`, '$', ''), ',', '') AS DECIMAL(10,2))) as avg_salary
FROM emp.`employee sample data(data clean)`
GROUP BY age_group
ORDER BY age_group;

-- Employee ranking by salary --

select * from (select EEID,`Full Name`,`Job Title`,Department,`Annual Salary`,
rank() over(order by `Annual Salary` asc) as emp_rank
from emp.`employee sample data(data clean)`)
as ranked;

-- employee ranking by hire date --
SELECT EEID, `Full Name`, Department, `Hire Date`, Age, Gender, `Job Title`,
       ROW_NUMBER() OVER (ORDER BY STR_TO_DATE(`Hire Date`, '%d-%m-%Y') DESC) AS hire_rank
FROM emp.`employee sample data(data clean)`
ORDER BY STR_TO_DATE(`Hire Date`, '%d-%m-%Y') DESC;

-- salary ranking acc to department -- 
select * from (select EEID,`Full Name`,Department,`Annual Salary`,
Rank() over(Partition by Department order by  `Annual Salary` asc) as emp_rank from
emp.`employee sample data(data clean)`) as ranked; 

-- partiton on gender basis--
SELECT EEID, `Full Name`, Gender, Department, `Annual Salary`,
       ROW_NUMBER() OVER (PARTITION BY Gender ORDER BY `Annual Salary` DESC) as gender_salary_rank
FROM emp.`employee sample data(data clean)`
ORDER BY Gender, gender_salary_rank;

-- job title wise experience ranking--
SELECT EEID, `Full Name`, Gender, Department,`Job Title`,Experience, `Annual Salary`,
       ROW_NUMBER() OVER (PARTITION BY `Job Title` ORDER BY Experience DESC) as job_exp
FROM emp.`employee sample data(data clean)`
ORDER BY `Job Title`,job_exp;


SELECT EEID,`Full Name`, Department,Age,`Annual Salary`,Gender,`Job Title`,
       ROW_NUMBER() OVER (ORDER BY `Annual Salary` asc) AS emp_row_no
FROM emp.`employee sample data(data clean)`;


-- 5th highest paid employee--

select * from ( SELECT EEID,`Full Name`, Department, `Annual Salary`,Age,Gender,`Job Title`,
       RANK() OVER(ORDER BY `Annual Salary` ASC) AS emp_rank 
FROM emp.`employee sample data(data clean)`) 
as ranked
WHERE emp_rank = 5;

-- 3rd highest paid employee acc each departmnet -- 
select* from( SELECT EEID,`Full Name`, Department, `Annual Salary`,Age,Gender,`Job Title`,
       RANK() OVER(PARTITION BY Department ORDER BY `Annual Salary` ASC) AS emp_rank 
FROM emp.`employee sample data(data clean)`)
as ranked
WHERE emp_rank = 3;

-- top 5 high paid employee in every departmnet--

select * from (select EEID,`Full Name`,Department,Gender,`Annual Salary`,
 Rank() over(partition by Department order by  `Annual Salary`asc)
as emp_rank 
from emp.`employee sample data(data clean)`) as ranked where emp_rank<=5;

-- age based ranking --

SELECT EEID, `Full Name`, Age, Department,
       RANK() OVER (ORDER BY Age DESC) as age_rank,
       DENSE_RANK() OVER (ORDER BY Age DESC) as age_dense_rank,
       COUNT(*) OVER (PARTITION BY Age) as same_age_count
FROM emp.`employee sample data(data clean)`
ORDER BY Age DESC;

-- LAG/LEAD Functions (Salary Gaps)
SELECT EEID, `Full Name`, Department, `Annual Salary`,
       LAG(`Annual Salary`) OVER (ORDER BY `Annual Salary` DESC) as higher_salary,
       `Annual Salary` - LAG(`Annual Salary`) OVER (ORDER BY `Annual Salary` DESC) as salary_gap
FROM emp.`employee sample data(data clean)`
ORDER BY `Annual Salary` DESC;

-- Running Totals and Moving Averages
SELECT EEID, `Full Name`, Department, `Annual Salary`,
       SUM(`Annual Salary`) OVER (ORDER BY EEID) as running_salary_total,
       AVG(`Annual Salary`) OVER (ORDER BY EEID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as moving_avg_3
FROM emp.`employee sample data(data clean)`
ORDER BY EEID;

-- Comprehensive Employee Analysis (Master Query)
SELECT EEID, `Full Name`, Department, `Annual Salary`, Age, Gender,
       RANK() OVER (ORDER BY `Annual Salary` DESC) as overall_rank,
       PERCENT_RANK() OVER (ORDER BY `Annual Salary`) * 100 as salary_percentile,
       AVG(`Annual Salary`) OVER (PARTITION BY Department) as dept_avg_salary,
       `Annual Salary` - AVG(`Annual Salary`) OVER (PARTITION BY Department) as vs_dept_avg
FROM emp.`employee sample data(data clean)`
ORDER BY `Annual Salary` DESC;






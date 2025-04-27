CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    email VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    performance_score INT,
    joining_date DATE
);

-- Insert Departments
INSERT INTO Departments VALUES
(1, 'Finance'),
(2, 'Marketing'),
(3, 'IT'),
(4, 'HR');

-- Insert Employees
INSERT INTO Employees VALUES
(101, 'Alice Johnson', 'alice.johnson@company.com', 1, 60000, 85, '2018-03-15'),
(102, 'Bob Smith', 'bob.smith@company.com', 1, 75000, 90, '2016-07-22'),
(103, 'Charlie Brown', 'charlie.brown@company.com', 2, 50000, 70, '2019-01-05'),
(104, 'David Wilson', 'david.wilson@company.com', 3, 80000, 88, '2015-11-10'),
(105, 'Eva Davis', 'eva.davis@company.com', 3, 95000, 95, '2014-04-25'),
(106, 'Frank Lee', 'frank.lee@company.com', 2, 55000, 65, '2020-08-30'),
(107, 'Grace Kim', 'grace.kim@company.com', 4, 45000, 72, '2021-02-14'),
(108, 'Hank Adams', 'hank.adams@company.com', 1, 70000, 78, '2017-06-18'),
(109, 'Ivy Clark', 'ivy.clark@company.com', 2, 52000, 68, '2019-09-12'),
(110, 'Jack Hill', 'jack.hill@company.com', 4, 47000, 74, '2022-01-20');



Question 1  Display all employee names in UPPERCASE.

SELECT UPPER(employee_name) AS employee_upper_name
FROM Employees;

Question 2 Extract first name from employee names.

SELECT employee_name,
       SUBSTRING(employee_name, 1, POSITION(' ' IN employee_name) - 1) AS first_name
FROM Employees;

Question 3 Extract domain name from email.

SELECT email,
       SUBSTRING(email FROM POSITION('@' IN email) + 1 FOR LENGTH(email)) AS email_domain
FROM Employees;


Question 4 Format joining_date to 'Month-Year'

SELECT employee_name,
       TO_CHAR(joining_date, 'Mon-YYYY') AS joining_month_year
FROM Employees;


Question 5 Categorize employees as 'High Performer' if score >80 else 'Needs Improvement'

SELECT employee_name, performance_score,
CASE
    WHEN performance_score > 80 THEN 'High Performer'
    ELSE 'Needs Improvement'
END AS performance_category
FROM Employees;


Question 6 Calculate total number of High Performers 

SELECT COUNT(CASE WHEN performance_score > 80 THEN 1 END) AS high_performer_count
FROM Employees;


Question 7 Find employees who joined before 2018.

SELECT employee_name, joining_date
FROM Employees
WHERE joining_date < '2018-01-01';

Question 8 Find maximum and minimum salary.

SELECT MAX(salary) AS highest_salary,
       MIN(salary) AS lowest_salary
FROM Employees;


Question 9 Find average salary department-wise.

SELECT d.department_name,
Round(AVG(e.salary),2) AS avg_department_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


Question 10 Show salary difference from department average.

SELECT employee_name, salary,
AVG(salary) OVER (PARTITION BY department_id) AS dept_avg_salary,
Round(salary - AVG(salary) OVER (PARTITION BY department_id),2) AS salary_diff
FROM Employees;


Question 11 Rank employees by salary 

SELECT employee_name, salary,
RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;


Question 12 Dense rank employees based on performance score.

SELECT employee_name, performance_score,
DENSE_RANK() OVER (ORDER BY performance_score DESC) AS perf_rank
FROM Employees;


Question 13 Assign row numbers based on joining date.

SELECT employee_name, joining_date,
ROW_NUMBER() OVER (ORDER BY joining_date) AS joining_row
FROM Employees;

Question 14 Show running total of salaries.

SELECT employee_name, salary,
SUM(salary) OVER (ORDER BY employee_id) AS running_salary_total
FROM Employees;


Question 15 Show cumulative performance score department-wise.

SELECT employee_name, department_id, performance_score,
SUM(performance_score) OVER (PARTITION BY department_id ORDER BY employee_id) AS dept_cum_perf
FROM Employees;


Question 16 Find previous and next salary.

SELECT employee_name, salary,
LAG(salary) OVER (ORDER BY salary DESC) AS previous_salary,
LEAD(salary) OVER (ORDER BY salary DESC) AS next_salary
FROM Employees;


Question 17 Find department-wise top 2 highest paid employees.

WITH RankedEmployees AS (
    SELECT employee_name, department_id, salary,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM Employees
)
SELECT employee_name, department_id, salary
FROM RankedEmployees
WHERE rn <= 2;


Question 18 Find each employee’s salary as a percentage of their department's total salary.

SELECT employee_name, department_id, salary,
       ROUND( (salary * 100.0) / SUM(salary) OVER (PARTITION BY department_id), 2) AS salary_percent_of_dept
FROM Employees;


Question 19  Find the second highest salary.

WITH SalaryRanks AS (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS sal_rank
    FROM Employees
)
SELECT salary
FROM SalaryRanks
WHERE sal_rank = 2;


Question 20 Find gap between each joining date and previous joining.

SELECT employee_name, joining_date,
       LAG(joining_date) OVER (ORDER BY joining_date) AS previous_joining_date,
       (joining_date - LAG(joining_date) OVER (ORDER BY joining_date)) AS days_gap
FROM Employees;










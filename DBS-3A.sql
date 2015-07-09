/* **************************************
*                                       *
*  DBS301                               * 
*  Chad Medeiros                        *
*  Created on: July 1, 2015             *
*  Last Modified: July 9, 2015          *
*                                       *
*************************************** */

/* Question 1. Find first earliest hiring date, latest hiring date, 
maximum salary among the employees that work only under department
20,40,50,60 and 90.                                               */

SELECT MIN(hire_date), MAX(hire_date), MAX(salary)
FROM employees 
WHERE department_id IN(20, 40, 50, 60, 90);
GROUP BY department_id;
ORDER BY department_id;
   
/* Question 2. Write a query that returns the department id and the 
number of employees (in the associated department) salary is over 
$2500 and, at the end, result page has to show only department ids
 that have more than 5 employees in it.                           */

SELECT department_id, COUNT(*) AS "Number of employees"
FROM employees
WHERE salary > 2500
HAVING COUNT(*) > 5
GROUP BY department_id;

/* Question 3. All employees with a JOB_ID of SA_REP, SA_MAN, IT_PROG
will receive a salary increase of $1,200 and their commission will 
be cut in half. List employee Id, first name, last name, job id, 
department id, new salary, and new commission for these employees. 
Display the new commission with two digits to the right of the 
decimal point. Use the column names NEW-SALARY and NEW-COMMISSION for
the generated columns. Your query will only display employees in 
department 60 and 80. Employees within department 80 should be listed
first. For employees with the same department, sort the list by 
salary.                                                            */

SELECT employee_id, first_name, last_name, job_id, department_id, TO_CHAR(salary + 1200.00, '9999999.99') as "NEW-SALARY", (commission_pct / 2) as "NEW-COMMISSION"
FROM employees
WHERE job_id IN('SA_REP', 'SA_MAN', 'IT_PROG') AND department_id IN(60, 80)
ORDER BY department_id DESC, salary;

/* Question 4. You are asked to prepare a list of employee 
anniversaries that occur between two days ago and seven days
from now. The list should retrieve rows from the EMPLOYEES 
table which include the EMPLOYEE_ID, FIRST_NAME, LAST_NAME, 
JOB_ID, and HIRE_DATE columns in ascending order based on the
day and month components of the HIRE_DATE value. An additional
expression aliased as ANNIVERSARY is required to return a 
descriptive message based on the following table. There are several
approaches to solving this question.                               */

SELECT employee_id, first_name, last_name, job_id, hire_date, 
 (CASE WHEN TO_CHAR(hire_date, 'DD-MM') =  TO_CHAR(SYSDATE - 2, 'DD-MM') THEN 'Day before yesterday'
       WHEN TO_CHAR(hire_date, 'DD-MM') =  TO_CHAR(SYSDATE - 1, 'DD-MM') THEN 'Yesterday'
       WHEN TO_CHAR(hire_date, 'DD-MM') =  TO_CHAR(SYSDATE, 'DD-MM') THEN 'Today'
       WHEN TO_CHAR(hire_date, 'DD-MM') =  TO_CHAR(SYSDATE + 1, 'DD-MM') THEN 'Tomorrow'
       WHEN TO_CHAR(hire_date, 'DD-MM') =  TO_CHAR(SYSDATE + 2, 'DD-MM') THEN 'Day after tomorrow'
       WHEN TO_NUMBER(TO_CHAR(hire_date, 'MMDD')) BETWEEN TO_NUMBER(TO_CHAR(SYSDATE - 2, 'MMDD')) AND TO_NUMBER(TO_CHAR(SYSDATE + 7, 'MMDD')) THEN 'Later this week'
  END) ANNIVERSARY
FROM employees
WHERE TO_NUMBER(TO_CHAR(hire_date, 'MMDD')) BETWEEN TO_NUMBER(TO_CHAR(SYSDATE - 2, 'MMDD')) AND TO_NUMBER(TO_CHAR(SYSDATE + 7, 'MMDD'))
AND (TO_NUMBER(TO_CHAR (SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR (hire_date, 'YYYY'))) > 0
ORDER BY hire_date ASC; 

/* Question 5. A customer requires a hard disk drive and a graphics
card for her personalcomputer. She is willing to spend between $500
and $800 on the disk drive but is unsure about the cost of a graphics
card. Her only requirement is that the resolution supported by the
graphics card should be either 1024×768 or 1280×1024. As the sales 
representative, you have been tasked to write one query that searches
the PRODUCT_INFORMATION table where the PRODUCT_NAME value begins 
with HD (hard disk) or GP (graphics processor) and their list prices. 
Remember the hard disk list prices must be between $500 and $800 and the 
graphics processors need to support either 1024×768 or 1280×1024.
Additional Requirements: Sort the results in descending LIST_PRICE order.
You should exclude records from PRODUCT_INFORMATION where PRODUCT_NAME
contains null value.                                               */

SELECT product_name, list_price, product_description 
FROM product_information 
WHERE product_name IN('GP 1024x768', 'GP 1280x1024') 
OR ((product_name LIKE 'HD %') AND list_price BETWEEN 500 AND 800)
AND product_name IS NOT NULL -- This seems redundant
ORDER BY list_price DESC;

/* Question 6. The PRODUCT_INFORMATION table lists items that are 
orderable and others that are planned, obsolete, or under development.
You are required to prepare a report that groups the non-orderable
products by their PRODUCT_STATUS and shows the number of products in
each group and the sum of the LIST_PRICE of the products per group. 
Further, only the group-level rows, where the sum of the LIST_PRICE 
is greater than 2000, must be displayed. A product is non-orderable 
if the PRODUCT_STATUS value is not equal to the string ‘orderable’. */

SELECT product_status, COUNT(*) AS "Number of Products", SUM(list_price) AS "Total Price"
FROM product_information
WHERE product_status != 'orderable'
GROUP BY product_status
HAVING SUM(list_price) > 2000;

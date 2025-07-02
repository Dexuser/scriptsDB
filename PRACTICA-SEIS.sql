
// TEMA 1: 

create table dept2(
    id number(12),
    name varchar2(80)
);


INSERT INTO dept2 SELECT department_id, department_name FROM departments
WHERE department_id BETWEEN 10 AND 90;


CREATE TABLE emp2 (
    id NUMBER(12),
    last_name VARCHAR2(30),
    first_name VARCHAR2(20),
    dept_id NUMBER(12)
);

ALTER TABLE emp2 modify last_name varchar2(40);
desc emp2;




// TEMA 2: Sub-Consultas

select e.last_name,
    e.department_id, 
    e.salary 
from employees e
where (e.department_id, e.salary) in 
    (select department_id, salary from employees where commission_pct is not null);
    
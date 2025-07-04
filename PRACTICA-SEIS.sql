
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


create table employee2 (
    id number(12),
    first_name varchar2(20),
    last_name varchar(40),
    salary number(10,2),
    dept_id number(12)
);

insert into employee2 (
    select employee_id, first_name, last_name, salary, department_id
    from employees
    );

drop table emp2;

select original_name, operation, droptime from recyclebin;

flashback table emp2 to before drop;




    
// TEMA 2: Sub-Consultas

select e.last_name,
    e.department_id, 
    e.salary 
from employees e
where (e.department_id, e.salary) in 
    (select department_id, salary from employees where commission_pct is not null);
    

    
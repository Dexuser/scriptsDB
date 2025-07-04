
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

desc recyclebin;

flashback table emp2 to before drop;



DESC employee2;
ALTER TABLE employee2 DROP COLUMN first_name;
DESC employee2;



ALTER TABLE employee2 SET UNUSED COLUMN dept_id;
DESC employee2;


ALTER TABLE employee2 DROP UNUSED COLUMNS;
DESC employee2;



ALTER TABLE emp2
    ADD CONSTRAINT my_emp_id_pk
    PRIMARY KEY(id);
desc emp2;
    


ALTER TABLE dept2
    ADD CONSTRAINT my_dept_id_pk
    PRIMARY KEY(ID);
DESC dept2;



ALTER TABLE emp2
    ADD CONSTRAINT my_emp_dept_id_fk
    FOREIGN KEY(dept_id)
    REFERENCES departments(department_id);
DESC emp2;


SELECT OBJECT_TYPE, OBJECT_NAME
FROM USER_OBJECTS
WHERE OBJECT_NAME IN ('EMP2', 'DEPT2');



ALTER TABLE emp2 ADD (
    commission number(2,2),
    CONSTRAINT emp2_commission_CK check(commission > 0)
);
    
DROP TABLE emp2 PURGE;
DROP TABLE dept2 PURGE;





CREATE TABLE DEPT_NAMED_INDEX (
  Deptno NUMBER(12),
  Dname VARCHAR2(30),
  CONSTRAINT DEPT_NAMED_INDEX_Deptno_PK PRIMARY KEY (Deptno)
      USING INDEX (
        CREATE INDEX DEPT_PK_IDX ON DEPT_NAMED_INDEX (Deptno)
      )
);





SELECT * FROM RECYCLEBIN;
    
    
    
    
// TEMA 2: Sub-Consultas

SELECT E.last_name,
    E.department_id, 
    E.salary 
FROM employees E
WHERE (E.department_id, E.salary) IN 
    (SELECT department_id, salary FROM employees WHERE commission_pct IS NOT NULL);
    
    
    
// La consulta no obtiene registros debido a que la subconsulta 
// recupera valores NULLs
SELECT 
    E.last_name, 
    D.department_name, 
    E.salary 
FROM departments D 
JOIN employees E ON D.department_id = E.department_id
WHERE (E.salary, E.commission_pct) IN (
    
    SELECT  E.salary, E.commission_pct
    FROM locations L
    JOIN departments D ON L.location_id = D.location_id
    JOIN employees E ON E.department_id = D.department_id
    WHERE L.location_id = 1700
    )
    ORDER BY salary;
    
    
    
// No hay empleados trabajando en un departamento que comience con L
SELECT 
    E.employee_id,
    E.last_name,
    D.department_name
FROM departments D 
JOIN employees E ON D.department_id = E.department_id
WHERE D.department_name IN
    (SELECT department_name FROM departments WHERE department_name LIKE 'L%');
    
    
    
    
    
    
    
    
    

SELECT 
    E.last_name,
    E.department_id, 
    E.salary,
    (
        SELECT ROUND(AVG(e2.salary), 2)
        FROM employees e2
        WHERE e2.department_id = E.department_id
    ) AS dept_avg_salary
FROM employees E
JOIN departments D ON E.department_id = D.department_id
WHERE E.salary > (
        SELECT AVG(e3.salary)
        FROM employees e3
        WHERE e3.department_id = E.department_id
) ORDER BY dept_avg_salary;





SELECT E.last_name FROM employees E WHERE EXISTS (
        SELECT 'x' FROM employees
        WHERE hire_date > E.hire_date AND
        salary > E.salary
        );









    with summary as (
        select e.department_id, sum(e.salary) as dept_cost
        from employees e group by e.department_id
    )
    select 
        department_name, 
        dept_cost 
        from departments d 
        join summary s on d.department_id = s.department_id
        where dept_cost > (
                        select sum(salary)/4 from employees
                        );
    



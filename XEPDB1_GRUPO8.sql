// luis
CREATE TABLE destino_final(
    id NUMBER CONSTRAINT destino_id_PK PRIMARY KEY,
    nombre VARCHAR2(30) CONSTRAINT destino_nombre_NN NOT NULL,
    tipo VARCHAR2(30) CONSTRAINT destino_tipo_NN NOT NULL,
    latitud DECIMAL(8,6) CONSTRAINT destino_latitud_NN NOT NULL,
    longitud DECIMAL(9,6) CONSTRAINT destino_longitud_NN NOT NULL,
    CONSTRAINT destino_tipo_CK CHECK(tipo IN ('Planta recolectora', 'Punto de transferencia', 'Basudero'))
);

CREATE SEQUENCE destino_id_SEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE zonas (
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(30) CONSTRAINT zonas_nombre_NN NOT NULL,
    CONSTRAINT zonas_id_PK PRIMARY KEY (id)
);

CREATE TABLE rutas(
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(30) CONSTRAINT rutas_nombre_NN NOT NULL,
    id_zona NUMBER CONSTRAINT rutas_zona_FK REFERENCES zonas(id),
    id_destino_final CONSTRAINT rutas_destino_FK REFERENCES destino_final(id),
    CONSTRAINT rutas_id_PK PRIMARY KEY (id)
);




// kevin
CREATE TABLE sensores(
    serial NUMBER CONSTRAINT sensores_serial_PK PRIMARY KEY,
    marca VARCHAR(50) CONSTRAINT sensores_marca_NN NOT NULL
);

CREATE TABLE tipo_residuo(
    id NUMBER CONSTRAINT tipo_residuo_id_PK PRIMARY KEY,
    descripcion VARCHAR(255) CONSTRAINT tipo_residuo_descripcion_NN NOT NULL
);

CREATE SEQUENCE tipo_residuo_id_SEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE ubicacion_contenedores(
    id NUMBER CONSTRAINT ubi_cont_id_PK PRIMARY KEY,
    latitud DECIMAL(8,6),
    longitud DECIMAL(9,6),
    descripcion VARCHAR2(255) CONSTRAINT ubi_cont_NN NOT NULL,
    id_zona NUMBER CONSTRAINT ubi_cont_zona REFERENCES zonas(id)
);

CREATE SEQUENCE ubi_cont_id_SEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE contenedores(
    id NUMBER  GENERATED ALWAYS AS IDENTITY,
    estado VARCHAR2(40) CONSTRAINT contenedores_estado_NN NOT NULL,
    capacidad_kg NUMBER CONSTRAINT contenedores_capacidad_NN NOT NULL,
    ultimo_mantenimiento DATE,
    id_ubicacion NUMBER,
    id_tipo_residuo NUMBER,
    CONSTRAINT contenedores_id_PK PRIMARY KEY (id),
    CONSTRAINT contenedores_ubicacion_FK FOREIGN KEY (id_ubicacion) REFERENCES ubicacion_contenedores(id),
    CONSTRAINT contenedores_tipo_residuo_FK FOREIGN KEY(id_tipo_residuo) REFERENCES tipo_residuo(id),
    CONSTRAINT contenedores_estado_CK
    CHECK(estado IN('nuevo', 'en uso', 'lleno', 'vacio', 'dañado', 'perdido', 'fuera de servicio'))
);






// Leam
// tablas creadas y constraints que creia pertinentes para cada una
create table puestos(
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    descripcion varchar2(255) CONSTRAINT puestos_descripcion_NN NOT NULL,
    CONSTRAINT puestos_id_PK PRIMARY KEY (id)
);
    
CREATE TABLE empleados(
    id NUMBER GENERATED ALWAYS AS IDENTITY, 
    nombre VARCHAR2(40) CONSTRAINT empleados_nombre_NN NOT NULL,
    apellido VARCHAR2(40) CONSTRAINT empleados_apellido_NN NOT NULL,
    cedula VARCHAR2(40) CONSTRAINT empleados_cedula_NN NOT NULL,
    fecha_liquidacion DATE,
    email VARCHAR2(60),
    fecha_nacimiento DATE CONSTRAINT empleados_fecha_nacimiento_NN NOT NULL,
    fecha_contratacion DATE CONSTRAINT empleados_fecha_contratacion_NN NOT NULL,
    id_puesto NUMBER CONSTRAINT empleados_puesto_NN NOT NULL,
    CONSTRAINT empleados_id_pk PRIMARY KEY (id),
    CONSTRAINT empleados_puesto_FK FOREIGN KEY (id_puesto) REFERENCES puestos(id),
    CONSTRAINT empleados_cedula_UNQ UNIQUE (cedula),
    CONSTRAINT empleados_email_CK CHECK (email LIKE '%@%')
);



create table vehiculos(
    matricula VARCHAR2(40) CONSTRAINT vehiculos_matricula_PK PRIMARY KEY,
    marca VARCHAR2(40),
    tipo_vehiculo VARCHAR2(40),
    capacidad_kg DECIMAL(8,2) CONSTRAINT vehiculos_capacidad_NN NOT NULL,
    id_empleado NUMBER,
    CONSTRAINT fk_empleados_vehiculos FOREIGN KEY (id_empleado)
    REFERENCES empleados(id)
);




CREATE TABLE horarios_recoleccion (
    id NUMBER ,
    dia VARCHAR2(15) CONSTRAINT recoleccion_dia_NN NOT NULL,
    hora_inicio TIMESTAMP CONSTRAINT recoleccion_hora_inicio_NN NOT NULL,
    hora_salida TIMESTAMP CONSTRAINT recoleccion_hora_fin_NN NOT NULL,
    id_empleado NUMBER CONSTRAINT recoleccion_empleado_NN NOT NULL,
    id_ruta NUMBER,
    
    CONSTRAINT horarios_id_PK PRIMARY KEY (id),
    
    CONSTRAINT ck_dias CHECK (dia IN (
        'lunes', 'martes', 'miercoles', 'jueves','viernes', 'sabado', 'domingo')),
    
    CONSTRAINT horariosr_empleados_FK FOREIGN KEY (id_empleado)
        REFERENCES empleados(id),
    
    CONSTRAINT horariosr_ruta_FK FOREIGN KEY (id_ruta)
        REFERENCES rutas(id)
);

commit;

create sequence horarios_recoleccion_id_SEQ start with 1 increment by 1;



// Hyun
CREATE TABLE usuarios (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario varchar2(30) CONSTRAINT usuarios_usuario_NN NOT NULL,
    contrasena varchar(30) CONSTRAINT usuarios_contrasena_NN NOT NULL,
    id_empleado NUMBER CONSTRAINT usuarios_empleado_FK REFERENCES empleados(id)
);

CREATE TABLE reportes_empleados (
    id NUMBER CONSTRAINT reportes_empleados_PK PRIMARY KEY,
    texto VARCHAR2(2000) CONSTRAINT usuarios_texto_NN NOT NULL,
    fecha DATE CONSTRAINT usuarios_fecha_NN NOT NULL,
    id_usuario CONSTRAINT reportes_usuarios_FK REFERENCES usuarios(id)
);

CREATE SEQUENCE reportes_empleados_id_SEQ START WITH 1 INCREMENT BY 1;

CREATE TABLE residentes(
    cedula VARCHAR2(30) CONSTRAINT residentes_cedula_PK PRIMARY KEY,
    nombre VARCHAR2(20) CONSTRAINT residentes_nombre_NN NOT NULL,
    apellido VARCHAR2(20) CONSTRAINT residentes_apellido_NN NOT NULL,
    telefono VARCHAR2(20) CONSTRAINT residentes_telefono_NN NOT NULL,
    email VARCHAR2(50) CONSTRAINT residentes_email_NN NOT NULL,
    codigo_postal VARCHAR2(10) CONSTRAINT usuarios_postal_NN NOT NULL,
    CONSTRAINT residentes_email_CK CHECK(email like '%@%')
);

CREATE TABLE reportes_residentes (
    id NUMBER GENERATED ALWAYS AS IDENTITY ,
    texto VARCHAR2(2000) CONSTRAINT reporte_residente_texto_NN NOT NULL,
    fecha DATE CONSTRAINT reporte_residente_fecha_NN NOT NULL,
    id_residente VARCHAR2(20) CONSTRAINT reporte_residente_FK 
    REFERENCES residentes(cedula),
    
    CONSTRAINT reportes_residentes_PK PRIMARY KEY (id)
);


// tablas intermedias (M : N)
// Luis
CREATE TABLE rutas_contenedores_ubicaciones(
    id_ruta NUMBER,
    id_ubi_cont NUMBER,
    CONSTRAINT RCU_PK PRIMARY KEY(id_ruta, id_ubi_cont),
    CONSTRAINT RCU_rutas_FK FOREIGN KEY (id_ruta) REFERENCES rutas(id),
    CONSTRAINT RCU_ubi_cont_FK FOREIGN KEY (id_ubi_cont) REFERENCES ubicacion_contenedores(id)
);


// PRACTICA 3. MANIPULACION DE OBJETOS MEDIANTE SQL


// Luis
INSERT INTO destino_final(id, nombre, tipo, latitud, longitud) VALUES
( destino_id_SEQ.NEXTVAL, 'Bsdro. la tita', 'Basudero', 38.234567, 212.345689);

INSERT INTO destino_final(id, nombre, tipo, latitud, longitud) VALUES
(destino_id_SEQ.NEXTVAL,'Rclect. Gutierrez', 'Planta recolectora', 18.346718, 530.345682);

INSERT INTO destino_final(id, nombre, tipo, latitud, longitud) VALUES
(destino_id_SEQ.NEXTVAL,'transf. la estrella', 'Punto de transferencia', 48.234612, 100.3468);

INSERT INTO destino_final(id, nombre, tipo, latitud, longitud) VALUES
(destino_id_SEQ.NEXTVAL,'transf. de cancela', 'Punto de transferencia', 38.234567, 212.34568);

INSERT INTO destino_final(id, nombre, tipo, latitud, longitud) VALUES
(destino_id_SEQ.NEXTVAL,'Bsdro. de Cancela', 'Basudero', 23.45679, 453.4568);


INSERT INTO zonas (nombre) VALUES
('La ureña');

INSERT INTO zonas (nombre) VALUES
('los alcarrizos');

INSERT INTO zonas (nombre) VALUES
('Las Americas');

INSERT INTO zonas (nombre) VALUES
('La Caleta');

INSERT INTO zonas (nombre) VALUES
('Mendoza');


INSERT INTO RUTAS (nombre, id_zona, id_destino_final) VALUES
('Ruta de la tita', 1, 1);

INSERT INTO RUTAS (nombre, id_zona, id_destino_final) VALUES
('Ruta hasta Gutierrez', 1, 2);

INSERT INTO RUTAS (nombre, id_zona, id_destino_final) VALUES
('Ruta de la estrella', 1, 3);

INSERT INTO RUTAS (nombre, id_zona, id_destino_final) VALUES
('Ruta de Cancela', 1, 4);

INSERT INTO RUTAS (nombre, id_zona, id_destino_final) VALUES
('Ruta de la tita', 1, 5);

commit;

SELECT * FROM destino_final ORDER BY ID DESC;
SELECT * FROM rutas ORDER BY ID_DESTINO_FINAL;
SELECT * FROM zonas ORDER BY ID ASC;

UPDATE rutas SET id_destino_final = 5 WHERE id = 1;
UPDATE rutas SET id_destino_final = 4 WHERE id = 3;
UPDATE rutas SET id_destino_final = 3 WHERE id = 4;

commit;

DELETE rutas WHERE id = 6;
DELETE rutas WHERE id = 5;
DELETE rutas WHERE id = 4;

commit;



// Leam
insert into puestos (descripcion) values ('operador');
insert into puestos (descripcion) values ('recolector');
insert into puestos (descripcion) values ('supervisor');
insert into puestos (descripcion) values ('clasificador de residuos');
insert into puestos (descripcion) values ('gerente');
commit;

insert into empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) values ('Carlos', 'Almonte Villanueva', '001-0000001-1', null,
'carlos@gmail.com', to_date('21-03-1985', 'DD-MM-YYYY'), to_date('12-03-2009', 'DD-MM-YYYY'), 1);

insert into empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) values ('Luis', 'Santana Peralta', '001-1285166-2', null,
'Luissantan@gmail.com', to_date('11-09-1998', 'DD-MM-YYYY'), to_date('08-05-2011', 'DD-MM-YYYY'), 2);

insert into empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) values ('Mariano', 'Rivera Gonzalez', '402-2805132-8', null,
null, to_date('27-02-1980', 'DD-MM-YYYY'), to_date('07-03-2002', 'DD-MM-YYYY'), 4);

insert into empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) values ('Robert', 'Pascual Ariza', '402-3779206-0', null,
'licrpascual@gmail.com', to_date('11-08-1965', 'DD-MM-YYYY'), to_date('11-03-2001', 'DD-MM-YYYY'), 5);

insert into empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) values ('Maria Lucia', 'Holguin Rodriguez', '402-2502119-1', null,
'marialuc@gmail.com', to_date('21-03-1986', 'DD-MM-YYYY'), to_date('12-03-2010', 'DD-MM-YYYY'), 3);

commit;


insert into vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
values('E104237', 'Heil','Camion volqueta', 15000.00, 1 );

insert into vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
values('E096601', 'McNeilus','Camion compactador', 12500.00, 2 );

insert into vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
values('E089332', 'Roger','Camion compactador', 12500.00, null );

insert into vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
values('E089547', 'Isuzu','Camion doble compactador', 14000.00, null );

insert into vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
values('E087765', 'Mitsubishi','Camion volqueta', 15000.00, null );

commit;


insert into horarios_recoleccion (id,dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) values (horarios_recoleccion_id_SEQ.nextval, 'lunes', to_timestamp('02-06-2025 5:30:00','DD-MM-YYYY HH24:MI:SS')
,to_timestamp('02-06-2025 8:30:00','DD-MM-YYYY HH24:MI:SS'),1,1);

insert into horarios_recoleccion (id,dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) values (horarios_recoleccion_id_SEQ.nextval, 'lunes', to_timestamp('02-06-2025 1:00:00', 'DD-MM-YYYY HH24:MI:SS')
,to_timestamp('02-06-2025 4:00:00','DD-MM-YYYY HH24:MI:SS' ),1,2);

insert into horarios_recoleccion (id,dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) values (horarios_recoleccion_id_SEQ.nextval, 'martes', to_timestamp('03-06-2025 2:00:00','DD-MM-YYYY HH24:MI:SS')
,to_timestamp('03-06-2025 5:00:00','DD-MM-YYYY HH24:MI:SS'),2,3);

insert into horarios_recoleccion (id, dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) values (horarios_recoleccion_id_SEQ.nextval, 'miercoles', to_timestamp('04-06-2025 2:00:00','DD-MM-YYYY HH24:MI:SS')
,to_timestamp('04-06-2025 5:00:00','DD-MM-YYYY HH24:MI:SS'),1,2);

insert into horarios_recoleccion (id, dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) values (horarios_recoleccion_id_SEQ.nextval, 'jueves', to_timestamp('05-06-2025 7:00:00','DD-MM-YYYY HH24:MI:SS')
,to_timestamp('05-06-2025 10:00:00','DD-MM-YYYY HH24:MI:SS' ),2,1);

commit;


select * from empleados
order by nombre asc;

select * from vehiculos
order by capacidad_kg asc;

update empleados set cedula = '001-0000001-1'
where id = 1;

update empleados set cedula = '001-1285166-2'
where id = 2;

update empleados set cedula = '402-2805132-8'
where id = 3;

update empleados set cedula = '402-3779206-0'
where id = 4;

update empleados set cedula = '402-2502119-1'
where id = 5;

update empleados set id_puesto = 1
where id = 2;

commit;


delete from horarios_recoleccion where id = 2;
delete from horarios_recoleccion where id = 4;
delete from horarios_recoleccion where id = 5;

commit;



//Kevyn
INSERT INTO residentes (cedula, nombre, apellido, telefono, email, codigo_postal)
VALUES ('001-1234567-8', 'Pedro', 'Martínez', '8091234567', 'pedro.martinez@email.com', '10101');

INSERT INTO residentes (cedula, nombre, apellido, telefono, email, codigo_postal)
VALUES ('002-7654321-3', 'Juana', 'Pérez', '8297654321', 'juana.perez@email.com', '10202');

INSERT INTO residentes (cedula, nombre, apellido, telefono, email, codigo_postal)
VALUES ('003-1112233-7', 'Carlos', 'Gómez', '8491112233', 'carlos.gomez@email.com', '10303');

INSERT INTO residentes (cedula, nombre, apellido, telefono, email, codigo_postal)
VALUES ('004-9998888-1', 'Lucía', 'Fernández', '8099998888', 'lucia.fernandez@email.com', '10404');

INSERT INTO residentes (cedula, nombre, apellido, telefono, email, codigo_postal)
VALUES ('005-5556666-4', 'José', 'Ramírez', '8295556666', 'jose.ramirez@email.com', '10505');

COMMIT;

INSERT INTO reportes_residentes (texto, fecha, id_residente) VALUES
('Reporte de ruido excesivo durante la noche', TO_DATE('2025-06-01', 'YYYY-MM-DD'), '001-1234567-8');

INSERT INTO reportes_residentes (texto, fecha, id_residente) VALUES
('Queja por mal estado del parque cercano', TO_DATE('2025-06-02', 'YYYY-MM-DD'), '002-7654321-3');

INSERT INTO reportes_residentes (texto, fecha, id_residente) VALUES
('Solicitud de reparación de alumbrado público', TO_DATE('2025-06-03', 'YYYY-MM-DD'), '003-1112233-7');

INSERT INTO reportes_residentes (texto, fecha, id_residente) VALUES
('Reporte de basura acumulada en la vía', TO_DATE('2025-06-04', 'YYYY-MM-DD'), '004-9998888-1');

INSERT INTO reportes_residentes (texto, fecha, id_residente) VALUES
('Problemas con el suministro de agua', TO_DATE('2025-06-05', 'YYYY-MM-DD'), '005-5556666-4');

COMMIT;

INSERT INTO ubicacion_contenedores (id, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_SEQ.NEXTVAL, 18.4750, -69.8900, 'Contenedor frente al parque Independencia', 1);

INSERT INTO ubicacion_contenedores (id, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_SEQ.NEXTVAL, 19.4501, -70.6944, 'Contenedor en la esquina de la Calle del Sol', 2);

INSERT INTO ubicacion_contenedores (id, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_SEQ.NEXTVAL, 19.2205, -70.5305, 'Contenedor cerca del mercado de La Vega', 3);

INSERT INTO ubicacion_contenedores (id, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_SEQ.NEXTVAL, 18.5671, -68.3671, 'Contenedor en la entrada de Punta Cana Village', 4);

INSERT INTO ubicacion_contenedores (id, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_SEQ.NEXTVAL, 19.7951, -70.6899, 'Contenedor próximo al malecón de Puerto Plata', 5);


COMMIT;

SELECT * FROM RESIDENTES;
SELECT * FROM REPORTES_RESIDENTES;
SELECT * FROM ubicacion_contenedores;

COMMIT;

UPDATE ubicacion_contenedores
SET descripcion = 'Contenedor detrás del parque Independencia'
WHERE id = 1;

UPDATE ubicacion_contenedores
SET latitud = 19.4505, longitud = -70.6955
WHERE id = 2;

UPDATE ubicacion_contenedores
SET descripcion = 'Contenedor removido temporalmente por mantenimiento'
WHERE id = 5;

COMMIT;

DELETE FROM reportes_residentes
WHERE texto = 'Reporte de ruido excesivo durante la noche';

DELETE FROM reportes_residentes
WHERE texto = 'Queja por mal estado del parque cercano';

DELETE FROM reportes_residentes
WHERE texto = 'Solicitud de reparación de alumbrado público';

commit;


// kevin

CREATE SEQUENCE sq_mrGarcia 
START WITH 1
INCREMENT BY 1;



/*HACER 5 INSERCIONES POR CADA TABLA CREADA*/
INSERT INTO sensores (serial, marca) VALUES (5081781, 'EcoSense');
INSERT INTO sensores (serial, marca) VALUES (1444044, 'GreenTrack');
INSERT INTO sensores (serial, marca) VALUES (2589416, 'WasteWatch');
INSERT INTO sensores (serial, marca) VALUES (8915568, 'CleanScan');
INSERT INTO sensores (serial, marca) VALUES (8469470, 'BinSmart');


INSERT INTO tipo_residuo (id, descripcion) VALUES (sq_mrgarcia.nextval, 'Organico');
INSERT INTO tipo_residuo (id, descripcion) VALUES (sq_mrgarcia.nextval, 'vidrio');
INSERT INTO tipo_residuo (id, descripcion) VALUES (sq_mrgarcia.nextval, 'plastico');
INSERT INTO tipo_residuo (id, descripcion) VALUES (sq_mrgarcia.nextval, 'papel');
INSERT INTO tipo_residuo (id, descripcion) VALUES (sq_mrgarcia.nextval, 'carton');









INSERT INTO contenedores(estado, capacidad_kg, ultimo_mantenimiento, id_ubicacion, id_tipo_residuo)
VALUES('nuevo', 100, TO_DATE('2025-05-12', 'YYYY-MM-DD'), 1, 3);

INSERT INTO contenedores(estado, capacidad_kg, ultimo_mantenimiento, id_ubicacion, id_tipo_residuo)
VALUES('en uso', 180, TO_DATE('2022-11-09', 'YYYY-MM-DD'), 2, 4);

INSERT INTO contenedores(estado, capacidad_kg, ultimo_mantenimiento, id_ubicacion, id_tipo_residuo) 
VALUES('fuera de servicio', 120, TO_DATE('2019-04-22', 'YYYY-MM-DD'), 3, 3);

INSERT INTO contenedores(estado, capacidad_kg, ultimo_mantenimiento, id_ubicacion, id_tipo_residuo) 
VALUES('nuevo', 200, TO_DATE('2025-05-01', 'YYYY-MM-DD'), 4, 1);

INSERT INTO contenedores(estado, capacidad_kg, ultimo_mantenimiento, id_ubicacion, id_tipo_residuo)
VALUES('dañado', 130, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 5, 4);



// selects

SELECT * FROM contenedores ORDER BY ultimo_mantenimiento;
SELECT * FROM sensores ORDER BY serial;
SELECT * FROM ubicacion_contenedores;


// updates

UPDATE contenedores SET capacidad_kg = 130 WHERE id_contenedor = 1;
UPDATE ubicacion_contenedores SET Descripcion = 'Residencial Los Almirantes' WHERE descripcion = 'Residencial Los prados';
UPDATE contenedores SET estado = 'nuevo' WHERE ultimo_mantenimiento > TO_DATE('2025-01-01', 'YYYY-MM-DD');


// deletes

DELETE FROM ubicacion_contenedores WHERE id = 1;
DELETE FROM sensores WHERE serial = 5081781;
DELETE FROM tipo_residuo WHERE id = 5;





// Luis Ángel De Los Santos Recio 2018-6676

INSERT INTO usuarios (usuario, contrasena, id_empleado)
values ('carlos', '1234', 1);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
values ('Luis', '1234', 2);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
values ('Mariano', '1234', 3);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
values ('Robert', '1234', 4);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
values ('Maria', '1234', 5);


INSERT INTO reportes_empleados(id, texto, fecha, id_usuario)
values(reportes_empleados_id_SEQ.nextval, 'Se ha recolectado correctamente la basura', to_date('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(id, texto, fecha, id_usuario)
values(reportes_empleados_id_SEQ.nextval, 'No se ha podido recoletar la basura de un contenedor', to_date('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(id, texto, fecha, id_usuario)
values(reportes_empleados_id_SEQ.nextval, 'Se ha recolectado correctametne la basura', to_date('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(id, texto, fecha, id_usuario)
values(reportes_empleados_id_SEQ.nextval, 'El contenedor estaba vacio', to_date('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(id, texto, fecha, id_usuario)
values(reportes_empleados_id_SEQ.nextval, 'Se ha recolectado correctamente la basura', to_date('12-03-2009', 'DD-MM-YYYY'), 2);


INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
values(1, 1);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
values(1, 2);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
values(2, 3);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
values(2, 4);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
values(3, 5);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
values(3, 1);



SELECT * FROM usuarios ORDER BY id_empleado;
SELECT * FROM reportes_empleados;

update rutas_contenedores_ubicaciones set id_ubi_cont = 3 where id_ruta = 1 and id_ubi_cont = 1;
update rutas_contenedores_ubicaciones set id_ubi_cont = 5 where id_ruta = 2 and id_ubi_cont = 3;
update rutas_contenedores_ubicaciones set id_ubi_cont = 2 where id_ruta = 3 and id_ubi_cont = 1;



DELETE FROM rutas_contenedores_ubicaciones where id_ruta = 1;
DELETE FROM rutas_contenedores_ubicaciones where id_ruta = 2;
DELETE FROM rutas_contenedores_ubicaciones where id_ruta = 3;


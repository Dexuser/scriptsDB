// luis
CREATE TABLE destino_final(
    id_destino_final NUMBER CONSTRAINT destino_id_pk PRIMARY KEY,
    nombre VARCHAR2(30) CONSTRAINT destino_nombre_nn NOT NULL,
    tipo VARCHAR2(30) CONSTRAINT destino_tipo_nn NOT NULL,
    latitud DECIMAL(8,6) CONSTRAINT destino_latitud_nn NOT NULL,
    longitud DECIMAL(9,6) CONSTRAINT destino_longitud_nn NOT NULL,
    CONSTRAINT destino_tipo_ck CHECK(tipo IN ('Planta recolectora', 'Punto de transferencia', 'Basudero'))
);

CREATE SEQUENCE destino_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE zonas (
    id_zona NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(30) CONSTRAINT zonas_nombre_nn NOT NULL,
    CONSTRAINT zonas_id_pk PRIMARY KEY (id_zona)
);

CREATE TABLE rutas(
    id_ruta NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(30) CONSTRAINT rutas_nombre_nn NOT NULL,
    id_zona NUMBER CONSTRAINT rutas_zona_fk REFERENCES zonas(id_zona),
    id_destino_final CONSTRAINT rutas_destino_fk REFERENCES destino_final(id_destino_final),
    CONSTRAINT rutas_id_pk PRIMARY KEY (id_ruta)
);




// kevin
CREATE TABLE sensores(
    serial NUMBER CONSTRAINT sensores_serial_pk PRIMARY KEY,
    marca VARCHAR(50) CONSTRAINT sensores_marca_nn NOT NULL
);

CREATE TABLE tipo_residuo(
    id_tipo_residuo NUMBER CONSTRAINT tipo_residuo_id_pk PRIMARY KEY,
    descripcion VARCHAR(255) CONSTRAINT tipo_residuo_descripcion_nn NOT NULL
);

CREATE SEQUENCE tipo_residuo_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE ubicacion_contenedores(
    id_ubicacion NUMBER CONSTRAINT ubi_cont_id_pk PRIMARY KEY,
    latitud DECIMAL(8,6),
    longitud DECIMAL(9,6),
    descripcion VARCHAR2(255) CONSTRAINT ubi_cont_nn NOT NULL,
    id_zona NUMBER CONSTRAINT ubi_cont_zona REFERENCES zonas(id_zona)
);

CREATE SEQUENCE ubi_cont_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE contenedores(
    id_contenedor NUMBER  GENERATED ALWAYS AS IDENTITY,
    estado VARCHAR2(40) CONSTRAINT contenedores_estado_nn NOT NULL,
    capacidad_kg NUMBER CONSTRAINT contenedores_capacidad_nn NOT NULL,
    ultimo_mantenimiento DATE,
    id_ubicacion NUMBER,
    id_tipo_residuo NUMBER,
    CONSTRAINT contenedores_id_pk PRIMARY KEY (id_contenedor),
    CONSTRAINT contenedores_ubicacion_fk FOREIGN KEY (id_ubicacion) REFERENCES ubicacion_contenedores(id_ubicacion),
    CONSTRAINT contenedores_tipo_residuo_fk FOREIGN KEY(id_tipo_residuo) REFERENCES tipo_residuo(id_tipo_residuo),
    CONSTRAINT contenedores_estado_ck
    CHECK(estado IN('nuevo', 'en uso', 'lleno', 'vacio', 'dañado', 'perdido', 'fuera de servicio'))
);






// Leam
// tablas creadas y constraints que creia pertinentes para cada una
CREATE TABLE puestos(
    id_puesto NUMBER GENERATED ALWAYS AS IDENTITY,
    descripcion VARCHAR2(255) CONSTRAINT puestos_descripcion_nn NOT NULL,
    CONSTRAINT puestos_id_pk PRIMARY KEY (id_puesto)
);
    
CREATE TABLE empleados(
    id_empleado NUMBER GENERATED ALWAYS AS IDENTITY, 
    nombre VARCHAR2(40) CONSTRAINT empleados_nombre_nn NOT NULL,
    apellido VARCHAR2(40) CONSTRAINT empleados_apellido_nn NOT NULL,
    cedula VARCHAR2(40) CONSTRAINT empleados_cedula_nn NOT NULL,
    fecha_liquidacion DATE,
    email VARCHAR2(60),
    fecha_nacimiento DATE CONSTRAINT empleados_fecha_nacimiento_nn NOT NULL,
    fecha_contratacion DATE CONSTRAINT empleados_fecha_contratacion_nn NOT NULL,
    id_puesto NUMBER CONSTRAINT empleados_puesto_nn NOT NULL,
    CONSTRAINT empleados_id_pk PRIMARY KEY (id_empleado),
    CONSTRAINT empleados_puesto_fk FOREIGN KEY (id_puesto) REFERENCES puestos(id_puesto),
    CONSTRAINT empleados_cedula_unq UNIQUE (cedula),
    CONSTRAINT empleados_email_ck CHECK (email LIKE '%@%')
);



CREATE TABLE vehiculos(
    matricula VARCHAR2(40) CONSTRAINT vehiculos_matricula_pk PRIMARY KEY,
    marca VARCHAR2(40),
    tipo_vehiculo VARCHAR2(40),
    capacidad_kg DECIMAL(8,2) CONSTRAINT vehiculos_capacidad_nn NOT NULL,
    id_empleado NUMBER,
    CONSTRAINT fk_empleados_vehiculos FOREIGN KEY (id_empleado)
    REFERENCES empleados(id_empleado)
);




CREATE TABLE horarios_recoleccion (
    id_horarios_recoleccion NUMBER ,
    dia VARCHAR2(15) CONSTRAINT recoleccion_dia_nn NOT NULL,
    hora_inicio TIMESTAMP CONSTRAINT recoleccion_hora_inicio_nn NOT NULL,
    hora_salida TIMESTAMP CONSTRAINT recoleccion_hora_fin_nn NOT NULL,
    id_empleado NUMBER CONSTRAINT recoleccion_empleado_nn NOT NULL,
    id_ruta NUMBER,
    
    CONSTRAINT horarios_id_pk PRIMARY KEY (id_horarios_recoleccion),
    
    CONSTRAINT ck_dias CHECK (dia IN (
        'lunes', 'martes', 'miercoles', 'jueves','viernes', 'sabado', 'domingo')),
    
    CONSTRAINT horariosr_empleados_fk FOREIGN KEY (id_empleado)
        REFERENCES empleados(id_empleado),
    
    CONSTRAINT horariosr_ruta_fk FOREIGN KEY (id_ruta)
        REFERENCES rutas(id_ruta)
);

COMMIT;

CREATE SEQUENCE horarios_recoleccion_id_seq START WITH 1 INCREMENT BY 1;



// Hyun
CREATE TABLE usuarios (
    id_usuario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario VARCHAR2(30) CONSTRAINT usuarios_usuario_nn NOT NULL,
    contrasena VARCHAR(30) CONSTRAINT usuarios_contrasena_nn NOT NULL,
    id_empleado NUMBER CONSTRAINT usuarios_empleado_fk REFERENCES empleados(id_empleado)
);

CREATE TABLE reportes_empleados (
    ID NUMBER CONSTRAINT reportes_empleados_pk PRIMARY KEY,
    texto VARCHAR2(2000) CONSTRAINT usuarios_texto_nn NOT NULL,
    fecha DATE CONSTRAINT usuarios_fecha_nn NOT NULL,
    id_usuario CONSTRAINT reportes_usuarios_fk REFERENCES usuarios(id_usuario)
);

CREATE SEQUENCE reportes_empleados_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE residentes(
    cedula_residente VARCHAR2(30) CONSTRAINT residentes_cedula_pk PRIMARY KEY,
    nombre VARCHAR2(20) CONSTRAINT residentes_nombre_nn NOT NULL,
    apellido VARCHAR2(20) CONSTRAINT residentes_apellido_nn NOT NULL,
    telefono VARCHAR2(20) CONSTRAINT residentes_telefono_nn NOT NULL,
    email VARCHAR2(50) CONSTRAINT residentes_email_nn NOT NULL,
    codigo_postal VARCHAR2(10) CONSTRAINT usuarios_postal_nn NOT NULL,
    CONSTRAINT residentes_email_ck CHECK(email LIKE '%@%')
);

CREATE TABLE reportes_residentes (
    ID NUMBER GENERATED ALWAYS AS IDENTITY ,
    texto VARCHAR2(2000) CONSTRAINT reporte_residente_texto_nn NOT NULL,
    fecha DATE CONSTRAINT reporte_residente_fecha_nn NOT NULL,
    cedula_residente VARCHAR2(20) CONSTRAINT reporte_residente_fk 
    REFERENCES residentes(cedula_residente),
    
    CONSTRAINT reportes_residentes_pk PRIMARY KEY (ID)
);


// tablas intermedias (M : N)
// Luis
CREATE TABLE rutas_contenedores_ubicaciones(
    id_ruta NUMBER,
    id_ubi_cont NUMBER,
    CONSTRAINT rcu_pk PRIMARY KEY(id_ruta, id_ubi_cont),
    CONSTRAINT rcu_rutas_fk FOREIGN KEY (id_ruta) REFERENCES rutas(id_ruta),
    CONSTRAINT rcu_ubi_cont_fk FOREIGN KEY (id_ubi_cont) REFERENCES ubicacion_contenedores(id_ubicacion)
);


// PRACTICA 3. MANIPULACION DE OBJETOS MEDIANTE SQL


// Luis
INSERT INTO destino_final(id_destino_final, nombre, tipo, latitud, longitud) VALUES
( destino_id_seq.NEXTVAL, 'Bsdro. la tita', 'Basudero', 38.234567, 212.345689);

INSERT INTO destino_final(id_destino_final, nombre, tipo, latitud, longitud) VALUES
(destino_id_seq.NEXTVAL,'Rclect. Gutierrez', 'Planta recolectora', 18.346718, 530.345682);

INSERT INTO destino_final(id_destino_final, nombre, tipo, latitud, longitud) VALUES
(destino_id_seq.NEXTVAL,'transf. la estrella', 'Punto de transferencia', 48.234612, 100.3468);

INSERT INTO destino_final(id_destino_final, nombre, tipo, latitud, longitud) VALUES
(destino_id_seq.NEXTVAL,'transf. de cancela', 'Punto de transferencia', 38.234567, 212.34568);

INSERT INTO destino_final(id_destino_final, nombre, tipo, latitud, longitud) VALUES
(destino_id_seq.NEXTVAL,'Bsdro. de Cancela', 'Basudero', 23.45679, 453.4568);


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


INSERT INTO rutas (nombre, id_zona, id_destino_final) VALUES
('Ruta de la tita', 1, 1);

INSERT INTO rutas (nombre, id_zona, id_destino_final) VALUES
('Ruta hasta Gutierrez', 1, 2);

INSERT INTO rutas (nombre, id_zona, id_destino_final) VALUES
('Ruta de la estrella', 1, 3);

INSERT INTO rutas (nombre, id_zona, id_destino_final) VALUES
('Ruta de Cancela', 1, 4);

INSERT INTO rutas (nombre, id_zona, id_destino_final) VALUES
('Ruta de la tita', 1, 5);

COMMIT;

SELECT * FROM destino_final ORDER BY id_destino_final DESC;
SELECT * FROM rutas ORDER BY id_destino_final;
SELECT * FROM zonas ORDER BY id_zona ASC;

UPDATE rutas SET id_destino_final = 5 WHERE id_ruta = 1;
UPDATE rutas SET id_destino_final = 4 WHERE id_ruta = 3;
UPDATE rutas SET id_destino_final = 3 WHERE id_ruta = 4;

COMMIT;
ROLLBACK;

DELETE rutas WHERE id_ruta = 6;
DELETE rutas WHERE id_ruta = 5;
DELETE rutas WHERE id_ruta = 4;

COMMIT;



// Leam
INSERT INTO puestos (descripcion) VALUES ('operador');
INSERT INTO puestos (descripcion) VALUES ('recolector');
INSERT INTO puestos (descripcion) VALUES ('supervisor');
INSERT INTO puestos (descripcion) VALUES ('clasificador de residuos');
INSERT INTO puestos (descripcion) VALUES ('gerente');
COMMIT;

INSERT INTO empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) VALUES ('Carlos', 'Almonte Villanueva', '001-0000001-1', NULL,
'carlos@gmail.com', TO_DATE('21-03-1985', 'DD-MM-YYYY'), TO_DATE('12-03-2009', 'DD-MM-YYYY'), 1);

INSERT INTO empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) VALUES ('Luis', 'Santana Peralta', '001-1285166-2', NULL,
'Luissantan@gmail.com', TO_DATE('11-09-1998', 'DD-MM-YYYY'), TO_DATE('08-05-2011', 'DD-MM-YYYY'), 2);

INSERT INTO empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) VALUES ('Mariano', 'Rivera Gonzalez', '402-2805132-8', NULL,
NULL, TO_DATE('27-02-1980', 'DD-MM-YYYY'), TO_DATE('07-03-2002', 'DD-MM-YYYY'), 4);

INSERT INTO empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) VALUES ('Robert', 'Pascual Ariza', '402-3779206-0', NULL,
'licrpascual@gmail.com', TO_DATE('11-08-1965', 'DD-MM-YYYY'), TO_DATE('11-03-2001', 'DD-MM-YYYY'), 5);

INSERT INTO empleados(nombre, apellido,cedula, fecha_liquidacion, email,
fecha_nacimiento, fecha_contratacion, id_puesto ) VALUES ('Maria Lucia', 'Holguin Rodriguez', '402-2502119-1', NULL,
'marialuc@gmail.com', TO_DATE('21-03-1986', 'DD-MM-YYYY'), TO_DATE('12-03-2010', 'DD-MM-YYYY'), 3);

COMMIT;


INSERT INTO vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
VALUES('E104237', 'Heil','Camion volqueta', 15000.00, 1 );

INSERT INTO vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
VALUES('E096601', 'McNeilus','Camion compactador', 12500.00, 2 );

INSERT INTO vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
VALUES('E089332', 'Roger','Camion compactador', 12500.00, NULL );

INSERT INTO vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
VALUES('E089547', 'Isuzu','Camion doble compactador', 14000.00, NULL );

INSERT INTO vehiculos (matricula, marca, tipo_vehiculo, capacidad_kg, id_empleado)
VALUES('E087765', 'Mitsubishi','Camion volqueta', 15000.00, NULL );

COMMIT;


INSERT INTO horarios_recoleccion (id_horarios_recoleccion,dia, hora_inicio, hora_salida, id_empleado, id_ruta) 
VALUES (horarios_recoleccion_id_seq.NEXTVAL, 'lunes', TO_TIMESTAMP('02-06-2025 5:30:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('02-06-2025 8:30:00','DD-MM-YYYY HH24:MI:SS'),1,1);

INSERT INTO horarios_recoleccion (id_horarios_recoleccion,dia, hora_inicio, hora_salida, id_empleado, id_ruta) 
VALUES (horarios_recoleccion_id_seq.NEXTVAL, 'lunes', TO_TIMESTAMP('02-06-2025 1:00:00', 'DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('02-06-2025 4:00:00','DD-MM-YYYY HH24:MI:SS' ),1,2);

INSERT INTO horarios_recoleccion (id_horarios_recoleccion,dia, hora_inicio, hora_salida, id_empleado, id_ruta) 
VALUES (horarios_recoleccion_id_seq.NEXTVAL, 'martes', TO_TIMESTAMP('03-06-2025 2:00:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('03-06-2025 5:00:00','DD-MM-YYYY HH24:MI:SS'),2,3);

INSERT INTO horarios_recoleccion (id_horarios_recoleccion,dia, hora_inicio, hora_salida, id_empleado, id_ruta) 
VALUES (horarios_recoleccion_id_seq.NEXTVAL, 'miercoles', TO_TIMESTAMP('04-06-2025 2:00:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('04-06-2025 5:00:00','DD-MM-YYYY HH24:MI:SS'),1,2);

INSERT INTO horarios_recoleccion (id_horarios_recoleccion,dia, hora_inicio, hora_salida, id_empleado, id_ruta) 
VALUES (horarios_recoleccion_id_seq.NEXTVAL, 'jueves', TO_TIMESTAMP('05-06-2025 7:00:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('05-06-2025 10:00:00','DD-MM-YYYY HH24:MI:SS' ),2,1);


COMMIT;


SELECT * FROM empleados
ORDER BY nombre ASC;

SELECT * FROM vehiculos
ORDER BY capacidad_kg ASC;

UPDATE empleados SET cedula = '001-0000001-1'
WHERE id_empleado = 1;

UPDATE empleados SET cedula = '001-1285166-2'
WHERE id_empleado = 2;

UPDATE empleados SET cedula = '402-2805132-8'
WHERE id_empleado = 3;

UPDATE empleados SET cedula = '402-3779206-0'
WHERE id_empleado = 4;

UPDATE empleados SET cedula = '402-2502119-1'
WHERE id_empleado = 5;

UPDATE empleados SET id_puesto = 1
WHERE id_empleado = 2;

COMMIT;


DELETE FROM horarios_recoleccion WHERE id_horarios_recoleccion = 2;
DELETE FROM horarios_recoleccion WHERE id_horarios_recoleccion = 4;
DELETE FROM horarios_recoleccion WHERE id_horarios_recoleccion = 5;

COMMIT;



//Kevyn
INSERT INTO residentes (cedula_residente, nombre, apellido, telefono, email, codigo_postal)
VALUES ('001-1234567-8', 'Pedro', 'Martínez', '8091234567', 'pedro.martinez@email.com', '10101');

INSERT INTO residentes (cedula_residente, nombre, apellido, telefono, email, codigo_postal)
VALUES ('002-7654321-3', 'Juana', 'Pérez', '8297654321', 'juana.perez@email.com', '10202');

INSERT INTO residentes (cedula_residente, nombre, apellido, telefono, email, codigo_postal)
VALUES ('003-1112233-7', 'Carlos', 'Gómez', '8491112233', 'carlos.gomez@email.com', '10303');

INSERT INTO residentes (cedula_residente, nombre, apellido, telefono, email, codigo_postal)
VALUES ('004-9998888-1', 'Lucía', 'Fernández', '8099998888', 'lucia.fernandez@email.com', '10404');

INSERT INTO residentes (cedula_residente, nombre, apellido, telefono, email, codigo_postal)
VALUES ('005-5556666-4', 'José', 'Ramírez', '8295556666', 'jose.ramirez@email.com', '10505');

COMMIT;

INSERT INTO reportes_residentes (texto, fecha, cedula_residente) VALUES
('Reporte de ruido excesivo durante la noche', TO_DATE('2025-06-01', 'YYYY-MM-DD'), '001-1234567-8');

INSERT INTO reportes_residentes (texto, fecha, cedula_residente) VALUES
('Queja por mal estado del parque cercano', TO_DATE('2025-06-02', 'YYYY-MM-DD'), '002-7654321-3');

INSERT INTO reportes_residentes (texto, fecha, cedula_residente) VALUES
('Solicitud de reparación de alumbrado público', TO_DATE('2025-06-03', 'YYYY-MM-DD'), '003-1112233-7');

INSERT INTO reportes_residentes (texto, fecha, cedula_residente) VALUES
('Reporte de basura acumulada en la vía', TO_DATE('2025-06-04', 'YYYY-MM-DD'), '004-9998888-1');

INSERT INTO reportes_residentes (texto, fecha, cedula_residente) VALUES
('Problemas con el suministro de agua', TO_DATE('2025-06-05', 'YYYY-MM-DD'), '005-5556666-4');

COMMIT;

INSERT INTO ubicacion_contenedores (id_ubicacion, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_seq.NEXTVAL, 18.4750, -69.8900, 'Contenedor frente al parque Independencia', 1);

INSERT INTO ubicacion_contenedores (id_ubicacion, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_seq.NEXTVAL, 19.4501, -70.6944, 'Contenedor en la esquina de la Calle del Sol', 2);

INSERT INTO ubicacion_contenedores (id_ubicacion, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_seq.NEXTVAL, 19.2205, -70.5305, 'Contenedor cerca del mercado de La Vega', 3);

INSERT INTO ubicacion_contenedores (id_ubicacion, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_seq.NEXTVAL, 18.5671, -68.3671, 'Contenedor en la entrada de Punta Cana Village', 4);

INSERT INTO ubicacion_contenedores (id_ubicacion, latitud, longitud, descripcion, id_zona) VALUES
(ubi_cont_id_seq.NEXTVAL, 19.7951, -70.6899, 'Contenedor próximo al malecón de Puerto Plata', 5);


COMMIT;

SELECT * FROM residentes;
SELECT * FROM reportes_residentes;
SELECT * FROM ubicacion_contenedores;

COMMIT;

UPDATE ubicacion_contenedores
SET descripcion = 'Contenedor detrás del parque Independencia'
WHERE id_ubicacion = 1;

UPDATE ubicacion_contenedores
SET latitud = 19.4505, longitud = -70.6955
WHERE id_ubicacion = 2;

UPDATE ubicacion_contenedores
SET descripcion = 'Contenedor removido temporalmente por mantenimiento'
WHERE id_ubicacion = 5;

COMMIT;

DELETE FROM reportes_residentes
WHERE texto = 'Reporte de ruido excesivo durante la noche';

DELETE FROM reportes_residentes
WHERE texto = 'Queja por mal estado del parque cercano';

DELETE FROM reportes_residentes
WHERE texto = 'Solicitud de reparación de alumbrado público';

COMMIT;


// kevin

CREATE SEQUENCE sq_mrgarcia 
START WITH 1
INCREMENT BY 1;



/*HACER 5 INSERCIONES POR CADA TABLA CREADA*/
INSERT INTO sensores (serial, marca) VALUES (5081781, 'EcoSense');
INSERT INTO sensores (serial, marca) VALUES (1444044, 'GreenTrack');
INSERT INTO sensores (serial, marca) VALUES (2589416, 'WasteWatch');
INSERT INTO sensores (serial, marca) VALUES (8915568, 'CleanScan');
INSERT INTO sensores (serial, marca) VALUES (8469470, 'BinSmart');


INSERT INTO tipo_residuo (id_tipo_residuo, descripcion) VALUES (sq_mrgarcia.NEXTVAL, 'Organico');
INSERT INTO tipo_residuo (id_tipo_residuo, descripcion) VALUES (sq_mrgarcia.NEXTVAL, 'vidrio');
INSERT INTO tipo_residuo (id_tipo_residuo, descripcion) VALUES (sq_mrgarcia.NEXTVAL, 'plastico');
INSERT INTO tipo_residuo (id_tipo_residuo, descripcion) VALUES (sq_mrgarcia.NEXTVAL, 'papel');
INSERT INTO tipo_residuo (id_tipo_residuo, descripcion) VALUES (sq_mrgarcia.NEXTVAL, 'carton');


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

COMMIT;


// selects

SELECT * FROM contenedores ORDER BY ultimo_mantenimiento;
SELECT * FROM sensores ORDER BY serial;
SELECT * FROM ubicacion_contenedores;
COMMIT;


// updates

UPDATE contenedores SET capacidad_kg = 130 WHERE id_contenedor = 1;
UPDATE ubicacion_contenedores SET descripcion = 'Residencial Los Almirantes' WHERE descripcion = 'Residencial Los prados';
UPDATE contenedores SET estado = 'nuevo' WHERE ultimo_mantenimiento > TO_DATE('2025-01-01', 'YYYY-MM-DD');
COMMIT;

// deletes

SELECT * FROM ubicacion_contenedores;
DELETE FROM ubicacion_contenedores WHERE id_ubicacion = 1;
DELETE FROM sensores WHERE serial = 5081781;
DELETE FROM tipo_residuo WHERE id_tipo_residuo = 5;

COMMIT;




// Luis Ángel De Los Santos Recio 2018-6676

INSERT INTO usuarios (usuario, contrasena, id_empleado)
VALUES ('carlos', '1234', 1);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
VALUES ('Luis', '1234', 2);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
VALUES ('Mariano', '1234', 3);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
VALUES ('Robert', '1234', 4);

INSERT INTO usuarios (usuario, contrasena, id_empleado)
VALUES ('Maria', '1234', 5);

COMMIT;

INSERT INTO reportes_empleados(ID, texto, fecha, id_usuario)
VALUES(reportes_empleados_id_seq.NEXTVAL, 'Se ha recolectado correctamente la basura', TO_DATE('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(ID, texto, fecha, id_usuario)
VALUES(reportes_empleados_id_seq.NEXTVAL, 'No se ha podido recoletar la basura de un contenedor', TO_DATE('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(ID, texto, fecha, id_usuario)
VALUES(reportes_empleados_id_seq.NEXTVAL, 'Se ha recolectado correctametne la basura', TO_DATE('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(ID, texto, fecha, id_usuario)
VALUES(reportes_empleados_id_seq.NEXTVAL, 'El contenedor estaba vacio', TO_DATE('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO reportes_empleados(ID, texto, fecha, id_usuario)
VALUES(reportes_empleados_id_seq.NEXTVAL, 'Se ha recolectado correctamente la basura', TO_DATE('12-03-2009', 'DD-MM-YYYY'), 2);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
VALUES(1, 1);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
VALUES(1, 2);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
VALUES(2, 3);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
VALUES(2, 4);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
VALUES(3, 5);

INSERT INTO rutas_contenedores_ubicaciones(id_ruta, id_ubi_cont) 
VALUES(3, 1);

COMMIT;

SELECT * FROM usuarios ORDER BY id_empleado;
SELECT * FROM reportes_empleados;
/* Comente esta seccion para que haiga regitros en rutas_contenedores_ubicaciones - luis
update rutas_contenedores_ubicaciones set id_ubi_cont = 3 where id_ruta = 1 and id_ubi_cont = 1;
update rutas_contenedores_ubicaciones set id_ubi_cont = 5 where id_ruta = 2 and id_ubi_cont = 3;
update rutas_contenedores_ubicaciones set id_ubi_cont = 2 where id_ruta = 3 and id_ubi_cont = 1;



DELETE FROM rutas_contenedores_ubicaciones where id_ruta = 1;
DELETE FROM rutas_contenedores_ubicaciones where id_ruta = 2;
DELETE FROM rutas_contenedores_ubicaciones where id_ruta = 3;
*/

COMMIT;


// Practica 4

// luis
SELECT id_contenedor, estado, capacidad_kg FROM contenedores;
SELECT cedula_residente, nombre, email FROM residentes;


// complejas
SELECT id_empleado, nombre, cedula, id_puesto FROM empleados WHERE id_puesto = 1 ORDER BY nombre;

SELECT id_contenedor,
    estado,
    capacidad_kg,
    ultimo_mantenimiento
FROM contenedores 
WHERE ultimo_mantenimiento BETWEEN TO_DATE('1-1-2010', 'DD-MM-YY') AND TO_DATE('1-1-2023', 'DD-MM-YY')
ORDER BY capacidad_kg DESC;


SELECT 
    id_contenedor,
    estado,
    capacidad_kg,
    id_ubicacion,
    id_zona,
    nombre AS zona_nombre,
    latitud,
    longitud
FROM 
    contenedores NATURAL JOIN ubicacion_contenedores NATURAL JOIN zonas;
    
SELECT id_empleado, nombre, apellido, id_puesto, descripcion
FROM empleados JOIN  puestos USING (id_puesto);
    
SELECT R.id_ruta,
    R.nombre,
    R.id_destino_final,
    D.nombre
FROM 
    rutas R JOIN destino_final D ON (R.id_destino_final = D.id_destino_final);
    
    
SELECT * FROM vehiculos;

// En este self join estoy buscando todos los vehiculos cuya capacidad sea menor
// al valor mas alto del campo capacidad. Con esta informacion uno podria usar EXECEPT para
// encontrar el valor mas grande de la tabla. 
SELECT 
    V1.matricula,
    V1.capacidad_kg 
FROM 
    vehiculos V1 JOIN vehiculos V2 ON V1.capacidad_kg < V2.capacidad_kg;


SELECT
    R.ID,
    R.texto, 
    R.fecha, 
    R.id_usuario, 
    E.nombre 
FROM
    reportes_empleados R 
JOIN 
    usuarios U ON (R.id_usuario = U.id_usuario) AND (R.ID < 3)
JOIN
    empleados E ON (U.id_empleado = E.id_empleado);
    
SELECT 
    C.id_contenedor,
    C.estado,
    C.capacidad_kg,
    T.id_tipo_residuo,
    T.descripcion
FROM contenedores C LEFT JOIN tipo_residuo T ON (C.id_tipo_residuo = T.id_tipo_residuo);
    
// En este caso, sacamos los vehiculos con la mayor capacidad que hay.
// (el valor mas alto de capacidad existente en la tabla es 1500 y los dos vehiculos
// mostrados tienen dicho valor)
SELECT 
    matricula,
    capacidad_kg
FROM vehiculos EXCEPT (SELECT 
            V1.matricula,
            V1.capacidad_kg 
        FROM 
            vehiculos V1 JOIN vehiculos V2 ON V1.capacidad_kg < V2.capacidad_kg);
            
SELECT * FROM vehiculos WHERE capacidad_kg < (SELECT 
                        capacidad_kg FROM vehiculos WHERE matricula = 'E089547');
// luis
CREATE TABLE destino_final(
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(30) CONSTRAINT destino_nombre_NN NOT NULL,
    tipo VARCHAR2(30) CONSTRAINT destino_tipo_NN NOT NULL,
    latitud DECIMAL(8,6) CONSTRAINT destino_latitud_NN NOT NULL,
    longitud DECIMAL(9,6) CONSTRAINT destino_longitud_NN NOT NULL,
    CONSTRAINT destino_id_PK PRIMARY KEY (id),
    CONSTRAINT destino_tipo_CK CHECK(tipo IN ('Planta recolectora', 'Punto de transferencia', 'Basudero'))
);

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
    CHECK(estado IN('nuevo', 'en uso', 'lleno', 'vacio', 'dañado', 'perdido', 'fuera de servicio'))
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
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    dia VARCHAR2(15) CONSTRAINT recoleccion_dia_NN NOT NULL,
    hora_inicio TIMESTAMP CONSTRAINT recoleccion_hora_inicio_NN NOT NULL,
    hora_salida TIMESTAMP CONSTRAINT recoleccion_hora_fin_NN NOT NULL,
    id_empleado NUMBER CONSTRAINT recoleccion_empleado_NN NOT NULL,
    id_ruta NUMBER,
    
    CONSTRAINT horarios_id_PK PRIMARY KEY (id),
    
    CONSTRAINT ck_dias CHECK (dia IN (
        'lunes', 'martes', 'miercoles', 'jueves','viernes', 'sabado', 'domingo'
        )
    ),
    
    CONSTRAINT horariosr_empleados_FK FOREIGN KEY (id_empleado)
        REFERENCES empleados(id),
    
    CONSTRAINT horariosr_ruta_FK FOREIGN KEY (id_ruta)
        REFERENCES rutas(id)
);



// Hyun
CREATE TABLE usuarios (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario varchar2(30) CONSTRAINT usuarios_usuario_NN NOT NULL,
    contrasena varchar(30) CONSTRAINT usuarios_contrasena_NN NOT NULL,
    id_empleado NUMBER CONSTRAINT usuarios_empleado_FK REFERENCES empleados(id)
);

CREATE TABLE reportes_empleados (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    texto VARCHAR2(2000) CONSTRAINT usuarios_texto_NN NOT NULL,
    fecha DATE CONSTRAINT usuarios_fecha_NN NOT NULL,
    id_usuario CONSTRAINT reportes_usuarios_FK REFERENCES usuarios(id)
);


CREATE TABLE residentes(
    cedula VARCHAR2(30) CONSTRAINT residentes_cedula_PK PRIMARY KEY,
    nombre VARCHAR2(20) CONSTRAINT usuarios_nombre_NN NOT NULL,
    apellido VARCHAR2(20) CONSTRAINT usuarios_apellido_NN NOT NULL,
    telefono VARCHAR2(20) CONSTRAINT usuarios_telefono_NN NOT NULL,
    correo VARCHAR2(20) CONSTRAINT usuarios_correo_NN NOT NULL,
    codigo_postal VARCHAR2(10) CONSTRAINT usuarios_postal_NN NOT NULL,
    CONSTRAINT residentes_correo_CK CHECK(correo like '%@%')
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



// INDICES
CREATE INDEX contenedores_id_ubicacion_IDX ON contenedores(id_ubicacion);
CREATE INDEX horarios_recoleccion_id_empleado_IDX on horarios_recoleccion(id_empleado);
CREATE INDEX horarios_recoleccion_id_ruta_IDX on horarios_recoleccion(id_ruta);



// Sinonimos

CREATE PUBLIC SYNONYM contenedores_pub FOR contenedores;

CREATE SYNONYM tipo_residuo_syn FOR tipo_residuo;

// vistas
CREATE VIEW vista_contenedores_info AS
SELECT
    c.id AS contenedor_id,
    c.estado,
    c.capacidad_kg,
    c.ultimo_mantenimiento,
    tr.descripcion AS tipo_residuo,
    uc.descripcion AS ubicacion,
    z.nombre AS zona
FROM contenedores c
JOIN tipo_residuo tr ON c.id_tipo_residuo = tr.id
JOIN ubicacion_contenedores uc ON c.id_ubicacion = uc.id
JOIN zonas z ON uc.id_zona = z.id;

SELECT * FROM vista_contenedores_info;


// Practica 3. Manipulacion de datos usando SQL

// Luis
INSERT INTO destino_final(nombre, tipo, latitud, longitud) VALUES
('Bsdro. la tita', 'Basudero', 38.234567, 212.345689);

INSERT INTO destino_final(nombre, tipo, latitud, longitud) VALUES
('Rclect. Gutierrez', 'Planta recolectora', 18.346718, 530.345682);

INSERT INTO destino_final(nombre, tipo, latitud, longitud) VALUES
('transf. la estrella', 'Punto de transferencia', 48.234612, 100.3468);

INSERT INTO destino_final(nombre, tipo, latitud, longitud) VALUES
('transf. de cancela', 'Punto de transferencia', 38.234567, 212.34568);

INSERT INTO destino_final(nombre, tipo, latitud, longitud) VALUES
('Bsdro. de Cancela', 'Basudero', 23.45679, 453.4568);

select * from destino_final;
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


SELECT * FROM destino_final;
SELECT * FROM rutas;
SELECT * FROM zonas;

UPDATE rutas SET id_destino_final = 5 WHERE id = 1;
UPDATE rutas SET id_destino_final = 4 WHERE id = 3;
UPDATE rutas SET id_destino_final = 3 WHERE id = 4;

DELETE rutas WHERE id = 6;
DELETE rutas WHERE id = 5;
DELETE rutas WHERE id = 4;

SELECT * FROM destino_final;
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


INSERT INTO horarios_recoleccion (dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) VALUES ('lunes', TO_TIMESTAMP('02-06-2025 5:30:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('02-06-2025 8:30:00','DD-MM-YYYY HH24:MI:SS'),1,1);

INSERT INTO horarios_recoleccion (dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) VALUES ('lunes', TO_TIMESTAMP('02-06-2025 1:00:00', 'DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('02-06-2025 4:00:00','DD-MM-YYYY HH24:MI:SS' ),1,2);

INSERT INTO horarios_recoleccion (dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) VALUES ('martes', TO_TIMESTAMP('03-06-2025 2:00:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('03-06-2025 5:00:00','DD-MM-YYYY HH24:MI:SS'),2,3);

INSERT INTO horarios_recoleccion (dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) VALUES ('miercoles', TO_TIMESTAMP('04-06-2025 2:00:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('04-06-2025 5:00:00','DD-MM-YYYY HH24:MI:SS'),1,2);

INSERT INTO horarios_recoleccion (dia, hora_inicio, hora_salida, 
id_empleado, id_ruta) VALUES ('jueves', TO_TIMESTAMP('05-06-2025 7:00:00','DD-MM-YYYY HH24:MI:SS')
,TO_TIMESTAMP('05-06-2025 10:00:00','DD-MM-YYYY HH24:MI:SS' ),2,1);

COMMIT;


SELECT * FROM empleados
ORDER BY nombre ASC;

SELECT * FROM vehiculos
ORDER BY capacidad_kg ASC;


UPDATE empleados SET cedula = '001-0000001-1'
WHERE ID = 1;

UPDATE empleados SET cedula = '001-1285166-2'
WHERE ID = 2;

UPDATE empleados SET cedula = '402-2805132-8'
WHERE ID = 3;

UPDATE empleados SET cedula = '402-3779206-0'
WHERE ID = 4;

UPDATE empleados SET cedula = '402-2502119-1'
WHERE ID = 5;

UPDATE empleados SET id_puesto = 1
WHERE ID = 2;

COMMIT;


DELETE FROM horarios_recoleccion WHERE ID = 2;
DELETE FROM horarios_recoleccion WHERE ID = 4;
DELETE FROM horarios_recoleccion WHERE ID = 5;

COMMIT;

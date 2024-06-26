    DROP DATABASE IF EXISTS petRecicladora;
    CREATE DATABASE petRecicladora;
    USE petRecicladora;

    DROP TABLE IF EXISTS pet;
    DROP TABLE IF EXISTS despachador;
    DROP TABLE IF EXISTS recibido;

    CREATE TABLE despachador(
        idDE INT NOT NULL PRIMARY KEY COMMENT 'Identificador despachador',
        nombre VARCHAR(25) NOT NULL COMMENT 'Nombre despachador',
        apellido VARCHAR(25) NOT NULL COMMENT 'Apellido despachador',
        clasificacion VARCHAR(25) NOT NULL COMMENT 'Clasificación del despachador',
        fecNac DATE NOT NULL COMMENT 'Fecha de nacimiento despachador',
        horario INT NOT NULL COMMENT 'Horario del despachador'
    ) ENGINE = InnoDB;

    CREATE TABLE pet (
    idPE INT NOT NULL PRIMARY KEY COMMENT 'Identificador de pet',
    concepto VARCHAR(25) NOT NULL COMMENT 'Concepto de la tabla pet',
    reciclaje VARCHAR(25) NOT NULL COMMENT 'Reciclaje de la tabla pet',
    enviado VARCHAR(25) NOT NULL COMMENT 'Enviado de la tabla pet',
    fecSal DATE NOT NULL COMMENT 'Fecha de salida de la tabla pet',
    kilos FLOAT NOT NULL COMMENT 'Kilos de pet'
    ) ENGINE = InnoDB;

    CREATE TABLE recibido(
        idRE INT  NOT NULL AUTO_INCREMENT COMMENT 'Identificador recibido',
        lugar VARCHAR(25) NOT NULL COMMENT 'Lugar del envío',
        fecSoli DATE NOT NULL COMMENT 'Fecha de solicitud',
        fecRec DATE NOT NULL COMMENT 'Fecha de recepción',
        kiloSol FLOAT NOT NULL COMMENT 'Kilos solicitados',
        KilosEn FLOAT NOT NULL COMMENT 'Kilos entregados',
        idDE INT  NOT NULL COMMENT 'Identificador del despachador con relación a la tabla despachador',
        idPE INT  NOT NULL COMMENT 'Identificador del pet con relación a la tabla pet',
        PRIMARY KEY (idRE),
        FOREIGN KEY (idDE) REFERENCES despachador(idDE),
        FOREIGN KEY (idPE) REFERENCES pet(idPE)
    ) ENGINE = InnoDB;

    INSERT INTO despachador (idDE, nombre, apellido, clasificacion, fecNac, horario) VALUES 
    (1, 'John', 'Doe', 'Diurno A', '1990-01-01', 1), 
    (2, 'Jane', 'Smith', 'Mixto', '1995-05-10', 2), 
    (3, 'Michael', 'Johnson', 'Vespertino', '1985-12-15', 3);

    INSERT INTO pet (idPE, concepto, reciclaje, enviado, fecSal, kilos) VALUES
    (1, 'Aluminio', 'Comercial', 'Triciclo', '2021-07-01', 10.5), 
    (2, 'Rebaba', 'Quimico', 'Trailer', '2021-06-15', 8.2),
    (3, 'Bronce', 'Quimico', 'Trailer', '2021-08-05', 5.3);

    INSERT INTO recibido (lugar, fecSoli, fecRec, kiloSol, KilosEn, idDE, idPE) VALUES 
    ('Temixco', '2021-07-01', '2021-07-02', 10.5, 10.5, 1, 1), 
    ('Jiutepec', '2021-06-15', '2021-06-16', 8.2, 8.2, 2, 2),
    ('Zapata', '2021-08-05', '2021-08-06', 5.3, 5.3, 3, 3);

    DELIMITER //
    CREATE FUNCTION crear_codigoPET(
        concepto VARCHAR(25),
        reciclado VARCHAR(25),
        enviadoPor VARCHAR(25),
        fechaSalida DATE,
        kilos FLOAT
    )
    RETURNS VARCHAR(10)
    BEGIN
        DECLARE codigo VARCHAR(10);
        SET codigo = CONCAT(
            UPPER(SUBSTRING(concepto, 1, 2)),
            UPPER(SUBSTRING(reciclado, 1, 2)),
            RIGHT(enviadoPor, 1),
            DATE_FORMAT(fechaSalida, '%y%m%d'),
            REPLACE(DATE_FORMAT(fechaSalida, '%W'), ' ', ''),
            IF(kilos < 10, CONCAT('0', kilos), kilos)
        );
        RETURN codigo;
    END //
    DELIMITER ;

    SELECT concepto, reciclaje,enviado,fecSal,kilos,crear_codigoPET(concepto, reciclaje, enviado, fecSal, kilos) AS codigo_pet
FROM pet;


    DELIMITER //
    CREATE FUNCTION crear_codigoDesp(
        id INT,
        nombre VARCHAR(25),
        apellido VARCHAR(25),
        clasificacion VARCHAR(25),
        fecha_nacimiento DATE,
        horas_trabajadas INT
    )
    RETURNS VARCHAR(10)
    BEGIN
        DECLARE codigo VARCHAR(10);
        DECLARE nombre_abreviado VARCHAR(2);
        DECLARE apellido_abreviado VARCHAR(2);
        DECLARE clasificacion_final VARCHAR(1);
        DECLARE fecha_formateada VARCHAR(8);
        DECLARE dia_semana VARCHAR(3);
        DECLARE horas_formateadas VARCHAR(2);

        SET nombre_abreviado = UPPER(SUBSTRING(nombre, 1, 2));
        SET apellido_abreviado = UPPER(SUBSTRING(apellido, 1, 2));
        SET clasificacion_final = RIGHT(clasificacion, 1);
        SET fecha_formateada = DATE_FORMAT(fecha_nacimiento, '%y%m%d');
        SET dia_semana = REPLACE(DATE_FORMAT(fecha_nacimiento, '%W'), ' ', '');
        SET horas_formateadas = IF(horas_trabajadas < 10, CONCAT('0', horas_trabajadas), horas_trabajadas);

        SET codigo = CONCAT(
            nombre_abreviado,
            apellido_abreviado,
            clasificacion_final,
            fecha_formateada,
            dia_semana,
            horas_formateadas
        );

        RETURN codigo;
    END //
    DELIMITER ;
SELECT idDE,nombre,apellido,clasificacion,fecNac,horario, crear_codigoDesp(idDE, nombre, apellido, clasificacion, fecNac, horario) AS codigo_despachador FROM despachador;


    DELIMITER //

CREATE FUNCTION calcularPagoEmpleado(
    emp_id INT,
    emp_nombre VARCHAR(25),
    emp_apellido VARCHAR(25),
    emp_clasificacion VARCHAR(25),
    emp_fecNac DATE,
    emp_horas_trabajadas INT
)
RETURNS VARCHAR(1000)
BEGIN
    DECLARE resultado VARCHAR(1000);
    DECLARE tarifa_hora DECIMAL(10, 2);
    DECLARE horas_normales INT;
    DECLARE horas_extra_dobles INT;
    DECLARE horas_extra_triples INT;
    DECLARE pago_dobles DECIMAL(10, 2);
    DECLARE pago_triples DECIMAL(10, 2);
    DECLARE salario_base DECIMAL(10, 2);
    DECLARE total_bruto DECIMAL(10, 2);
    DECLARE descuento_imss DECIMAL(10, 2);
    DECLARE descuento_isr DECIMAL(10, 2);
    DECLARE salario_neto DECIMAL(10, 2);

    CASE emp_clasificacion
        WHEN 'Diurno' THEN SET tarifa_hora = 100;
        WHEN 'Mixto' THEN SET tarifa_hora = 110;
        WHEN 'Matutino' THEN SET tarifa_hora = 130;
        ELSE SET tarifa_hora = 70;
    END CASE;

    SET horas_normales = LEAST(emp_horas_trabajadas, 45);
    SET horas_extra_dobles = GREATEST(LEAST(emp_horas_trabajadas - 45, 5), 0);
    SET horas_extra_triples = GREATEST(emp_horas_trabajadas - 50, 0);
    SET pago_dobles = horas_extra_dobles * tarifa_hora * 2;
    SET pago_triples = horas_extra_triples * tarifa_hora * 3;
    SET salario_base = horas_normales * tarifa_hora;
    SET total_bruto = salario_base + pago_dobles + pago_triples;
    SET descuento_imss = total_bruto * 0.13;
    SET descuento_isr = total_bruto * 0.07;
    SET salario_neto = total_bruto - descuento_imss - descuento_isr;

    SET resultado = CONCAT('{"horas_dobles": ', horas_extra_dobles,
                           ', "pago_horas_dobles": ', pago_dobles,
                           ', "horas_triples": ', horas_extra_triples,
                           ', "pago_horas_triples": ', pago_triples,
                           ', "salario_base": ', salario_base,
                           ', "imss": ', descuento_imss,
                           ', "isr": ', descuento_isr,
                           ', "pago_total": ', salario_neto,
                           '}');

    RETURN resultado;
END //

DELIMITER ;

SELECT r.*, ep.*
FROM recibido AS r
JOIN despachador AS d ON r.idDE = d.idDE
CROSS JOIN LATERAL (
    SELECT * FROM establecerPorcentaje(r.lugar, r.KilosEn, r.fecSoli, r.fecRec) AS ep
) AS ep;



DELIMITER //

CREATE FUNCTION calcularPagoReciclado(
    in_kilosSolicitados FLOAT,
    in_kilosReciclados FLOAT,
    in_fechaSolicitud DATE
)
RETURNS VARCHAR(1000)
BEGIN
    DECLARE costoLitro DECIMAL(10, 2);
    DECLARE pagoTotal DECIMAL(10, 2);
    DECLARE diaSemana VARCHAR(10);
    DECLARE esFestivo BOOLEAN;

    SET diaSemana = DATE_FORMAT(in_fechaSolicitud, '%W');
    SET esFestivo = (DATE_FORMAT(in_fechaSolicitud, '%m-%d') IN ('09-15', '10-02', '11-30'));

    CASE
        WHEN diaSemana IN ('Thursday', 'Friday', 'Saturday') THEN SET costoLitro = 1;
        WHEN diaSemana = 'Monday' THEN SET costoLitro = 3;
        WHEN esFestivo THEN SET costoLitro = 6;
        ELSE SET costoLitro = 2; -- Costo normal por litro
    END CASE;

    SET pagoTotal = in_kilosReciclados * costoLitro;

    RETURN CONCAT('{"costo_litro": ', costoLitro,
                  ', "pago_total": ', pagoTotal,
                  '}');
END //

DELIMITER ;


    SELECT concepto, reciclaje, enviado, fecSal, kilos, calcularPagoReciclado(kiloSol, KilosEn, fecSoli) AS pago_reciclado FROM pet;

   DELIMITER //

CREATE FUNCTION solicitarNuevoPET(
    in_fechaSalida DATE
)
RETURNS DATE
BEGIN
    DECLARE fechaSolicitud DATE;

    DECLARE yearSalida YEAR;
    DECLARE trimestre INT;

    SET yearSalida = YEAR(in_fechaSalida);
    SET trimestre = CEIL(MONTH(in_fechaSalida) / 3);

    IF (yearSalida BETWEEN 2023 AND 2024) THEN
        SET fechaSolicitud = LAST_DAY(in_fechaSalida) - INTERVAL 2 DAY;
    ELSEIF (yearSalida BETWEEN 2024 AND 2025) THEN
        SET fechaSolicitud = LAST_DAY(in_fechaSalida) - INTERVAL 7 DAY;
        
        IF (DAY(in_fechaSalida) = 3) THEN
            SET fechaSolicitud = in_fechaSalida;
        END IF;
    END IF;

    RETURN fechaSolicitud;
END //

DELIMITER ;


    SELECT *, solicitarNuevoPET(fecSal) AS fecha_solicitud FROM pet;

DELIMITER //

CREATE FUNCTION establecerPorcentaje(
    in_lugar VARCHAR(25),
    in_kilos FLOAT,
    in_fechaSolicitud DATE,
    in_fechaReciclado DATE
)
RETURNS TABLE (
    porcentaje_trabajador DECIMAL(5,2),
    porcentaje_pet DECIMAL(5,2),
    porcentaje_empresa DECIMAL(5,2),
    semanas_pasadas INT,
    dias_faltantes INT
)
BEGIN
    DECLARE porcentaje_trab DECIMAL(5,2);
    DECLARE porcentaje_pet DECIMAL(5,2);
    DECLARE porcentaje_emp DECIMAL(5,2);
    DECLARE semanas_pasadas INT;
    DECLARE dias_faltantes INT;

    CASE in_lugar
        WHEN 'Yautepec' THEN
            SET porcentaje_trab = 35.00;
            SET porcentaje_pet = 25.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        WHEN 'Jiutepec' THEN
            SET porcentaje_trab = 35.00;
            SET porcentaje_pet = 25.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        WHEN 'San Carlos' THEN
            SET porcentaje_trab = 35.00;
            SET porcentaje_pet = 25.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        WHEN 'Texcal' THEN
            SET porcentaje_trab = 35.00;
            SET porcentaje_pet = 45.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        WHEN 'Zapata' THEN
            SET porcentaje_trab = 35.00;
            SET porcentaje_pet = 45.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        WHEN 'Cuernavaca' THEN
            SET porcentaje_trab = 35.00;
            SET porcentaje_pet = 45.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        WHEN 'UPEMOR' THEN
            SET porcentaje_trab = 55.00;
            SET porcentaje_pet = 30.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
        ELSE
            SET porcentaje_trab = 30.00; 
            SET porcentaje_pet = 40.00;
            SET porcentaje_emp = 100 - porcentaje_trab - porcentaje_pet;
    END CASE;

    SET semanas_pasadas = TIMESTAMPDIFF(WEEK, in_fechaSolicitud, in_fechaReciclado);
    SET dias_faltantes = MOD(TIMESTAMPDIFF(DAY, in_fechaSolicitud, in_fechaReciclado), 7);

    IF in_kilos > 50 THEN
        SET porcentaje_trab = porcentaje_trab + 15.00;
    END IF;

    RETURN TABLE (
        porcentaje_trabajador, 
        porcentaje_pet, 
        porcentaje_empresa, 
        semanas_pasadas, 
        dias_faltantes
    );
END //

DELIMITER ;


    SELECT concepto, KilosEn, fecSoli, fecRec, porcentaje_trabajador, porcentaje_pet, porcentaje_empresa, semanas_pasadas, dias_faltantes
    FROM recibido JOIN pet ON recibido.idPE = pet.idPE CROSS JOIN LATERAL (
        SELECT * FROM establecerPorcentaje(recibido.lugar, KilosEn, fecSoli, fecRec)
    ) AS porcentajes;

    SELECT d.nombre AS nombre_repartidor,
        r.lugar,
        r.fecRec AS fecha_reciclado,
        DATE_FORMAT(r.fecRec, '%W') AS nombre_dia,
        ep.porcentaje_trabajador,
        ep.porcentaje_pet,
        ep.porcentaje_empresa,
        ep.semanas_pasadas,
        ep.dias_faltantes
    FROM recibido AS r
    JOIN despachador AS d ON r.idDE = d.idDE
    CROSS JOIN LATERAL (
        SELECT * FROM establecerPorcentaje(r.lugar, r.KilosEn, r.fecSoli, r.fecRec)
    ) AS ep;








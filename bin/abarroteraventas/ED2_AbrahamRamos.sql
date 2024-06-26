DROP DATABASE IF EXISTS `recicladora`;
CREATE DATABASE `recicladora`;
USE `recicladora`;

DROP TABLE IF EXISTS `pet`;
DROP TABLE IF EXISTS `despachador`;
DROP TABLE IF EXISTS `recibido`;

CREATE TABLE `pet` (
  `idPE` INT UNSIGNED NOT NUL COMMENT 'Identificador de la tabla pet',
  `concepto` VARCHAR(25) NOT NULL COMMENT 'Concepto de la tabla pet',
  `reciclaje` VARCHAR(25) NOT NULL COMMENT 'Reciclaje de la tabla pet',
  `enviado` VARCHAR(25) NOT NULL COMMENT 'Enviado de la tabla pet',
  `fecSal` DATE NOT NULL COMMENT 'Fecha de salida de la tabla pet',
  `kilos` FLOAT NOT NULL COMMENT 'Kilos de la tabla pet',   

    PRIMARY KEY (`idPE`)
) ENGINE = InnoDB DEFAULT charset = utf8mb4;

CREATE TABLE `despachador`(
    `idDE` INT UNSIGNED NOT NULL COMMENT 'Identificador de la tabla despachador',
    `nombre` VARCHAR(25) NOT NULL COMMENT 'Nombre de el despachador',
    `apellido` VARCHAR(25) NOT NULL COMMENT 'Apellido de el despachador',
    `clasificación` VARCHAR(25) NOT NULL COMMENT 'Clasificación de el despachador',
    `fecNac` DATE NOT NULL COMMENT 'Fecha de nacimiento de el despachador',
    `horario` INT NOT NULL COMMENT 'Horario de el despachador',

        PRIMARY KEY (`idDE`)
)ENGINE = InnoDB DEFAULT charset = utf8mb4;

CREATE TABLE `recibido`(
    `idRE` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla recibido',
    `lugar` VARCHAR(25) NOT NULL COMMENT 'Lugar de el recibido',
    `fecSoli` DATE NOT NULL COMMENT 'Fecha de solicitud de el recibido',
    `fecRec` DATE NOT NULL COMMENT 'Fecha de recepción de el recibido',
    `kiloSol` FLOAT NOT NULL COMMENT 'Kilos solicitados de el recibido',
    `KilosEn` FLOAT NOT NULL COMMENT 'Kilos entrega de el recibido',
    `idDE` INT UNSIGNED NOT NULL COMMENT 'Identificador de el despachador',
    `idPE` INT UNSIGNED NOT NULL COMMENT 'Identificador de el pet',

        PRIMARY KEY (`idRE`)
        FOREIGN KEY (`idDE`) REFERENCES `despachador`(`idDE`),
        FOREIGN KEY (`idPE`) REFERENCES `pet`(`idPE`)
)ENGINE = InnoDB DEFAULT charset = utf8mb4;


-- Datos de la tabla `pet`
INSERT INTO `pet` (`idPE`, `concepto`, `reciclaje`, `enviado`, `fecSal`, `kilos`) VALUES
(1, 'Aluminio', 'Comercial', 'Camioneta', '2021-05-01', 10),
(2, 'Laton', 'Comercial', 'Triciclo', '2021-05-02', 20),
(3, 'Bronce', 'Industrial', 'Trailer', '2021-05-03', 30),
(4, 'Rebaba', 'Quimico', 'Trailer', '2021-05-04', 40),
(5, 'Antimonio', 'Quimico', 'Trailer', '2021-05-05', 50);

-- Datos de la tabla `despachador`
INSERT INTO `despachador` (`idDE`, `nombre`, `apellido`, `clasificación`, `fecNac`, `horario`) VALUES
(1, 'Juan', 'Perez', 'Diurno', '1990-01-01', 8),
(2, 'Pedro', 'Lopez', 'Mixto', '1991-01-01', 9),
(3, 'Maria', 'Gomez', 'Vespertino', '1992-01-01', 10),
(4, 'Jose', 'Hernandez', 'Mixto', '1993-01-01', 11),
(5, 'Ana', 'Martinez', 'Diurno', '1994-01-01', 12);

-- Datos de la tabla `recibido`
INSERT INTO `recibido` (`idRE`, `lugar`, `fecSoli`, `fecRec`, `kiloSol`, `KilosEn`, `idDE`, `idPE`) VALUES
(1, 'Sor Juano', '2021-05-01', '2021-05-01', 10, 10, 1, 1),
(2, 'Joya', '2021-05-02', '2021-05-02', 20, 20, 2, 2),
(3, 'Tejalpa', '2021-05-03', '2021-05-03', 30, 30, 3, 3),
(4, 'Temixco', '2021-05-04', '2021-05-04', 40, 40, 4, 4),
(5, 'Cañon de Lobos', '2021-05-05', '2021-05-05', 50, 50, 5, 5);

/*Funciones*/

CREATE FUNCTION petCode(
    in_id INT UNSIGNED,
    in_concepto VARCHAR(25),
    in_reciclaje VARCHAR(25),
    in_enviado VARCHAR(25),
    in_fecSal DATE,
    in_kilos FLOAT
)
RETURNS VARCHAR(20)
BEGIN
    DECLARE code VARCHAR(20);
    SET code = CONCAT(
        UPPER(SUBSTRING(in_concepto, 1, 2)),
        UPPER(SUBSTRING(in_reciclaje, 1, 2)),
        UPPER(SUBSTRING(in_enviado, -1)),
        DATE_FORMAT(in_fecSal, '%y%m%d'),
        REPLACE(DATE_FORMAT(in_fecSal, '%W'), ' ', ''),
        in_kilos
    );
    RETURN code;
END;

CREATE FUNCTION despachadorcode(
    in_id INT UNSIGNED,
    in_nombre VARCHAR(25),
    in_apellido VARCHAR(25),
    in_clasificacion VARCHAR(25),
    in_fecNac DATE,
    in_horario INT
)
RETURNS VARCHAR(20)
BEGIN
    DECLARE code VARCHAR(20);
    SET code = CONCAT(
        UPPER(SUBSTRING(in_nombre, 1, 2)),
        UPPER(SUBSTRING(in_apellido, 1, 2)),
        UPPER(SUBSTRING(in_clasificacion, -1)),
        DATE_FORMAT(in_fecNac, '%y%m%d'),
        REPLACE(DATE_FORMAT(in_fecNac, '%W'), ' ', ''),
        in_horario
    );
    RETURN code;
END;

SELECT *, generate_pet_code(idPE, concepto, reciclaje, enviado, fecSal, kilos) AS pet_code
FROM pet;

SELECT *, generate_despachador_code(idDE, nombre, apellido, clasificación, fecNac, horario) AS despachador_code
FROM despachador;

CREATE FUNCTION pagoNomina(
    in_id INT UNSIGNED,
    in_nombre VARCHAR(25),
    in_apellido VARCHAR(25),
    in_clasificacion VARCHAR(25),
    in_fecNac DATE,
    in_horas_trabajadas INT
)
RETURNS TABLE (
    horas_dobles INT,
    pago_horas_dobles DECIMAL(10, 2),
    horas_triples INT,
    pago_horas_triples DECIMAL(10, 2),
    salario_base DECIMAL(10, 2),
    imss DECIMAL(10, 2),
    isr DECIMAL(10, 2),
    pago_total DECIMAL(10, 2)
)BEGIN
    DECLARE costo_hora DECIMAL(10, 2);
    DECLARE horas_normales INT;
    DECLARE horas_extras INT;
    DECLARE horas_triples INT;
    DECLARE pago_horas_normales DECIMAL(10, 2);
    DECLARE pago_horas_extras DECIMAL(10, 2);
    DECLARE pago_horas_triples DECIMAL(10, 2);
    DECLARE salario_base DECIMAL(10, 2);
    DECLARE imss DECIMAL(10, 2);
    DECLARE isr DECIMAL(10, 2);
    DECLARE pago_total DECIMAL(10, 2);
    
    CASE in_clasificacion
        WHEN 'Diurno' THEN SET costo_hora = 100;
        WHEN 'Mixto' THEN SET costo_hora = 110;
        WHEN 'Matutino' THEN SET costo_hora = 130;
        ELSE SET costo_hora = 70;
    END CASE;
    
    IF in_horas_trabajadas <= 45 THEN
        SET horas_normales = in_horas_trabajadas;
        SET horas_extras = 0;
        SET horas_triples = 0;
    ELSE
        SET horas_normales = 45;
        SET horas_extras = in_horas_trabajadas - 45;
        SET horas_triples = horas_extras - 5;
        IF horas_triples < 0 THEN
            SET horas_triples = 0;
        END IF;
    END IF;
    
    SET pago_horas_normales = horas_normales * costo_hora;
    SET pago_horas_extras = horas_extras * (costo_hora * 2);
    SET pago_horas_triples = horas_triples * (costo_hora * 3);
    
    SET salario_base = pago_horas_normales + pago_horas_extras + pago_horas_triples;
    
    SET imss = salario_base * 0.13;
    SET isr = salario_base * 0.07;
    
    SET pago_total = salario_base - imss - isr;
    
    RETURN TABLE (
        horas_dobles := horas_extras - horas_triples,
        pago_horas_dobles := pago_horas_extras - pago_horas_triples,
        horas_triples := horas_triples,
        pago_horas_triples := pago_horas_triples,
        salario_base := salario_base,
        imss := imss,
        isr := isr,
        pago_total := pago_total
    );
END;

SELECT *, pagoNomina(idDE, nombre, apellido, clasificación, fecNac, horario) AS nomina FROM despachador;

CREATE FUNCTION calcularPagoReciclado(
    in_kilosSolicitados FLOAT,
    in_kilosReciclados FLOAT,
    in_fechaSolicitud DATE
)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE costoLitro DECIMAL(10, 2);
    DECLARE pagoTotal DECIMAL(10, 2);
    
    DECLARE diaSemana VARCHAR(10);
    SET diaSemana = DATE_FORMAT(in_fechaSolicitud, '%W');
    
    DECLARE mesDia VARCHAR(5);
    SET mesDia = DATE_FORMAT(in_fechaSolicitud, '%m-%d');
    
    DECLARE esFestivo BOOLEAN;
    SET esFestivo = (mesDia = '09-15' OR mesDia = '10-02' OR mesDia = '11-30');
    
    CASE
        WHEN diaSemana IN ('Thursday', 'Friday', 'Saturday') THEN SET costoLitro = 1;
        WHEN diaSemana = 'Monday' THEN SET costoLitro = 3;
        WHEN esFestivo THEN SET costoLitro = 6;
        ELSE SET costoLitro = 2;
    END CASE;
    
    SET pagoTotal = (in_kilosReciclados * costoLitro);
    
    RETURN pagoTotal;
END;

SELECT *, calcularPagoReciclado(kiloSol, KilosEn, fecSoli) AS pago_reciclado FROM recibido;




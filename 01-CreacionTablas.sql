-- BD2 Avance 1 - Grupo 11: creacion de tablas
DROP TABLE IF EXISTS reclamo, transaccion_millas, cuenta_millas,
    miembro_programa, nivel_tier, hub, aeropuerto, region CASCADE;

-- Tablas comunes
CREATE TABLE region (
    id_region      SMALLINT     PRIMARY KEY,
    nombre_region  VARCHAR(10)  NOT NULL UNIQUE
        CHECK (nombre_region IN ('ESTE', 'CENTRAL', 'OESTE'))
);

CREATE TABLE aeropuerto (
    codigo_iata  CHAR(3)      PRIMARY KEY,
    ciudad       VARCHAR(40)  NOT NULL,
    id_region    SMALLINT     NOT NULL REFERENCES region(id_region)
);

CREATE TABLE hub (
    id_hub       SMALLINT  PRIMARY KEY,
    codigo_iata  CHAR(3)   NOT NULL UNIQUE REFERENCES aeropuerto(codigo_iata)
);

-- Tablas del grupo 11
CREATE TABLE nivel_tier (
    id_tier          SMALLINT      PRIMARY KEY,
    nombre_tier      VARCHAR(20)   NOT NULL UNIQUE,
    millas_minimas   INTEGER       NOT NULL CHECK (millas_minimas >= 0),
    bono_porcentaje  NUMERIC(5,2)  NOT NULL CHECK (bono_porcentaje >= 0)
);

CREATE TABLE miembro_programa (
    id_miembro         BIGINT        PRIMARY KEY,
    numero_socio       CHAR(8)       NOT NULL UNIQUE,
    nombre             VARCHAR(40)   NOT NULL,
    apellido           VARCHAR(40)   NOT NULL,
    email              VARCHAR(100)  NOT NULL UNIQUE,
    fecha_nacimiento   DATE          NOT NULL,
    fecha_inscripcion  DATE          NOT NULL,
    id_tier            SMALLINT      NOT NULL REFERENCES nivel_tier(id_tier),
    aeropuerto_base    CHAR(3)       NOT NULL REFERENCES aeropuerto(codigo_iata),
    CHECK (fecha_inscripcion > fecha_nacimiento)
);

CREATE TABLE cuenta_millas (
    id_cuenta                BIGINT     PRIMARY KEY,
    id_miembro               BIGINT     NOT NULL UNIQUE REFERENCES miembro_programa(id_miembro),
    saldo_millas             INTEGER    NOT NULL CHECK (saldo_millas >= 0),
    millas_acumuladas_total  INTEGER    NOT NULL CHECK (millas_acumuladas_total >= 0),
    fecha_ultimo_movimiento  TIMESTAMP  NOT NULL
);

-- Tabla de mayor volumen (atributos obligatorios + canal)
CREATE TABLE transaccion_millas (
    id_transaccion     BIGINT       PRIMARY KEY,
    id_miembro         BIGINT       NOT NULL REFERENCES miembro_programa(id_miembro),
    tipo_movimiento    VARCHAR(20)  NOT NULL
        CHECK (tipo_movimiento IN ('ACUMULACION', 'BONIFICACION', 'CANJE')),
    millas             INTEGER      NOT NULL CHECK (millas > 0),
    fecha_transaccion  TIMESTAMP    NOT NULL,
    canal              VARCHAR(15)  NOT NULL
        CHECK (canal IN ('VUELO', 'TARJETA', 'PROMOCION', 'WEB', 'APP', 'AEROPUERTO'))
);

CREATE TABLE reclamo (
    id_reclamo      BIGINT        PRIMARY KEY,
    codigo_reclamo  CHAR(10)      NOT NULL UNIQUE,
    id_miembro      BIGINT        NOT NULL REFERENCES miembro_programa(id_miembro),
    categoria       VARCHAR(30)   NOT NULL,
    descripcion     VARCHAR(200)  NOT NULL,
    fecha_apertura  TIMESTAMP     NOT NULL,
    fecha_cierre    TIMESTAMP,
    estado          VARCHAR(20)   NOT NULL
        CHECK (estado IN ('ABIERTO', 'EN_PROCESO', 'CERRADO')),
    CHECK ( (estado = 'CERRADO' AND fecha_cierre > fecha_apertura)
         OR (estado <> 'CERRADO' AND fecha_cierre IS NULL) )
);

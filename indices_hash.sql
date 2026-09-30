-- ============================================================
-- INSTRUCCIONES:
-- 1. NO ejecutar todo el archivo de una vez (Ctrl+A + F5).
-- 2. Seleccionar CADA BLOQUE con el mouse y presionar F5.
-- 3. Capturar los resultados de los bloques 1, 3, 4a, 4b y 5.
-- ============================================================
-- ============================================================
-- BLOQUE 0: Eliminar índices Hash previos (si existen)
-- ============================================================
DROP INDEX IF EXISTS idx_hash_reclamo_categoria;
DROP INDEX IF EXISTS idx_hash_transaccion_tipo_movimiento;

-- ============================================================
-- BLOQUE 1: EXPLAIN ANALYZE sin índices Hash
-- Objetivo: registrar el plan base del optimizador
-- ============================================================

-- Consulta 1: reclamo.categoria (6 valores distintos)
EXPLAIN ANALYZE 
SELECT * FROM reclamo 
WHERE categoria = 'MILLAS_NO_ACREDITADAS';

-- Consulta 2: transaccion_millas.tipo_movimiento (3 valores distintos)
EXPLAIN ANALYZE 
SELECT * FROM transaccion_millas 
WHERE tipo_movimiento = 'ACUMULACION';

-- ============================================================
-- BLOQUE 2: Creación de índices Hash
-- ============================================================

-- Índice 1: reclamo.categoria
-- Columna usada en filtros frecuentes de reclamos por tipo.
-- Tiene 6 valores distintos → baja cardinalidad relativa.
-- Sirve para demostrar que Hash ayuda en igualdad exacta pero el optimizador puede preferir Seq Scan si la selectividad es baja.

CREATE INDEX idx_hash_reclamo_categoria 
ON reclamo USING hash(categoria);

-- Índice 2: transaccion_millas.tipo_movimiento
-- Columna con solo 3 valores (ACUMULACION, BONIFICACION, CANJE).
-- Es el caso donde el índice Hash NO ayuda porque cada valor cubre ~33% de la tabla.

CREATE INDEX idx_hash_transaccion_tipo_movimiento 
ON transaccion_millas USING hash(tipo_movimiento);

-- ============================================================
-- BLOQUE 3: Mostrar índices creados con pg_indexes
-- ============================================================
SELECT tablename, indexname, indexdef 
FROM pg_indexes 
WHERE tablename IN ('reclamo', 'transaccion_millas')
ORDER BY tablename, indexname;

-- ============================================================
-- BLOQUE 4a: EXPLAIN ANALYZE con índice, sin forzar nada
-- El optimizador decide libremente
-- ============================================================
EXPLAIN ANALYZE 
SELECT * FROM reclamo 
WHERE categoria = 'MILLAS_NO_ACREDITADAS';

EXPLAIN ANALYZE 
SELECT * FROM transaccion_millas 
WHERE tipo_movimiento = 'ACUMULACION';

-- ============================================================
-- BLOQUE 4b: Forzando el uso del índice (deshabilitar SeqScan)
-- Objetivo: demostrar si el índice es usable aunque el optimizador prefiera Seq Scan por costo.
-- ============================================================

SET enable_seqscan = off;

EXPLAIN ANALYZE 
SELECT * FROM reclamo 
WHERE categoria = 'MILLAS_NO_ACREDITADAS';

EXPLAIN ANALYZE 
SELECT * FROM transaccion_millas 
WHERE tipo_movimiento = 'ACUMULACION';

SET enable_seqscan = on;   

-- ============================================================
-- BLOQUE 5: Tamaño real de los índices Hash
-- ============================================================
SELECT 
    'idx_hash_reclamo_categoria' AS indice,
    pg_relation_size('idx_hash_reclamo_categoria') AS bytes,
    pg_size_pretty(pg_relation_size('idx_hash_reclamo_categoria')) AS tamano_legible
UNION ALL
SELECT 
    'idx_hash_transaccion_tipo_movimiento',
    pg_relation_size('idx_hash_transaccion_tipo_movimiento'),
    pg_size_pretty(pg_relation_size('idx_hash_transaccion_tipo_movimiento'));
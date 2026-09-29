-- BD2 Avance 1 - Grupo 11: verificacion de datos
SELECT 'region' AS tabla, COUNT(*) AS filas FROM region
UNION ALL SELECT 'aeropuerto', COUNT(*) FROM aeropuerto
UNION ALL SELECT 'hub', COUNT(*) FROM hub
UNION ALL SELECT 'nivel_tier', COUNT(*) FROM nivel_tier
UNION ALL SELECT 'miembro_programa', COUNT(*) FROM miembro_programa
UNION ALL SELECT 'cuenta_millas', COUNT(*) FROM cuenta_millas
UNION ALL SELECT 'transaccion_millas', COUNT(*) FROM transaccion_millas
UNION ALL SELECT 'reclamo', COUNT(*) FROM reclamo;

-- Las tres siguientes deben dar 0
SELECT COUNT(*) AS saldos_incorrectos
FROM cuenta_millas c
JOIN (SELECT id_miembro,
             SUM(CASE WHEN tipo_movimiento = 'CANJE' THEN -millas ELSE millas END) AS saldo
      FROM transaccion_millas GROUP BY id_miembro) t USING (id_miembro)
WHERE c.saldo_millas <> t.saldo;

SELECT COUNT(*) AS transacciones_antes_de_inscripcion
FROM transaccion_millas t
JOIN miembro_programa m USING (id_miembro)
WHERE t.fecha_transaccion < m.fecha_inscripcion;

SELECT COUNT(*) AS niveles_incorrectos
FROM miembro_programa m
JOIN cuenta_millas c USING (id_miembro)
WHERE m.id_tier <> (SELECT MAX(id_tier) FROM nivel_tier
                    WHERE c.millas_acumuladas_total >= millas_minimas);

SELECT tipo_movimiento, COUNT(*) FROM transaccion_millas GROUP BY 1 ORDER BY 2 DESC;

SELECT nt.nombre_tier, COUNT(*) AS miembros
FROM miembro_programa m JOIN nivel_tier nt USING (id_tier)
GROUP BY nt.id_tier, nt.nombre_tier ORDER BY nt.id_tier;

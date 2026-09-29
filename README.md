# BD2 – Avance 1 – Grupo 11

Base de datos del subsistema **Fidelización y Atención al Cliente** (PostgreSQL 16).

## Archivos

| Archivo | Para qué sirve |
|---|---|
| `bd2_g11.dump` | Respaldo de la base completa (lo que vas a cargar) |
| `01_crear_tablas.sql` | Crea las tablas |
| `02_insertar_datos.sql` | Inserta los datos |
| `03_verificar_datos.sql` | Revisa que todo cargó bien |

## Cómo cargar la base

**1. Descargar**
Botón verde **Code** → **Download ZIP**. Descomprime el ZIP en tu Escritorio.

**2. Instalar PostgreSQL 16.15**
Descárgalo desde postgresql.org → Download → Windows (o Mac) → versión **16.15**.
Durante la instalación desmarca *Stack Builder* y anota la contraseña.
⚠️ Tiene que ser la 16, no la 17 ni la 18.

**3. Crear la base en pgAdmin**
Dentro de **PostgreSQL 16**: clic derecho en *Databases* → *Create* → *Database* → nombre `bd2_g11`.

**4. Restaurar**
Clic derecho en `bd2_g11` → *Restore* → elige `bd2_g11.dump` → *Restore*.

**5. Verificar**
Clic derecho en `bd2_g11` → *Query Tool* → abre `03_verificar_datos.sql`.
Selecciona la primera consulta y presiona **F5**: debe decir **10033** en `transaccion_millas`.

> Si el Restore falla: ejecuta `01_crear_tablas.sql` y luego `02_insertar_datos.sql` en el Query Tool de `bd2_g11`. El resultado es el mismo.

## Reglas del equipo

- Cada uno trabaja en **su propia copia** de la base.
- **No cambien las tablas ni los datos.** Si necesitan algo, avisen en el grupo.
- Cada quien sube sus scripts y capturas a su carpeta (`p2/`, `p3/`, ...).

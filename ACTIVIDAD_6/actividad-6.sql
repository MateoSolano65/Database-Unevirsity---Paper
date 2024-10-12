-- Punto 1: Crear Vistas
USE PapeleriaDB;
-- 1. Crear una vista para ver todas las ventas realizadas con el nombre del cliente y el nombre del proveedor del producto
IF OBJECT_ID('VentasConClienteYProveedor', 'V') IS NOT NULL
BEGIN
    DROP VIEW VentasConClienteYProveedor;
END;
GO

CREATE VIEW VentasConClienteYProveedor AS
SELECT 
    v.venta_id, 
    c.nombre AS nombre_cliente, 
    p.nombre AS nombre_producto, 
    pr.nombre AS nombre_proveedor, 
    v.fecha, 
    v.cantidad, 
    v.total
FROM Venta v
JOIN Cliente c ON v.cliente_id = c.cliente_id
JOIN Producto p ON v.producto_id = p.producto_id
JOIN Proveedor pr ON p.proveedor_id = pr.proveedor_id;
GO

-- 2. Crear una vista que permita ver las ventas registradas el día actual (hoy)
IF OBJECT_ID('VentasDeHoy', 'V') IS NOT NULL
BEGIN
    DROP VIEW VentasDeHoy;
END;
GO

CREATE VIEW VentasDeHoy AS
SELECT 
    v.venta_id, 
    c.nombre AS nombre_cliente, 
    p.nombre AS nombre_producto, 
    v.fecha, 
    v.cantidad, 
    v.total
FROM Venta v
JOIN Cliente c ON v.cliente_id = c.cliente_id
JOIN Producto p ON v.producto_id = p.producto_id
WHERE v.fecha = CAST(GETDATE() AS DATE);
GO

USE UniversityDB;

-- 3. Crear una vista con los cursos creados por programa
IF OBJECT_ID('CursosPorPrograma', 'V') IS NOT NULL
BEGIN
    DROP VIEW CursosPorPrograma;
END;
GO

CREATE VIEW CursosPorPrograma AS
SELECT 
    p.nombre AS nombre_programa, 
    c.nombre AS nombre_curso
FROM Cursos c
JOIN Modulos m ON c.modulo_id = m.modulo_id
JOIN Programas p ON m.programa_id = p.programa_id;
GO

-- 4. Crear una vista para ver todos los estudiantes matriculados en los cursos, incluyendo el programa asociado
IF OBJECT_ID('EstudiantesMatriculadosEnCursos', 'V') IS NOT NULL
BEGIN
    DROP VIEW EstudiantesMatriculadosEnCursos;
END;
GO

CREATE VIEW EstudiantesMatriculadosEnCursos AS
SELECT 
    u.nombre AS nombre_estudiante, 
    p.nombre AS nombre_programa, 
    c.nombre AS nombre_curso, 
    m.fecha AS fecha_matricula
FROM Matricula m
JOIN Usuarios u ON m.usuario_id = u.usuario_id
JOIN Cursos c ON m.curso_id = c.curso_id
JOIN Modulos mo ON c.modulo_id = mo.modulo_id
JOIN Programas p ON mo.programa_id = p.programa_id;
GO

-- 5. Crear una vista para ver el número total de cursos con estudiantes por programas
IF OBJECT_ID('NumeroDeCursosConEstudiantesPorPrograma', 'V') IS NOT NULL
BEGIN
    DROP VIEW NumeroDeCursosConEstudiantesPorPrograma;
END;
GO

CREATE VIEW NumeroDeCursosConEstudiantesPorPrograma AS
SELECT 
	  p.programa_id,
    p.nombre AS nombre_programa,
    COUNT(DISTINCT c.curso_id) AS numero_total_cursos_con_estudiantes
FROM Matricula m
JOIN Cursos c ON m.curso_id = c.curso_id
JOIN Modulos mo ON c.modulo_id = mo.modulo_id
JOIN Programas p ON mo.programa_id = p.programa_id
GROUP BY p.nombre, p.programa_id;
GO

-- Punto 2: Sentencias SQL requeridas

USE PapeleriaDB;

-- 1. Identificar los productos que no se han vendido
SELECT *
FROM Producto p
WHERE NOT EXISTS (
    SELECT 1 FROM Venta v WHERE v.producto_id = p.producto_id
);
GO

-- 2. Identificar los proveedores con productos que no se han vendido y ordenarlos descendentemente (en mayúsculas)
SELECT DISTINCT UPPER(pr.nombre) AS nombre_proveedor
FROM Proveedor pr
JOIN Producto p ON pr.proveedor_id = p.proveedor_id
WHERE NOT EXISTS (
    SELECT 1 FROM Venta v WHERE v.producto_id = p.producto_id
)
ORDER BY nombre_proveedor DESC;
GO

-- 3. Identificar los clientes que no han comprado productos
SELECT *
FROM Cliente c
WHERE NOT EXISTS (
    SELECT 1 FROM Venta v WHERE v.cliente_id = c.cliente_id
);
GO

-- 4. Identificar los clientes que han comprado en días diferentes y ordenarlos descendentemente
SELECT c.cliente_id, c.nombre, COUNT(DISTINCT v.fecha) AS dias_comprados
FROM Cliente c
JOIN Venta v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nombre
HAVING COUNT(DISTINCT v.fecha) > 1
ORDER BY dias_comprados DESC;
GO

-- 5. Identificar los clientes con el precio del pedido superior al precio medio de todas las ventas
SELECT DISTINCT c.cliente_id, c.nombre
FROM Cliente c
JOIN Venta v ON c.cliente_id = v.cliente_id
WHERE v.total > (SELECT AVG(total) FROM Venta);
GO

USE UniversityDB;
-- 6. Identificar los cursos abiertos con el No. de estudiantes matriculados
SELECT c.curso_id, c.nombre, COUNT(m.usuario_id) AS numero_estudiantes
FROM Cursos c
LEFT JOIN Matricula m ON c.curso_id = m.curso_id
GROUP BY c.curso_id, c.nombre;
GO

-- Ejecicio 6 Utilizando la vista creada
SELECT 
    c.curso_id, 
    c.nombre AS nombre_curso, 
    COUNT(emc.nombre_estudiante) AS numero_estudiantes
FROM Cursos c
LEFT JOIN EstudiantesMatriculadosEnCursos emc ON c.nombre = emc.nombre_curso
GROUP BY c.curso_id, c.nombre;
GO


-- 7. Identificar los programas que tienen estudiantes sin cursos matriculados
SELECT DISTINCT p.programa_id, p.nombre
FROM Programas p
JOIN Modulos mo ON p.programa_id = mo.programa_id
JOIN Cursos c ON mo.modulo_id = c.modulo_id
JOIN Usuarios u ON u.id_rol_usuario = 2 -- estudiantes
WHERE NOT EXISTS (
    SELECT 1 FROM Matricula m WHERE m.usuario_id = u.usuario_id AND m.curso_id = c.curso_id
);
GO

-- Ejecicio 7 Utilizando la vista creada
SELECT DISTINCT p.programa_id, p.nombre AS nombre_programa
FROM Programas p
JOIN Modulos mo ON p.programa_id = mo.programa_id
JOIN Cursos c ON mo.modulo_id = c.modulo_id
JOIN Usuarios u ON u.id_rol_usuario = 2 -- estudiantes
LEFT JOIN EstudiantesMatriculadosEnCursos emc ON u.nombre = emc.nombre_estudiante AND emc.nombre_curso = c.nombre
WHERE emc.nombre_curso IS NULL;
GO

-- 8. Identificar las materias con el mayor número de cursos con estudiantes matriculados
SELECT TOP 1 mo.nombre AS nombre_modulo, COUNT(DISTINCT c.curso_id) AS numero_cursos
FROM Modulos mo
JOIN Cursos c ON mo.modulo_id = c.modulo_id
JOIN Matricula m ON c.curso_id = m.curso_id
GROUP BY mo.nombre
ORDER BY numero_cursos DESC;
GO

-- Ejecicio 8 Utilizando la vista creada
SELECT TOP 1 mo.nombre AS nombre_modulo, COUNT(DISTINCT c.curso_id) AS numero_cursos
FROM Modulos mo
JOIN Cursos c ON mo.modulo_id = c.modulo_id
JOIN NumeroDeCursosConEstudiantesPorPrograma nc ON mo.programa_id = nc.programa_id
GROUP BY mo.nombre
ORDER BY numero_cursos DESC;
GO


USE PapeleriaDB;

-- 9. Crear una sentencia SQL que use la función HAVING en la base de datos de Ventas y explicarla
SELECT cliente_id, COUNT(venta_id) AS total_ventas
FROM Venta
GROUP BY cliente_id
HAVING COUNT(venta_id) > 1;
-- Explicación: Esta consulta muestra los clientes que han realizado más de una compra. Utilizamos HAVING para filtrar los grupos de clientes con más de una venta.
GO

USE UniversityDB;

-- 10. Crear una sentencia SQL que muestre datos de todas las tablas de la base de datos Universidad por medio de JOIN
SELECT 
    u.nombre AS estudiante, 
    r.nombre AS rol, 
    p.nombre AS programa, 
    mo.nombre AS modulo, 
    c.nombre AS curso, 
    m.fecha AS fecha_matricula
FROM Usuarios u
JOIN Rol_Usuario r ON u.id_rol_usuario = r.id
LEFT JOIN Matricula m ON u.usuario_id = m.usuario_id
LEFT JOIN Cursos c ON m.curso_id = c.curso_id
LEFT JOIN Modulos mo ON c.modulo_id = mo.modulo_id
LEFT JOIN Programas p ON mo.programa_id = p.programa_id;
-- Explicación: Esta consulta busca mostrar información completa de los estudiantes, incluyendo su rol, el programa en el que están inscritos, los módulos y los cursos matriculados. Utiliza LEFT JOIN para garantizar que todos los estudiantes sean incluidos, incluso si no están matriculados en algún curso.
GO

-- Ejecicio 10 Utilizando la vista creada
SELECT 
    emc.nombre_estudiante AS estudiante, 
    r.nombre AS rol, 
    emc.nombre_programa AS programa, 
    mo.nombre AS modulo,
    emc.nombre_curso AS curso, 
    emc.fecha_matricula
FROM EstudiantesMatriculadosEnCursos emc
JOIN Usuarios u ON emc.nombre_estudiante = u.nombre
JOIN Rol_Usuario r ON u.id_rol_usuario = r.id
LEFT JOIN Cursos c ON emc.nombre_curso = c.nombre
LEFT JOIN Modulos mo ON c.modulo_id = mo.modulo_id;
GO
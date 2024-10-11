-- Punto 2: Sentencias SQL requeridas

USE PapeleriaDB;

-- 1. Identificar el No. de productos asociados a cada proveedor
SELECT p.nombre AS proveedor, COUNT(prod.producto_id) AS num_productos
FROM Proveedor p
LEFT JOIN Producto prod ON p.proveedor_id = prod.proveedor_id
GROUP BY p.nombre;

-- 2. Identificar el valor promedio de todas las ventas totales
SELECT AVG(total) AS promedio_ventas_totales
FROM Venta;

-- 3. Identificar los tres (o más) días en los que se registran mayor número de productos vendidos
SELECT TOP 3 fecha, SUM(cantidad) AS total_productos
FROM Venta
GROUP BY fecha
ORDER BY total_productos DESC;

-- 4. Identificar los tres (o más) clientes que registran mayores ventas
SELECT TOP 3 c.nombre AS cliente, SUM(v.total) AS total_ventas
FROM Cliente c
JOIN Venta v ON c.cliente_id = v.cliente_id
GROUP BY c.nombre
ORDER BY total_ventas DESC;



USE UniversityDB;
-- 5. Identificar los programas por facultades
SELECT f.nombre AS facultad, p.nombre AS programa
FROM Facultades f
JOIN Programas p ON f.facultad_id = p.facultad_id
ORDER BY f.nombre;

-- 6. Identificar los estudiantes matriculados en cursos del programa Ingeniería de Sistemas
SELECT u.nombre AS estudiante, c.nombre AS curso, p.nombre AS programa
FROM Usuarios u
JOIN Matricula m ON u.usuario_id = m.usuario_id
JOIN Cursos c ON m.curso_id = c.curso_id
JOIN Modulos mo ON c.modulo_id = mo.modulo_id
JOIN Programas p ON mo.programa_id = p.programa_id
WHERE p.nombre = 'Ingenieria de Sistemas';

-- 7. Identificar todos los cursos con estudiantes matriculados, este listado debe relacionar el No. de estudiantes por curso
SELECT c.nombre AS curso, COUNT(m.usuario_id) AS num_estudiantes
FROM Cursos c
JOIN Matricula m ON c.curso_id = m.curso_id
GROUP BY c.nombre;

-- 8. Identificar el No. de materias matriculadas a cada estudiante
SELECT u.nombre AS estudiante, COUNT(m.curso_id) AS num_materias
FROM Usuarios u
JOIN Matricula m ON u.usuario_id = m.usuario_id
WHERE u.id_rol_usuario = (SELECT id FROM Rol_Usuario where nombre = 'Estudiante') -- estudiantes
GROUP BY u.nombre;

-- 9. Identificar los estudiantes que no tienen materias matriculadas
SELECT u.nombre AS estudiante, m.curso_id, c.nombre AS curso_nombre
FROM Usuarios u
LEFT JOIN Matricula m ON u.usuario_id = m.usuario_id
LEFT JOIN Cursos c ON c.curso_id = m.curso_id
WHERE m.matricula_id IS NULL AND u.id_rol_usuario = (SELECT id FROM Rol_Usuario where nombre = 'Estudiante') -- estudiantes

-- 10. Identificar el No. de estudiantes a cargo de cada profesor en cada curso
SELECT u.nombre AS profesor, c.nombre AS curso, COUNT(m.usuario_id) AS num_estudiantes
FROM Usuarios u
JOIN Rol_Usuario r ON u.id_rol_usuario = r.id AND r.nombre = 'Profesor'
JOIN Clases cl ON u.usuario_id = cl.curso_id
LEFT JOIN Matricula m ON cl.curso_id = m.curso_id
LEFT JOIN Cursos c ON c.curso_id = cl.curso_id
GROUP BY u.nombre, c.nombre
ORDER BY u.nombre, c.nombre;
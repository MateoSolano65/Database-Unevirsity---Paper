-- ============================================
-- SQL Script para crear esquemas para la gestión de ventas y actividades universitarias
-- 
-- Autores: [Jesús Mateo Solano Martínez][Id_Banner:100142790] y [Santiago Guerrero Pulgarín][Id_Banner:100141677]
-- Fecha: [09/10/2024]
-- 
-- Este script crea dos esquemas diferentes para gestionar las ventas en una papelería y las actividades de una universidad.
-- Está diseñado para ser idempotente, lo que significa que se puede ejecutar de forma segura múltiples veces sin causar errores ni duplicar datos.
-- Se proporcionan comentarios detallados para facilitar la comprensión de cada parte del script.
-- ============================================

/*
Se usa SQL server para la creación de la base de datos y las tablas, se crean dos bases de datos, 
una para la gestión de ventas de una papelería y otra para la gestión de actividades universitarias.
*/

-- Parte 1: Esquema de Base de Datos para la Gestión de Ventas

-- Crear la base de datos de ventas (si no existe)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PapeleriaDB')
BEGIN
    CREATE DATABASE PapeleriaDB;
END;
GO

USE PapeleriaDB;
GO

-- Crear tablas (si no existen)

-- Tabla: Proveedor
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Proveedor')
BEGIN
    CREATE TABLE Proveedor (
        proveedor_id INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(100) NOT NULL,
        direccion VARCHAR(150),
        telefono VARCHAR(15),
        email VARCHAR(100)
    );
END;
GO

-- Tabla: Producto
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Producto')
BEGIN
    CREATE TABLE Producto (
        producto_id INT PRIMARY KEY IDENTITY,
        proveedor_id INT,
        nombre VARCHAR(100) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL,
        stock INT NOT NULL,
        FOREIGN KEY (proveedor_id) REFERENCES Proveedor(proveedor_id)
    );
END;
GO

-- Tabla: Cliente
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Cliente')
BEGIN
    CREATE TABLE Cliente (
        cliente_id INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(100) NOT NULL,
        direccion VARCHAR(150),
        telefono VARCHAR(15),
        email VARCHAR(100)
    );
END;
GO

-- Tabla: Venta
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Venta')
BEGIN
    CREATE TABLE Venta (
        venta_id INT PRIMARY KEY IDENTITY,
        cliente_id INT,
        producto_id INT,
        fecha DATE NOT NULL,
        cantidad INT NOT NULL,
        total DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
        FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
    );
END;
GO

-- Insertar datos de ejemplo para fines de prueba
-- Nota: Utilizamos un chequeo previo para evitar duplicados si el script se ejecuta varias veces.
IF NOT EXISTS (SELECT * FROM Proveedor WHERE nombre = 'Proveedor 011')
BEGIN
    INSERT INTO Proveedor (nombre, direccion, telefono, email) VALUES
    ('Proveedor 011', 'Calle Falsa 123', '5551234567', 'contacto@proveedora.com'),
    ('Proveedor 012', 'Avenida Siempre Viva 742', '5559876543', 'info@proveedorb.com'),
    ('Proveedor 013', 'Boulevard de los Sueños Rotos 456', '5557654321', 'ventas@proveedorc.com'),
    ('Proveedor 014', 'Calle de la Amargura 789', '5558765432', 'soporte@proveedord.com'),
    ('Proveedor 015', 'Avenida de la Paz 101', '5552345678', 'contacto@proveedore.com'),
    ('Proveedor 016', 'Calle del Sol 202', '5553456789', 'info@proveedorf.com'),
    ('Proveedor 017', 'Avenida de la Luna 303', '5554567890', 'ventas@proveedorg.com');
END;
GO

IF NOT EXISTS (SELECT * FROM Producto WHERE nombre = 'Cuaderno')
BEGIN
    INSERT INTO Producto (proveedor_id, nombre, precio, stock) VALUES
    (1, 'Cuaderno', 3.50, 100),
    (2, 'Lápiz', 0.50, 500),
    (3, 'Bolígrafo', 1.20, 300),
    (4, 'Borrador', 0.75, 200),
    (5, 'Regla', 1.00, 150),
    (6, 'Tijeras', 2.50, 80),
	  (6, 'Cuaderno', 3.50, 100),
    (5, 'Lápiz', 0.50, 500),
    (4, 'Bolígrafo', 1.20, 300),
    (3, 'Borrador', 0.75, 200),
    (2, 'Regla', 1.00, 150),
    (1, 'Tijeras', 2.50, 80),
	  (5, 'Cuaderno', 3.50, 100),
    (4, 'Lápiz', 0.50, 500),
    (3, 'Bolígrafo', 1.20, 300),
    (2, 'Borrador', 0.75, 200),
    (1, 'Regla', 1.00, 150),
    (7, 'Tijeras', 2.50, 80),
    (7, 'Pegamento', 1.75, 120);
END;
GO

IF NOT EXISTS (SELECT * FROM Cliente WHERE nombre = 'Juan Pérez')
BEGIN
    INSERT INTO Cliente (nombre, direccion, telefono, email) VALUES
    ('Juan Pérez', 'Calle del Río 123', '5551112222', 'juan.perez@ejemplo.com'),
    ('María López', 'Avenida del Sol 456', '5553334444', 'maria.lopez@ejemplo.com'),
    ('Carlos García', 'Boulevard de la Luna 789', '5555556666', 'carlos.garcia@ejemplo.com'),
    ('Ana Martínez', 'Calle de las Flores 101', '5557778888', 'ana.martinez@ejemplo.com'),
    ('Luis Fernández', 'Avenida de los Pinos 202', '5559990000', 'luis.fernandez@ejemplo.com');
END;
GO

IF NOT EXISTS (SELECT * FROM Venta WHERE venta_id = 1)
BEGIN
    INSERT INTO Venta (cliente_id, producto_id, fecha, cantidad, total) VALUES
    (1, 1, '2024-10-01', 2, 7.00),
    (2, 2, '2024-10-02', 10, 5.00),
    (3, 3, '2024-10-03', 5, 6.00),
    (4, 4, '2024-10-04', 3, 2.25),
    (5, 5, '2024-10-05', 4, 4.00),
    (1, 6, '2024-10-06', 1, 2.50),
    (2, 7, '2024-10-07', 2, 3.50);
END;
GO

-- Parte 2: Esquema de Base de Datos para la Gestión Universitaria

-- Crear la base de datos de la universidad (si no existe)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'UniversityDB')
BEGIN
    CREATE DATABASE UniversityDB;
END;
GO

USE UniversityDB;
GO

-- Crear tablas (si no existen)

-- Tabla: Facultades
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Facultades')
BEGIN
    CREATE TABLE Facultades (
        facultad_id INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(100) NOT NULL
    );
END;
GO

-- Tabla: Programas
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Programas')
BEGIN
    CREATE TABLE Programas (
        programa_id INT PRIMARY KEY IDENTITY,
        facultad_id INT,
        nombre VARCHAR(100) NOT NULL,
        FOREIGN KEY (facultad_id) REFERENCES Facultades(facultad_id)
    );
END;
GO

-- Tabla: Modulos
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Modulos')
BEGIN
    CREATE TABLE Modulos (
        modulo_id INT PRIMARY KEY IDENTITY,
        programa_id INT,
        nombre VARCHAR(100) NOT NULL,
        FOREIGN KEY (programa_id) REFERENCES Programas(programa_id)
    );
END;
GO

-- Tabla: Cursos
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Cursos')
BEGIN
    CREATE TABLE Cursos (
        curso_id INT PRIMARY KEY IDENTITY,
        modulo_id INT,
        nombre VARCHAR(100) NOT NULL,
        FOREIGN KEY (modulo_id) REFERENCES Modulos(modulo_id)
    );
END;
GO

-- Tabla: Rol_Usuario
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Rol_Usuario')
BEGIN
    CREATE TABLE Rol_Usuario (
        id INT PRIMARY KEY NOT NULL,
        nombre NVARCHAR(150) NOT NULL,
        activo BIT NOT NULL,
        create_at DATE NOT NULL
    );
END;
GO

-- Tabla: Usuarios
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Usuarios')
BEGIN
    CREATE TABLE Usuarios (
        usuario_id INT PRIMARY KEY IDENTITY,
        email NVARCHAR(150) NOT NULL,
        id_rol_usuario INT NULL,
        nombre NVARCHAR(150) NOT NULL,
        direccion NVARCHAR(250) NULL,
        telefono NVARCHAR(20) NULL,
        FOREIGN KEY (id_rol_usuario) REFERENCES Rol_Usuario(id)
    );
END;
GO

-- Tabla: Matricula
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Matricula')
BEGIN
    CREATE TABLE Matricula (
        matricula_id INT PRIMARY KEY IDENTITY,
        usuario_id INT,
        curso_id INT,
        fecha DATE NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
        FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id)
    );
END;
GO

-- Tabla: Clases
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Clases')
BEGIN
    CREATE TABLE Clases (
        clase_id INT PRIMARY KEY IDENTITY,
        curso_id INT,
        fecha DATE NOT NULL,
        duracion TIME NOT NULL,
        FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id)
    );
END;
GO

-- Insertar datos de ejemplo para fines de prueba

-- Insertar roles
IF NOT EXISTS (SELECT * FROM Rol_Usuario WHERE id = 1)
BEGIN
    INSERT INTO Rol_Usuario (id, nombre, activo, create_at) VALUES
    (1, 'Profesor', 1, GETDATE()),
    (2, 'Estudiante', 1, GETDATE());
END;
GO

-- Insertar usuarios de ejemplo
IF NOT EXISTS (SELECT * FROM Usuarios WHERE nombre = 'Juan Perez')
BEGIN
    INSERT INTO Usuarios (nombre, email, id_rol_usuario, direccion, telefono) VALUES
    ('Juan Perez', 'juan.perez@ejemplo.com', 2, 'Calle del Río 123', '5551112222'),
	  ('Diego Rodriguez', 'diego.ez@ejemplo.com', 2, 'Calle del Río 123', '5551112222'),
    ('Maria Lopez', 'maria@yopmail.com', 2, 'Calle del Río 123', '5551112222'),
    ('Carlos Garcia', 'carlos@carlos.co', 2, 'Calle del Río 123', '5551112222'),
    ('Maria Garcia', 'maria.garcia@ejemplo.com', 2, 'Avenida del Sol 456', '5553334444'),
    ('Carlos Sanchez', 'carlos.sanchez@ejemplo.com', 1, 'Boulevard de la Luna 789', '5555556666'),
    ('Ana Martinez', 'ana.martinez@ejemplo.com', 2, 'Calle de las Flores 101', '5557778888'),
    ('Luis Fernandez', 'luis.fernandez@ejemplo.com', 1, 'Avenida de los Pinos 202', '5559990000');
END;
GO

-- Insertar Facultades
IF NOT EXISTS (SELECT * FROM Facultades WHERE nombre = 'Facultad de Ingenieria')
BEGIN
    INSERT INTO Facultades (nombre) VALUES
    ('Facultad de Ingenieria'),
    ('Facultad de Ciencias'),
    ('Facultad de Humanidades'),
    ('Facultad de Medicina'),
    ('Facultad de Derecho');
END;
GO

-- Insertar Programas
IF NOT EXISTS (SELECT * FROM Programas WHERE nombre = 'Ingenieria de Sistemas')
BEGIN
    INSERT INTO Programas (facultad_id, nombre) VALUES
    (1, 'Ingenieria de Sistemas'),
    (1, 'Ingenieria Civil'),
    (2, 'Biologia'),
    (2, 'Quimica'),
    (3, 'Historia'),
    (3, 'Filosofia'),
    (4, 'Medicina General'),
    (4, 'Enfermeria'),
    (5, 'Derecho Penal'),
    (5, 'Derecho Civil');
END;
GO

-- Insertar Modulos
IF NOT EXISTS (SELECT * FROM Modulos WHERE nombre = 'Modulo de Programacion')
BEGIN
    INSERT INTO Modulos (programa_id, nombre) VALUES
    (1, 'Modulo de Programacion'),
    (1, 'Modulo de Redes'),
    (2, 'Modulo de Estructuras'),
    (3, 'Modulo de Genetica'),
    (4, 'Modulo de Quimica Organica'),
    (5, 'Modulo de Historia Antigua'),
    (6, 'Modulo de Filosofia Moderna'),
    (7, 'Modulo de Anatomia'),
    (8, 'Modulo de Cuidados Intensivos'),
    (9, 'Modulo de Derecho Penal Internacional'),
    (10, 'Modulo de Derecho Civil Comparado');
END;
GO

-- Insertar Cursos
IF NOT EXISTS (SELECT * FROM Cursos WHERE nombre = 'Programacion en Python')
BEGIN
    INSERT INTO Cursos (modulo_id, nombre) VALUES
    (1, 'Programacion en Python'),
    (1, 'Programacion en Java'),
    (2, 'Redes de Computadoras'),
    (3, 'Estructuras de Hormigon'),
    (4, 'Genetica Molecular'),
    (5, 'Quimica Organica Avanzada'),
    (6, 'Historia de Roma'),
    (7, 'Filosofia del Siglo XX'),
    (8, 'Anatomia Humana'),
    (9, 'Cuidados Intensivos Neonatales'),
    (10, 'Derecho Penal Internacional Avanzado'),
    (11, 'Derecho Civil Comparado en Europa');
END;
GO

-- Insertar Matricula
IF NOT EXISTS (SELECT * FROM Matricula WHERE matricula_id = 1)
BEGIN
    INSERT INTO Matricula (usuario_id, curso_id, fecha) VALUES
    (1, 1, '2024-10-01'),
    (2, 2, '2024-10-02'),
    (3, 3, '2024-10-03'),
    (4, 4, '2024-10-04'),
    (5, 5, '2024-10-05'),
    (1, 6, '2024-10-06'),
    (2, 7, '2024-10-07'),
    (3, 8, '2024-10-08'),
    (4, 9, '2024-10-09'),
    (5, 10, '2024-10-10');
END;
GO

-- Insertar Clases
IF NOT EXISTS (SELECT * FROM Clases WHERE clase_id = 1)
BEGIN
    INSERT INTO Clases (curso_id, fecha, duracion) VALUES
    (1, '2024-10-10', '02:00:00'),
    (2, '2024-10-11', '01:30:00'),
    (3, '2024-10-12', '02:15:00'),
    (4, '2024-10-13', '01:45:00'),
    (5, '2024-10-14', '02:00:00'),
    (6, '2024-10-15', '01:30:00'),
    (7, '2024-10-16', '02:15:00'),
    (8, '2024-10-17', '01:45:00'),
    (9, '2024-10-18', '02:00:00'),
    (10, '2024-10-19', '01:30:00');
END;
GO

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
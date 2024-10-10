/*
SQL Script para crear esquemas para la gestión de ventas y actividades universitarias
Autores: [Jesús Mateo Solano Martínez] y [Santiago Guerrero Pulgarín]
Fecha: [09/10/2024]

Este script crea dos esquemas diferentes para gestionar las ventas en una papelería y las actividades de una universidad.
Está diseñado para ser idempotente, lo que significa que se puede ejecutar de forma segura múltiples veces sin causar errores ni duplicar datos.
Se proporcionan comentarios detallados para facilitar la comprensión de cada parte del script.
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
-- Esta tabla almacena la información de los proveedores que suministran productos a la papelería.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Proveedor' AND xtype='U')
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
-- Esta tabla almacena la información de los productos que vende la papelería.
-- Tiene una relación de muchos a uno con la tabla Proveedor, ya que cada producto tiene un proveedor.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Producto' AND xtype='U')
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
-- Esta tabla almacena la información de los clientes que compran productos en la papelería.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Cliente' AND xtype='U')
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
-- Esta tabla registra las ventas realizadas a los clientes.
-- Tiene relaciones con la tabla Cliente y la tabla Producto para identificar qué cliente compró qué producto.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Venta' AND xtype='U')
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
-- Nota: Utilizamos un chequeo previo para evitar duplicados si el script se ejecuta varias veces. Esto asegura que los datos sean únicos.
IF NOT EXISTS (SELECT * FROM Proveedor WHERE nombre = 'Proveedor A')
BEGIN
INSERT INTO Proveedor (nombre, direccion, telefono, email) VALUES
    ('Proveedor A', 'Calle Falsa 123', '5551234567', 'contacto@proveedora.com'),
    ('Proveedor B', 'Avenida Siempre Viva 742', '5559876543', 'info@proveedorb.com'),
    ('Proveedor C', 'Boulevard de los Sueños Rotos 456', '5557654321', 'ventas@proveedorc.com'),
    ('Proveedor D', 'Calle de la Amargura 789', '5558765432', 'soporte@proveedord.com'),
    ('Proveedor E', 'Avenida de la Paz 101', '5552345678', 'contacto@proveedore.com'),
    ('Proveedor F', 'Calle del Sol 202', '5553456789', 'info@proveedorf.com'),
    ('Proveedor G', 'Avenida de la Luna 303', '5554567890', 'ventas@proveedorg.com');
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
    (7, 'Pegamento', 1.75, 120);
END;
GO

IF NOT EXISTS (SELECT * FROM Cliente WHERE nombre = 'Cliente 1')
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
-- Esta tabla almacena la información de las facultades dentro de la universidad.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Facultades' AND xtype='U')
BEGIN
    CREATE TABLE Facultades (
        facultad_id INT PRIMARY KEY IDENTITY,
        nombre VARCHAR(100) NOT NULL
    );
END;
GO

-- Tabla: Programas
-- Esta tabla almacena la información de los programas académicos que ofrecen las facultades.
-- Tiene una relación de muchos a uno con la tabla Facultades.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Programas' AND xtype='U')
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
-- Esta tabla almacena los módulos pertenecientes a los programas académicos.
-- Tiene una relación de muchos a uno con la tabla Programas.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Modulos' AND xtype='U')
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
-- Esta tabla almacena la información de los cursos que forman parte de los módulos.
-- Tiene una relación de muchos a uno con la tabla Modulos.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Cursos' AND xtype='U')
BEGIN
    CREATE TABLE Cursos (
        curso_id INT PRIMARY KEY IDENTITY,
        modulo_id INT,
        nombre VARCHAR(100) NOT NULL,
        FOREIGN KEY (modulo_id) REFERENCES Modulos(modulo_id)
    );
END;
GO

-- Tabla: Usuarios
-- Esta tabla almacena la información de los usuarios de la universidad (tanto estudiantes como docentes).
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Usuarios' AND xtype='U')
BEGIN
    CREATE TABLE Usuarios (
        usuario_id INT PRIMARY KEY IDENTITY,
        email NVARCHAR(150) NOT NULL,
        id_rol_usuario INT NULL,
        nombre NVARCHAR(150) NOT NULL,
        direccion NVARCHAR(250) NULL,
        telefono NVARCHAR(20) NULL
    );
END;
GO

-- Tabla: Rol_Usuario
-- Esta tabla almacena los roles disponibles dentro de la universidad (solo profesor y estudiante).
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Rol_Usuario' AND xtype='U')
BEGIN
    CREATE TABLE Rol_Usuario (
        id INT PRIMARY KEY NOT NULL,
        nombre NVARCHAR(150) NOT NULL CHECK (nombre IN ('Profesor', 'Estudiante')),
        activo BIT NOT NULL,
        create_at DATE NOT NULL
    );
END;
GO


-- Tabla: Matricula
-- Esta tabla almacena la información de la matrícula de los estudiantes en los cursos.
-- Tiene relaciones con las tablas Usuarios y Cursos.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Matricula' AND xtype='U')
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
-- Esta tabla almacena la información de las clases programadas para los cursos.
-- Tiene una relación de muchos a uno con la tabla Cursos.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Clases' AND xtype='U')
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
-- Nota: Utilizamos un chequeo previo para evitar duplicados si el script se ejecuta varias veces.

-- Insertar roles (solo dos tipos de roles: Profesor y Estudiante)
IF NOT EXISTS (SELECT * FROM Rol_Usuario WHERE nombre = 'Profesor')
BEGIN
    INSERT INTO Rol_Usuario (id, nombre, activo, create_at) VALUES
    (1, 'Profesor', 1, GETDATE()),
    (2, 'Estudiante', 1, GETDATE());
END;
GO

-- Insertar datos de ejemplo para los usuarios
IF NOT EXISTS (SELECT * FROM Usuarios WHERE nombre = 'Juan Perez')
BEGIN
    INSERT INTO Usuarios (nombre, email, id_rol_usuario, direccion, telefono) VALUES
    ('Juan Perez', 'juan.perez@ejemplo.com', 2, 'Calle del Río 123', '5551112222'),
    ('Maria Garcia', 'maria.garcia@ejemplo.com', 2, 'Avenida del Sol 456', '5553334444'),
    ('Carlos Sanchez', 'carlos.sanchez@ejemplo.com', 1, 'Boulevard de la Luna 789', '5555556666'),
    ('Ana Martinez', 'ana.martinez@ejemplo.com', 2, 'Calle de las Flores 101', '5557778888'),
    ('Luis Fernandez', 'luis.fernandez@ejemplo.com', 1, 'Avenida de los Pinos 202', '5559990000');
END;
GO


-- Facultades
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

-- Programas
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

-- Modulos
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

-- Cursos
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

-- Matricula
IF NOT EXISTS (SELECT * FROM Matricula WHERE matricula_id = 1)
BEGIN
    INSERT INTO Matricula (usuario_id, curso_id, fecha) VALUES
    (1, 1, '2024-10-01'),
    (2, 2, '2024-10-02'),
    (3, 3, '2024-10-03'),
    (4, 4, '2024-10-04'),
    (5, 5, '2024-10-05'),
    (6, 6, '2024-10-06'),
    (7, 7, '2024-10-07'),
    (8, 8, '2024-10-08'),
    (9, 9, '2024-10-09'),
    (10, 10, '2024-10-10');
END;
GO

-- Clases
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

-- 1. Identificar el No. de productos asociados a cada proveedor
SELECT p.nombre AS proveedor, COUNT(prod.producto_id) AS num_productos
FROM Proveedor p
LEFT JOIN Producto prod ON p.proveedor_id = prod.proveedor_id
GROUP BY p.nombre;

-- 2. Identificar el valor promedio de todas las ventas totales
SELECT AVG(total) AS promedio_ventas
FROM Venta;

-- 3. Identificar los tres (o más) días en los que se registran mayor número de productos vendidos
SELECT fecha, SUM(cantidad) AS total_productos
FROM Venta
GROUP BY fecha
ORDER BY total_productos DESC
LIMIT 3;

-- 4. Identificar los tres (o más) clientes que registran mayores ventas
SELECT c.nombre AS cliente, SUM(v.total) AS total_ventas
FROM Cliente c
JOIN Venta v ON c.cliente_id = v.cliente_id
GROUP BY c.nombre
ORDER BY total_ventas DESC
LIMIT 3;

-- 5. Identificar los programas por facultades
SELECT f.nombre AS facultad, p.nombre AS programa
FROM Facultades f
JOIN Programas p ON f.facultad_id = p.facultad_id
ORDER BY f.nombre;

-- 6. Identificar los estudiantes matriculados en cursos del programa Ingeniería de Software
SELECT u.nombre AS estudiante, c.nombre AS curso
FROM Usuarios u
JOIN Matricula m ON u.usuario_id = m.usuario_id
JOIN Cursos c ON m.curso_id = c.curso_id
JOIN Modulos mo ON c.modulo_id = mo.modulo_id
JOIN Programas p ON mo.programa_id = p.programa_id
WHERE p.nombre = 'Ingenieria de Software';

-- 7. Identificar todos los cursos con estudiantes matriculados, este listado debe relacionar el No. de estudiantes por curso
SELECT c.nombre AS curso, COUNT(m.usuario_id) AS num_estudiantes
FROM Cursos c
JOIN Matricula m ON c.curso_id = m.curso_id
GROUP BY c.nombre;

-- 8. Identificar el No. de materias matriculadas a cada estudiante
SELECT u.nombre AS estudiante, COUNT(m.curso_id) AS num_materias
FROM Usuarios u
JOIN Matricula m ON u.usuario_id = m.usuario_id
GROUP BY u.nombre;

-- 9. Identificar los estudiantes que no tienen materias matriculadas
SELECT u.nombre AS estudiante
FROM Usuarios u
LEFT JOIN Matricula m ON u.usuario_id = m.usuario_id
WHERE m.matricula_id IS NULL AND EXISTS (
    SELECT 1 FROM Rol_Usuario r WHERE r.id = u.id_rol_usuario AND r.nombre = 'Estudiante'
);

-- 10. Identificar el No. de estudiantes a cargo de cada profesor en cada curso
SELECT u.nombre AS profesor, c.nombre AS curso, COUNT(m.usuario_id) AS num_estudiantes
FROM Usuarios u
JOIN Rol_Usuario r ON u.id_rol_usuario = r.id AND r.nombre = 'Profesor'
JOIN Cursos c ON c.curso_id = (SELECT curso_id FROM Clases cl WHERE cl.curso_id = c.curso_id AND cl.fecha >= GETDATE())
LEFT JOIN Matricula m ON c.curso_id = m.curso_id
GROUP BY u.nombre, c.nombre
ORDER BY u.nombre, c.nombre;

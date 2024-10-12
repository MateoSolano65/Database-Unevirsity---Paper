# Proyecto: Base de Datos - Universidad y Papelería

Este repositorio contiene dos actividades principales que utilizan la misma base de datos para diferentes escenarios: una universidad y una papelería. Se ha utilizado SQL Server como el manejador de base de datos para ambas actividades.

## Descripción del Proyecto

El proyecto tiene como objetivo implementar una base de datos en SQL Server que sea utilizada en dos contextos diferentes: una universidad y una papelería. Cada contexto tiene sus propias necesidades de gestión, y las consultas SQL desarrolladas abordan dichos requerimientos.

### Actividades Incluidas

1. **Actividad 5**: Se enfoca en el montaje de esquemas de bases de datos y la gestión de datos tanto de una universidad como de una papelería. Se incluye un taller dividido en dos puntos:

   - **Punto 1: Montaje de los esquemas de bases de datos**

     1. Montar el esquema de una base de datos de ventas que permita gestionar las ventas de una papelería. Esta base de datos debe tener las tablas: proveedor, productos, clientes, y ventas.
     2. Montar el esquema de una base de datos que permita gestionar algunas actividades básicas de una universidad. Esta base de datos debe tener las tablas: facultad, programa, usuarios, rol (estudiantes o docentes), cursos, clases, y matrícula.
     3. Ingresar registros coherentes en todas las tablas para poder desarrollar las sentencias solicitadas a continuación. Los campos de las tablas deben tener el tipo de datos que corresponde y se deben establecer las llaves primarias y foráneas.

   - **Punto 2: Sentencias SQL requeridas**
     1. Identificar el número de productos asociados a cada proveedor.
     2. Identificar el valor promedio de todas las ventas totales.
     3. Identificar los tres (o más) días en los que se registran mayor número de productos vendidos.
     4. Identificar los tres (o más) clientes que registran mayores ventas.
     5. Identificar los programas por facultades.
     6. Identificar los estudiantes matriculados en cursos del programa Ingeniería de Software.
     7. Identificar todos los cursos con estudiantes matriculados, relacionando el número de estudiantes por curso.
     8. Identificar el número de materias matriculadas a cada estudiante.
     9. Identificar los estudiantes que no tienen materias matriculadas.
     10. Identificar el número de estudiantes a cargo de cada profesor en cada curso.

2. **Actividad 6**: Enfocada en la gestión de la papelería e incluye un taller dividido en dos puntos: creación de vistas y sentencias SQL requeridas.

   - **Punto 1: Creación de vistas**

     1. Crear una vista que permita ver todas las ventas realizadas con el nombre del cliente y el nombre del proveedor del producto.
     2. Crear una vista que permita ver las ventas registradas el día actual (hoy).
     3. Crear una vista con los cursos creados por programa.
     4. Crear una vista que permita ver todos los estudiantes matriculados en los cursos, incluyendo a qué programa están asociados los cursos.
     5. Generar una vista que permita ver el número total de cursos con estudiantes por programas.

   - **Punto 2: Sentencias SQL requeridas**
     1. Identificar los productos que no se han vendido.
     2. Identificar los proveedores con productos que no se han vendido y ordenarlos descendentemente, mostrando el nombre de los proveedores en mayúsculas.
     3. Identificar los clientes que no han comprado productos.
     4. Identificar los clientes que han comprado en días diferentes y ordenarlos descendentemente.
     5. Identificar los clientes con el precio del pedido superior al precio medio de todas las ventas.
     6. Identificar los cursos abiertos con el número de estudiantes matriculados.
     7. Identificar los programas que tienen estudiantes sin cursos matriculados.
     8. Identificar las materias con el mayor número de cursos con estudiantes matriculados.
     9. Crear una sentencia SQL que use la función HAVING en la base de datos de Ventas y explicarla.
     10. Crear una sentencia SQL que muestre datos de todas las tablas de la base de datos Universidad por medio de JOIN, explicando lo que se busca con la consulta.

## Estructura del Proyecto

- **ACTIVIDAD_5**: Carpeta que contiene los scripts SQL correspondientes a la actividad relacionada con la universidad y la papelería.
- **ACTIVIDAD_6**: Carpeta que contiene los scripts SQL correspondientes a la actividad relacionada con la papelería.
- **Backups**: Contiene archivos de respaldo (`.bak`) de la base de datos para facilitar su restauración en SQL Server.
- **LICENSE**: Archivo con información sobre la licencia del proyecto (Licencia MIT).
- **README.md**: Descripción general del proyecto y guía de uso.

## Requisitos

- SQL Server 2019 o superior
- SQL Server Management Studio (SSMS) para ejecutar los scripts y restaurar los backups

## Instalación

1. Clonar el repositorio en tu máquina local.
   ```
   git clone https://github.com/MateoSolano65/Database-Unevirsity---Paper.git
   ```
2. Abrir SQL Server Management Studio (SSMS).
3. Restaurar la base de datos utilizando los archivos de backup ubicados en la carpeta `backups` o ejecutar los scripts SQL para crear y poblar la base de datos.

## Uso

- Ejecutar los scripts SQL que se encuentran en las carpetas `ACTIVIDAD_5` y `ACTIVIDAD_6` según la actividad que se desee trabajar.
- Cada actividad contiene un conjunto de consultas que abordan diferentes escenarios, tanto para la universidad como para la papelería.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Backups

Se proporcionan archivos de backup (`.bak`) en la carpeta `Backups` para facilitar la restauración de la base de datos en SQL Server.

USE Tarea6;
/* r. Encontrar la información de las compañías que tienen al menos dos empleados en la misma
 * ciudad en que tienen sus instalaciones.
 */


SELECT em.*
FROM 
	Empresa em 
	INNER JOIN
	(
	SELECT B.RFC, COUNT(B.CURP) as num_empleados
	FROM 
		(
		SELECT Em.*, e.CURP, e.nombre as nombre_empleado, e.paterno, e.materno, e.ciudad as ciudad_empleado
		FROM Empleado e 
		INNER JOIN trabajar t
		ON e.CURP = t.CURP
		INNER JOIN Empresa em 
		ON t.RFC = em.RFC
		WHERE e.ciudad = em.ciudad
		) B
		GROUP BY B.RFC
	) C
	ON C.RFC = em.RFC
	WHERE C.num_empleados >= 2
	ORDER BY em.razonSocial;

/* s. Proyecto que más empleados requiere (o requirió) y el número de horas que éstos le
* dedicaron.
*/
--La vista s es una proyección del join de empleado, colaborar y proyecto
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[s]'))
DROP VIEW [dbo].[s]
GO
CREATE VIEW dbo.s 
AS 
SELECT e.*, p.numProy, p.nombre as nombre_proyecto, p.fechaInicio as fecha_inicio_proyecto, p.fechaFin as fecha_fin_proyecto, c.numHoras
FROM Empleado e
INNER JOIN colaborar c 
ON e.CURP = c.CURP
INNER JOIN Proyecto p 
ON c.numProy = p.numProy
GO

SELECT s.nombre_proyecto, s.nombre, s.paterno, s.paterno, s.numHoras
FROM
	s 
	INNER JOIN
	(
	SELECT s.numProy, COUNT(CURP) as numero_empleados
		FROM s
		GROUP BY s.numproy
	) D --numero de empleados por proyecto
	ON s.numProy = D.numProy
	INNER JOIN 
	(
	SELECT MAX(B.numero_empleados) as maximo_numero_empleados
	FROM
		(
		SELECT s.numProy, COUNT(CURP) as numero_empleados
		FROM s
		GROUP BY s.numproy
		) B --numero de empleados por proyecto
	) C	--maximo número de empleados entre todos los proyectos
	ON C.maximo_numero_empleados = D.numero_empleados;

/* t. Empleados que comenzaron a colaborar en proyectos en la misma fecha de su cumpleaños.
 * 
 */
SELECT e.*
FROM Empleado e
INNER JOIN colaborar c
ON c.CURP = e.CURP
WHERE DATEPART(MONTH, e.nacimiento) = DATEPART(MONTH, c.fechaInicio) AND DATEPART(DAY, e.nacimiento) = DATEPART(DAY, c.fechaInicio);

/* u. Obtener una lista del número de empleados que supervisa cada supervisor.
 */
SELECT e.*, B.numero_supervisados
FROM Empleado e
INNER JOIN
	(
	SELECT supervisor, COUNT(CURP) as numero_supervisados
	FROM Empleado 
	GROUP BY supervisor
	)B
ON B.supervisor = e.CURP;

-- v. Obtener una lista de los directores de más de 50 años
SELECT e.*,
       floor(DATEDIFF(day,nacimiento,getdate())/365.25) edad
FROM Empleado e
INNER JOIN dirigir d
ON e.CURP = d.CURP
WHERE floor(DATEDIFF(day,nacimiento,getdate())/365.25) > 50;

/*
w. Obtener una lista de los empleados cuyo apellido paterno comience con las letras A, D, G, J,
L, P o R.
*/

SELECT *
FROM dbo.Empleado e
WHERE e.paterno LIKE '[ADGJLPR]%'

/*
 * x. Número de empleados que colaboran en los proyectos que controla cada empresa para
 * aquellos proyectos que hayan iniciado en diciembre.
 */

SELECT A.RFC, A.numProy, COUNT(A.CURP) as numero_empleados
FROM 
	(
	SELECT em.RFC, p.numProy, e.CURP, p.fechaInicio
	FROM Empresa em 
	INNER JOIN 
	Proyecto p 
	ON p.RFC = em.RFC
	INNER JOIN 
	colaborar c 
	ON c.numProy = p.numProy
	INNER JOIN 
	Empleado e 
	ON e.CURP = c.CURP
	WHERE DATEPART(MONTH, p.fechaInicio) = 12
	) A
GROUP BY A.RFC, A.numProy

/*
y. Crea una vista con la información de los empleados y compañías en que trabajan, de aquellos
empleados que lo hagan en al menos tres compañías diferentes.
*/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V]'))
DROP VIEW [dbo].[V]
GO
CREATE VIEW dbo.V 
AS 
SELECT e.*, em.RFC, em.razonSocial, em.ciudad as ciudad_empresa, em.cp as cp_empresa, em.calle as calle_empresa, em.num as num_empresa
FROM 
Empleado e
INNER JOIN
(
SELECT A.CURP, COUNT(A.RFC) as numero_empresas
FROM 
	(
	SELECT e.CURP, em.RFC
	FROM dbo.Empleado e 
	INNER JOIN dbo.trabajar t
	ON e.CURP = t.CURP
	INNER JOIN dbo.Empresa em 
	ON t.RFC = em.RFC
	) A -- numero de empresas en las que trabaja cada empleado
GROUP BY A.CURP
)B 
ON B.CURP = e.CURP
INNER JOIN
trabajar t 
ON t.CURP = B.CURP
INNER JOIN
Empresa em 
ON em.RFC = t.RFC
WHERE B.numero_empresas >= 3
GO
SELECT * FROM V;


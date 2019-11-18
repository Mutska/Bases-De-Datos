USE Tarea6;
/* r. Encontrar la información de las compañías que tienen al menos dos empleados en la misma
 * ciudad en que tienen sus instalaciones.
 */

SELECT A.RFC, A.razonSocial, A.ciudad as ciudad_empresa, D.nombre, D.paterno, D.materno, D.ciudad as ciudad_empleado
FROM 
	(
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
	) A --La información de las empresas que tienen dos empleados trabajando en la misma ciudad que ellas
	INNER JOIN trabajar t 
	ON A.RFC = t.RFC
	INNER JOIN 
	(
	SELECT e.*
	FROM 
		Empleado e 
		INNER JOIN
		(
			SELECT Em.*, e.CURP, e.nombre as nombre_empleado, e.paterno, e.materno, e.ciudad as ciudad_empleado
			FROM Empleado e 
			INNER JOIN trabajar t
			ON e.CURP = t.CURP
			INNER JOIN Empresa em 
			ON t.RFC = em.RFC
			WHERE e.ciudad = em.ciudad
		) B
		ON e.CURP = B.CURP
	) D --Los empleados que trabajan en la misma ciudad que su empresa
	ON t.CURP = D.CURP
	ORDER BY A.razonSocial;

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

SELECT e.nombre, e.paterno, e.materno, e.nacimiento, c.fechaInicio as fecha_inicio_colaboracion, p.nombre as nombre_proyecto
FROM Empleado e
INNER JOIN colaborar c
ON c.CURP = e.CURP
INNER JOIN Proyecto p 
ON p.numProy = c.numProy
WHERE DATEPART(MONTH, e.nacimiento) = DATEPART(MONTH, c.fechaInicio) AND DATEPART(DAY, e.nacimiento) = DATEPART(DAY, c.fechaInicio);

/* u. Obtener una lista del número de empleados que supervisa cada supervisor.
 */
SELECT e.nombre, e.paterno, e.materno, B.numero_supervisados
FROM Empleado e
INNER JOIN
	(
	SELECT supervisor, COUNT(CURP) as numero_supervisados
	FROM Empleado 
	GROUP BY supervisor
	)B
ON B.supervisor = e.CURP;

-- v. Obtener una lista de los directores de más de 50 años
SELECT e.CURP, nombre, paterno, materno, nacimiento,
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


/*
y. Crea una vista con la información de los empleados y compañías en que trabajan, de aquellos
empleados que lo hagan en al menos tres compañías diferentes.
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[V]'))
DROP VIEW [dbo].[V]
GO
CREATE VIEW dbo.V 
AS 
SELECT e.*, em.RFC, em.razonSocial, em.ciudad as ciudad_empresa, em.calle as calle_empresa, em.num as num_empresa, em.cp as cp_empresa
FROM dbo.Empleado e 
INNER JOIN dbo.trabajar t
ON e.CURP = t.CURP
INNER JOIN dbo.Empresa em 
ON t.RFC = em.RFC;
GO
SELECT V.*
FROM V
INNER JOIN
(
SELECT CURP, COUNT(CURP) as numero_empresas
FROM dbo.V 
GROUP BY CURP
)B 
ON B.CURP = V.CURP
WHERE B.numero_empresas >= 3;



USE Tarea6;

/*
 * Consulta A
 */
SELECT nombre, empdo.ciudad

FROM dbo.Empleado empdo INNER JOIN dbo.trabajar trbj ON 
     empdo.CURP = trbj.CURP INNER JOIN
	 dbo.Empresa empr ON trbj.RFC = empr.RFC

WHERE razonSocial = 'Ball Corporation'

/*
 * Consulta B 
 */
SELECT empdo.CURP, empdo.nombre, empdo.ciudad, empr.ciudad

FROM dbo.Empleado empdo INNER JOIN dbo.trabajar trbj ON 
     empdo.CURP = trbj.CURP INNER JOIN
	 dbo.Empresa empr ON trbj.RFC = empr.RFC

WHERE empdo.ciudad != empr.ciudad

/*
 * Consulta C
 */
 SELECT salarioQuincenal*2
 FROM Empleado e INNER JOIN trabajar t ON
	  e.CURP = t.CURP INNER JOIN 
	  dirigir d ON d.CURP = e.CURP
 WHERE genero = 'F'

/*
 * Consulta D
 */
SELECT *
FROM Empleado e INNER JOIN trabajar t ON
	  e.CURP = t.CURP INNER JOIN 
	  dirigir d ON d.CURP = e.CURP INNER JOIN
	  Empresa emp ON emp.RFC = d.RFC
WHERE (fechaInicio BETWEEN '2018/03/31' AND '2018/06/30') OR (fechaInicio BETWEEN '2018/09/30' AND '2019/01/01')

/*
 * Consulta E
 */
SELECT emp.CURP
FROM Empleado e INNER JOIN Empleado emp
     ON e.CURP = emp.supervisor
WHERE e.ciudad = emp.ciudad AND e.calle = emp.calle


/*
 * Consulta F
 */

 SELECT e.RFC, emp.genero, YEAR(fechaIngreso) año, AVG(salarioQuincenal) promedio
 FROM trabajar t JOIN Empresa e ON
	  t.RFC = e.RFC JOIN
	  Empleado emp ON emp.CURP = t.CURP
 GROUP BY e.RFC, genero, YEAR(fechaIngreso)

/*
 * Consulta G
 */
  SELECT emp.CURP, emp.nombre
  FROM Empleado emp INNER JOIN trabajar t ON 
	   emp.CURP = t.CURP INNER JOIN
	   colaborar c ON c.CURP = emp.CURP INNER JOIN
	   Proyecto p ON c.numProy = p.numProy
 WHERE p.RFC != t.RFC

/*
 * Consulta H
 */
 SELECT e.RFC, MAX(salarioQuincenal) Maximo, MIN(salarioQuincenal) Minimo, SUM(salarioQuincenal) Total
 FROM Empresa e INNER JOIN trabajar t ON
	  e.RFC = t.RFC
 GROUP BY e.RFC

/*
 * Consuta I
 */

  SELECT e.*
  FROM (SELECT emp.CURP, COUNT(col.numProy) numProyectos
		FROM Empleado emp INNER JOIN colaborar col ON 
		   emp.CURP = col.CURP
		GROUP BY emp.CURP
		HAVING COUNT(col.numProy) > 1  ) AS a JOIN colaborar c ON
		a.CURP = c.CURP JOIN Empleado e ON e.CURP = a.CURP
  WHERE c.numHoras > 2000


/*
 * Consuta J
 */

select info.razonSocial, count(info.num_empleados) as num_empleados, YEAR(info.fechaIngreso) anio,  DATEPART(qq,info.fechaIngreso) trimestre , info.genero  from (select e.razonSocial, t.RFC,  count(m.CURP) num_empleados, genero, fechaIngreso from Empresa e join Trabajar t  on e.RFC = t.RFC join Empleado m on m.CURP = t.CURP group by e.razonSocial,t.RFC , m.genero, t.fechaIngreso) as info group by info.razonSocial, info.fechaIngreso, info.genero

/*
 * Consulta K
 */
SELECT e.razonSocial, emp.nombre, MAX(t.salarioQuincenal) maxSalario
FROM Empleado emp JOIN trabajar t ON
     emp.CURP = t.CURP JOIN Empresa e ON
	 e.RFC = t.RFC
GROUP BY e.razonSocial, emp.nombre

/*
 * Consulta L
 */
 SELECT emp.CURP
 FROM  (SELECT e.RFC, AVG(salarioQuincenal) promedio
		FROM trabajar t JOIN Empresa e ON
			 t.RFC = e.RFC JOIN
	         Empleado emp ON emp.CURP = t.CURP
	    GROUP BY e.RFC ) as promedio JOIN trabajar t ON
		t.RFC = promedio.RFC JOIN Empleado emp ON 
		emp.CURP = t.CURP 
 WHERE t.salarioQuincenal > promedio.promedio 


/*
 * Consulta M
 * 
 */
SELECT emp.*
FROM   (SELECT RFC

		FROM (SELECT t.RFC, COUNT(t.CURP) totalEmpleados 
			  FROM Empresa e JOIN trabajar t ON
					e.RFC = t.RFC
			  GROUP BY t.RFC) AS total1

			  INNER JOIN

			  (SELECT MIN(totalEmpleados.totalEmpleados) minimo
			  FROM (SELECT t.RFC, COUNT(t.CURP) totalEmpleados 
					FROM Empresa e JOIN trabajar t ON e.RFC = t.RFC
					GROUP BY t.RFC) AS totalEmpleados) AS total2
			  ON total1.totalEmpleados = total2.minimo ) AS minEmpresa

		INNER JOIN Empresa e ON e.RFC = minEmpresa.RFC
		JOIN trabajar t ON t.RFC = e.RFC
		INNER JOIN Empleado emp ON t.CURP = emp.CURP



(SELECT MIN(totalEmpleados.totalEmpleados) minimo
FROM (SELECT t.RFC, COUNT(t.CURP) totalEmpleados 
      FROM Empresa e JOIN trabajar t ON
	              e.RFC = t.RFC
	  GROUP BY t.RFC) AS totalEmpleados)


/*
 * Consulta N
 */
select p.numProy, p.nombre, p.fechaFin, p.fechaInicio, p.RFC from Colaborar c join Dirigir D on c.CURP = d.CURP join Proyecto p  on p.numProy = c.numProy

/*
 * Consulta P
 */
SELECT emp.CURP

FROM Empleado emp JOIN colaborar c ON
	 emp.CURP = c.CURP JOIN Proyecto p ON
	 p.numProy = c.numProy

WHERE c.fechaFin < p.fechaFin


/*
 * Consulta Q
 */
SELECT CURP
FROM Empleado
EXCEPT
SELECT emp.CURP
FROM Empleado emp INNER JOIN colaborar c
     ON emp.CURP = c.CURP

/* 
 * Consulta R
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

/* 
 * Consulta S
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

/*
 * Consulta T
 */

SELECT e.nombre, e.paterno, e.materno, e.nacimiento, c.fechaInicio as fecha_inicio_colaboracion, p.nombre as nombre_proyecto
FROM Empleado e
INNER JOIN colaborar c
ON c.CURP = e.CURP
INNER JOIN Proyecto p 
ON p.numProy = c.numProy
WHERE DATEPART(MONTH, e.nacimiento) = DATEPART(MONTH, c.fechaInicio) AND DATEPART(DAY, e.nacimiento) = DATEPART(DAY, c.fechaInicio);

/*
 * Consulta U
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


/*
 * Consulta V 
 */
SELECT e.CURP, nombre, paterno, materno, nacimiento,
       floor(DATEDIFF(day,nacimiento,getdate())/365.25) edad
FROM Empleado e
INNER JOIN dirigir d
ON e.CURP = d.CURP
WHERE floor(DATEDIFF(day,nacimiento,getdate())/365.25) > 50;

/*
 * Consulta W 
 */

SELECT *
FROM dbo.Empleado e
WHERE e.paterno LIKE '[ADGJLPR]%'

/*
 * Consulta X
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
 * Consulta Y
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


     


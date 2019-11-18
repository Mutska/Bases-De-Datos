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
     


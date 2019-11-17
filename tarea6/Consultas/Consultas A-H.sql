/*
 * Consulta A
 */
SELECT nombre, empdo.ciudad

FROM dbo.Empleado empdo INNER JOIN dbo.trabajar trbj ON 
     empdo.CURP = trbj.CURP INNER JOIN
	 dbo.Empresa empr ON trbj.RFC = empr.RFC

WHERE razonSocial = 'Ball Corporation'

/*
 * Consulta B INCOMPLETA
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
  SELECT emp.CURP, emp.nombre, col.numHoras, col.numProy
  FROM Empleado emp INNER JOIN colaborar col ON
       emp.CURP = col.CURP
  WHERE col.numHoras >= 20



SELECT *
FROM dbo.Empleado e
WHERE e.paterno LIKE '[ADGJLPR]%'
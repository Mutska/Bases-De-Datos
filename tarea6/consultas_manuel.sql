USE Tarea6;

/*Obtener una lista del número de empleados que supervisa cada supervisor.
 */

SELECT supervisor, COUNT(CURP) as numero_supervisado
FROM Empleado e
GROUP BY supervisor

--Obtener una lista de los directores de más de 50 años
SELECT e.CURP, nombre, materno, paterno, nacimiento,
       floor(DATEDIFF(day,nacimiento,getdate())/365.25) edad
FROM Empleado e
INNER JOIN dirigir d
ON e.CURP = d.CURP
WHERE floor(DATEDIFF(day,nacimiento,getdate())/365.25) > 50;

/*
Obtener una lista de los empleados cuyo apellido paterno comience con las letras A, D, G, J,
L, P o R.
*/

SELECT *
FROM dbo.Empleado e
WHERE e.paterno LIKE '[ADGJLPR]%'

/*
 * Número de empleados que colaboran en los proyectos que controla cada empresa para
 * aquellos proyectos que hayan iniciado en diciembre.
 */




/*
Crea una vista con la información de los empleados y compañías en que trabajan, de aquellos
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
SELECT V.razonSocial, V.nombre, V.paterno, V.paterno
FROM V
INNER JOIN
(
SELECT CURP, COUNT(CURP) as numero_empresas
FROM dbo.V 
GROUP BY CURP
)B 
ON B.CURP = V.CURP
WHERE B.numero_empresas >= 3;



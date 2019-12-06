/*
 * Ganancias por sucursal
 */
SELECT s.idSucursal, SUM(costoTotal) TotalGanancias

FROM Sucursal s INNER JOIN Pedido p ON s.idSucursal = p.idSucursal

GROUP BY s.idSucursal


/*
 * Platillo más popular
 * Esto es un cagadero, y no estoy seguro de qué hacer
 */

SELECT p.idSucursal, s.nombre, COUNT(ep.idPlatillo) totalVendido
FROM Pedido p INNER JOIN EstarPlatillo ep ON ep.noTicket = p.noTicket
     INNER JOIN Platillo s ON s.idPlatillo = ep.idPlatillo
GROUP BY p.idSucursal, s.nombre
ORDER BY p.idSucursal, COUNT(ep.idPlatillo) DESC

SELECT idSucursal, nombre, row_number() over(PARTITION BY idSucursal
  ORDER BY totalVendido) as orden
FROM (SELECT p.idSucursal, s.nombre, COUNT(ep.idPlatillo) totalVendido
      FROM Pedido p INNER JOIN EstarPlatillo ep ON ep.noTicket = p.noTicket
                 INNER JOIN Platillo s ON s.idPlatillo = ep.idPlatillo
      GROUP BY p.idSucursal, s.nombre) as c





SELECT idSucursal, nombre
FROM (SELECT idSucursal, nombre, row_number() over(PARTITION BY idSucursal
                                                   ORDER BY totalVendido DESC) as orden

      FROM (SELECT p.idSucursal, s.nombre, COUNT(ep.idPlatillo) totalVendido
            FROM Pedido p INNER JOIN EstarPlatillo ep ON ep.noTicket = p.noTicket
                 INNER JOIN Platillo s ON s.idPlatillo = ep.idPlatillo
            GROUP BY p.idSucursal, s.nombre) as c

     ) as popu

/*
 * Ventas de salsas por y su nombre sucursal
 */

SELECT p.idSucursal, s.nombre, COUNT(es.idSalsa) totalVendido
FROM Pedido p INNER JOIN EstarSalsa es ON es.noTicket = p.noTicket
     INNER JOIN Salsa s ON s.idSalsa = es.idSalsa
GROUP BY p.idSucursal, s.nombre
ORDER BY p.idSucursal, COUNT(es.idSalsa) DESC

/*
 * Consulta 2
 * Contar a los empleados de las sucursales, por tipo de empleado y por sucursal
 */
SELECT p.idSucursal, p.tipoEmpleado, COUNT(p.idPersona) Empleado
FROM Persona p
GROUP BY p.idSucursal, p.tipoEmpleado

/*
 * Total de empleados por sucursal
 */


/*
 * Total de empleados por sucursal
 */

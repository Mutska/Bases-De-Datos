/*
 * Consulta 1
 * Las ganancias totales de cada sucursal, ordenadas por mes, trimestre y año.
 */

 SELECT p.idSucursal, YEAR(p.fecha) año, DATEPART(qq, p.fecha) trimestre, DATEPART(mm, p.fecha) mes, SUM(costoTotal) ganancias
 FROM Sucursal s JOIN Pedido p ON p.idSucursal = s.idSucursal
 GROUP BY p.idSucursal, YEAR(p.fecha), DATEPART(qq, p.fecha), DATEPART(mm, p.fecha)


 /*
  * Consulta 2
  * Ventas de salsas por y su nombre sucursal
  */

 SELECT p.idSucursal, s.nombre, COUNT(es.idSalsa) totalVendido
 FROM Pedido p INNER JOIN EstarSalsa es ON es.noTicket = p.noTicket
      INNER JOIN Salsa s ON s.idSalsa = es.idSalsa
 GROUP BY p.idSucursal, s.nombre
 ORDER BY p.idSucursal, COUNT(es.idSalsa) DESC


/*
 * Consulta 3
 * Contar cuantas veces una Sucursal ha ordenado a un proveedor en su misma ciudad en el año 2019
 */
SELECT c.nombre, COUNT(c. idSucursal) noSucursales
FROM (SELECT prov.nombre, suc.idSucursal, pro.monto
	  FROM Proveedor prov JOIN Proveer pro ON prov.idProveedor = prov.idProveedor
		   JOIN Sucursal suc ON suc.idSucursal = pro.idSucursal
	  WHERE (pro.fechaPedido BETWEEN '12/31/2018' AND '1/1/2020') AND (prov.estado = suc.estado) ) as c
GROUP BY c.nombre


 /*
 * Consulta 4
 * Los ingredientes de la salsa más comprada de cada año
 */
SELECT ts.idSalsa, p.nombre
FROM	(SELECT idSalsa
		 FROM (SELECT Año, MAX(totalSalsas) maxSalsas
		 	   FROM (SELECT es.idSalsa, YEAR(p.fecha) Año, COUNT(es.idSalsa) totalSalsas
					 FROM Pedido p INNER JOIN EstarSalsa es ON
						 p.noTicket = es.noTicket
					 GROUP BY es.idSalsa, YEAR(p.fecha) ) as c
			   GROUP BY Año) as c1

			   INNER JOIN

			  (SELECT es.idSalsa, YEAR(p.fecha) Año, COUNT(es.idSalsa) totalSalsas
			   FROM Pedido p INNER JOIN EstarSalsa es ON
						 p.noTicket = es.noTicket
			   GROUP BY es.idSalsa, YEAR(p.fecha) ) as c2

			   ON c2.Año = c1.Año AND c2.totalSalsas = c1.maxSalsas) as c3

			   INNER JOIN

			   TenerSalsa ts ON c3.idSalsa = ts.idSalsa

			   INNER JOIN

			   Producto p ON p.idProducto = ts.idProducto

 /*
 * Consulta 5
 * Precio y nombre de platillo más vendido
 */
SELECT platPlus.idPlatillo, p.nombre
FROM (SELECT idPlatillo
      FROM (SELECT MAX(c.totalPlatillos) masVendido
            FROM (SELECT ep.idPlatillo, COUNT(ep.idPlatillo) totalPlatillos
                  FROM Pedido p INNER JOIN EstarPlatillo ep ON
                       p.noTicket = ep.noTicket
                  GROUP BY ep.idPlatillo) as c) as c1

            INNER JOIN

           (SELECT ep.idPlatillo, COUNT(ep.idPlatillo) totalPlatillos
            FROM Pedido p INNER JOIN EstarPlatillo ep ON
                 p.noTicket = ep.noTicket
            GROUP BY ep.idPlatillo) as c2

            ON c2.totalPlatillos = c1.masVendido) as platPlus

      INNER JOIN

      TenerPlatillo tp ON tp.idPlatillo = platPlus.idPlatillo

      INNER JOIN

      Producto p ON p.idProducto = tp.idProducto



 /*
 * Consulta 6
 * Cuanto se ha gastado, por tipo de pago y sucursal
 */
SELECT idSucursal, tipoPago, SUM(costoTotal) totalGastado
FROM Pedido p JOIN TipoPago tp ON p.noTicket = p.noTicket
GROUP BY idSucursal, tipoPago



 /*
 * Consulta 7
 * Cuanto se ha "regalado" en puntos por sucursal
 */
SELECT *

FROM(SELECT idSucursal, tipoPago, SUM(costoTotal) totalGastado
     FROM Pedido p JOIN TipoPago tp ON p.noTicket = p.noTicket
     GROUP BY idSucursal, tipoPago ) as c

WHERE tipoPago = 'Puntos'


 /*
 * Consulta 8
 * Tipo de pago más popular entre los clientes
 */
 SELECT idSucursal, tp.tipoPago, COUNT(tipoPago) tipoPago
 FROM Pedido p JOIN TipoPago tp ON p.noTicket = tp.noTicket
 GROUP BY idSucursal, tp.tipoPago

 /*
 * Consulta 9
 * Cuántos bonos se han entregado a cada empleado y su valor sumado, por sucursal
 */
SELECT c1.idPersona, c2.numBonos, c1.totalBono
FROM (SELECT idPersona, SUM(monto) totalBono
      FROM Bono
      GROUP BY idPersona) as c1

      INNER JOIN

     (SELECT p.idPersona, COUNT(p.idPersona) numBonos
      FROM Persona p INNER JOIN Bono b ON p.idPersona = b.idPersona
      GROUP BY p.idPersona) as c2

	  ON c1.idPersona = c2.idPersona



 /*
 * Consulta 10
 * Cuanto ha gastado cada sucursal de california en productos de proveedores que estén en Texas
 */
SELECT c.idSucursal, p.idProveedor, c.gastos
FROM (SELECT p.idSucursal, p.idProveedor, SUM(p.monto) gastos
      FROM Proveer p INNER JOIN Sucursal s ON p.idSucursal =  s.idSucursal

      GROUP BY p.idSucursal, p.idProveedor) as c
	  INNER JOIN
	  Sucursal s ON s.idSucursal = c.idSucursal
	  INNER JOIN
	  Proveedor p ON p.idProveedor = c.idProveedor

WHERE s.estado = 'California' AND p.estado = 'Texas'


 /*
 * Consulta 11
 * Obtener los nombres de platillo, sus recomendaciones y el nivel de picor
 */

SELECT p.idPlatillo, s.nombre, s.nivelPicor
FROM Platillo p INNER JOIN Recomendar r ON p.idPlatillo = r.idPlatillo
     INNER JOIN Salsa s ON s.idSalsa = r.idSalsa


 /*
 * Consulta 12
 * El nivel de picor más popular
 */

SELECT c3.nivelPicor
FROM (SELECT MAX(totalNivelPicor) maxPicor
      FROM (SELECT s.nivelPicor, COUNT(s.nivelPicor) totalNivelPicor
            FROM EstarSalsa es JOIN Salsa s ON es.idSalsa = s.idSalsa
            GROUP BY s.nivelPicor) as c1) as c2

      INNER JOIN

     (SELECT s.nivelPicor, COUNT(s.nivelPicor) totalNivelPicor
      FROM EstarSalsa es JOIN Salsa s ON es.idSalsa = s.idSalsa
      GROUP BY s.nivelPicor) as c3

	  ON c2.maxPicor = c3.totalNivelPicor


 /*
 * Consulta 13
 * Cuantos empleados que viven en el mismo municipio que la sucursal en la que trabajan
 */
SELECT COUNT(idPersona) Personas
FROM (SELECT idPersona
      FROM Persona p INNER JOIN Sucursal s ON p.idSucursal = s.idSucursal
      WHERE p.municipio = s.municipio) as c

 /*
 * Consulta 14
 * La información de los cuchillos que usan las sucursales de Florida
 */
SELECT *
FROM Articulo a INNER JOIN Sucursal s ON a.idSucursal = s.idSucursal
WHERE s.estado = 'Florida' AND a.nombre = 'Cuchillo'


 /*
 * Consulta 15
 * Cuantos pedidos realizó cada sucursal, por mes, trimestre y año.
 */
SELECT idSucursal, YEAR(fechaPedido) Año, DATEPART(qq, fechaPedido) Trimeste, DATEPART(mm, fechaPedido) Mes, COUNT(monto) numPedidos
FROM Proveer
GROUP BY idSucursal, YEAR(fechaPedido), DATEPART(qq, fechaPedido), DATEPART(mm, fechaPedido)

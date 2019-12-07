
--Este trigger actualiza la cantidad de puntos de una Persona con el 10% de su compra, y lo marca como cliente.
--Un ejemplo para ver que este trigger se ejecute es el siguiente:
--SELECT Puntos FROM Persona WHERE idPersona = 900 
--INSERT INTO Pedido(costoTotal, fecha, idPersona, idSucursal) VALUES (1000, '5/12/2019',900,1)
--SELECT Puntos FROM Persona WHERE idPersona = 900 
CREATE Trigger Pedidos ON Pedido AFTER INSERT AS BEGIN  UPDATE Persona set Persona.puntos = Persona.Puntos + (.10 * convert(int,floor(inserted.costoTotal))), Persona.esCliente = 1 FROM Persona, inserted WHERE Persona.idPersona = inserted.idPersona END

--Este trigger actualiza la cantidad de puntos de una Persona si su tipo de pago es con puntos
CREATE Trigger PagoPuntos ON Pedido AFTER INSERT AS BEGIN UPDATE Persona set Persona.puntos = Persona.Puntos - (inserted.costoTotal), Persona.esCliente = 1 FROM Persona, inserted, TipoPago WHERE Persona.idPersona = inserted.idPersona AND TipoPago.noTicket = inserted.noTicket AND TipoPago = 'Puntos' END


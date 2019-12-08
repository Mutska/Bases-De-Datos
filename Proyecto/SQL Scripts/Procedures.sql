-- EJECUTAR INDIVIDUALMENTE

--Procedimiento almacenado que nos permite llenar la tabla Bonos para todos los empleados que llevan trabajando un multiplo de 5 anios
--Se les asigna un Bono de 1500 pesos por cada 5 años que esten trabajando
CREATE PROCEDURE SetBonos AS DECLARE @fecha DATETIME SET @fecha = CONVERT(VARCHAR,GETDATE(),103) INSERT INTO Bono(monto , fechaEntrega, idPersona) SELECT (c.num * 1500), @fecha, c.idPersona FROM  (SELECT idPersona, floor((DATEDIFF(year, fechaContratacion, GETDATE())) / 5) num FROM Persona WHERE DATEDIFF(year, fechaContratacion, GETDATE()) > 4 AND (DATEDIFF(year, fechaNacimiento, GETDATE())) % 5  = 0 ) AS c;

--Procedimiento almacenado que nos permite cambiar el precio de las salsa por presentacion 
CREATE PROCEDURE UpdatePrice @presentacion nvarchar(255), @precio money AS UPDATE Salsa SET precio = @precio WHERE presentacion = @presentacion;
--Ejemplo
--select  *  from Salsa where presentacion = 'cuarto';
--exec UpdatePrice @presentacion = 'Cuarto', @precio = 35;
--select  *  from Salsa where presentacion = 'cuarto';

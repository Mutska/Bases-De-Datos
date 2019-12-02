--CREAMOS BASE DE DATOS

--Seleccionamos master para creacion de base
USE Master;
GO
--Validamos en sys si la base ya existe
PRINT N'Validamos si la base existe';
IF EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'Taqueria20201')
BEGIN
PRINT N'Base ya existe';
DROP DATABASE Taqueria20201;
END;
GO
--Creamos la base
CREATE DATABASE Taqueria20201;
/*
ON
( NAME = Taqueria20201,
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Taqueria20201.mdf',
  SIZE = 10,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 5 )

LOG ON

( NAME = 'Taqueria20201_Log',
  FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Taqueria20201_Log.ldf',
  SIZE = 5MB,
  MAXSIZE = 100MB,
  FILEGROWTH = 5MB );
*/
PRINT N'Base de datos creada correctamente';
GO

--CREAMOS TABLAS DE LA BASE DE DATOS
SET DATEFORMAT dmy
USE Taqueria20201;

CREATE TABLE Persona (
  idPersona int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL,
  paterno nvarchar(255) NOT NULL,
  materno nvarchar(255) NOT NULL,
  genero nvarchar(255) NOT NULL,
  fechaNacmiento date NOT NULL CHECK(DATEDIFF(year, fechaNacmiento, GETDATE()) > 18),
  estado nvarchar(255) NOT NULL,
  municipio nvarchar(255) NOT NULL,
  CP int NOT NULL,
  calle nvarchar(255) NOT NULL,
  numInterno int,
  numExterno int NOT NULL,
  correoElectronico nvarchar(255),

  tipoEmpleado nvarchar(255),
  RFC nvarchar(255),
  CURP nvarchar(255),
  fechaContratacion date,
  tipoSangre nvarchar(255),
  transporte nvarchar(255),
  licencia int,

  puntos int,

  esEmpleado int NOT NULL,
  esCliente int NOT NULL,

  idSucursal int,
  CONSTRAINT tipoEmpleado_chk CHECK (tipoEmpleado IN ('Taquero', 'Tortillero', 'Parrillero', 'Mesero', 'Cajero', 'Repartidor')),
  CONSTRAINT sangre_chk CHECK (tipoSangre IN ('O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-')),
  CONSTRAINT esEmpleado_chk CHECK (esEmpleado = 1 OR esEmpleado = 0),
  CONSTRAINT esCliente_chk CHECK (esEmpleado = 1 OR esEmpleado = 0)
)

CREATE TABLE TipoEmpleado (
  tipoEmpleado nvarchar(255) PRIMARY KEY,
  salario money NOT NULL
)

CREATE TABLE TelefonoPersona (
  idPersona int NOT NULL,
  telefono int NOT NULL
)

CREATE TABLE Bono (
  numBono int PRIMARY KEY IDENTITY(1, 1),
  monto money NOT NULL,
  fechaEntrega date NOT NULL,
  idPersona int NOT NULL
)

CREATE TABLE Sucursal (
  idSucursal int PRIMARY KEY IDENTITY(1, 1),
  estado nvarchar(255) NOT NULL,
  municipio nvarchar(255) NOT NULL,
  CP int NOT NULL,
  calle nvarchar(255) NOT NULL,
  numInterno int,
  numExterno int NOT NULL
)

CREATE TABLE TelefonoSucursal (
  idSucursal int NOT NULL,
  telefono int NOT NULL
)

CREATE TABLE Proveedor (
  idProveedor int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL,
  categoria nvarchar(255) NOT NULL CHECK(categoria IN ('Carne', 'Verdura', 'Fruta', 'Bebidas', 'Alcohol', 'Harinas')),
  estado nvarchar(255) NOT NULL,
  CP int NOT NULL,
  calle nvarchar(255) NOT NULL,
  municipio nvarchar(255) NOT NULL,
  numExterno int NOT NULL,
  numInterno int
)

CREATE TABLE TelefonoProveedor (
  idProveedor int NOT NULL,
  telefono int NOT NULL
)

CREATE TABLE Proveer (
  idProveedor int,
  idSucursal int,
  monto money,
  fechaPedido datetime,
  PRIMARY KEY(idProveedor, idSucursal)
)

CREATE TABLE Articulo (
  idArticulo int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL,
  precio money NOT NULL,
  cantidad int NOT NULL,
  fechaCompra date NOT NULL,
  marca nvarchar(255) NOT NULL,
  idSucursal int NOT NULL,
  CONSTRAINT marcaNombre1 UNIQUE(nombre, marca)
)

CREATE TABLE Producto (
  idProducto int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL,
  precio money NOT NULL,
  cantidad int NOT NULL,
  fechaCompra date NOT NULL,
  marca nvarchar(255) NOT NULL,
  fechaCaducidad date NOT NULL,
  idSucursal int,
  CONSTRAINT marcaNombre2 UNIQUE(nombre, marca)
)

CREATE TABLE TenerPlatillo (
  idPlatillo int NOT NULL,
  idProducto int NOT NULL,
  cantidad int NOT NULL,
  PRIMARY KEY(idPlatillo, idProducto)
)

CREATE TABLE TenerSalsa (
  idSalsa int NOT NULL,
  idProducto int NOT NULL,
  cantidad int NOT NULL,
  PRIMARY KEY(idSalsa, idProducto)
)

CREATE TABLE Recomendar (
  idPlatillo int NOT NULL,
  idSalsa int NOT NULL
  PRIMARY KEY(idPlatillo, idSalsa)
)

CREATE TABLE Platillo (
  idPlatillo int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL UNIQUE,
  precio int NOT NULL
)

CREATE TABLE Salsa (
  idSalsa int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL UNIQUE,
  precio money NOT NULL,
  nivelPicor nvarchar(255) NOT NULL CHECK (nivelPicor IN('Bajo', 'Medio', 'Alto', 'Extremo')),
  presentacion nvarchar(255) NOT NULL CHECK (presentacion IN('Cuarto', 'Medio', 'Litro'))
)

CREATE TABLE Pedido (
  noTicket int PRIMARY KEY,
  costoTotal money NOT NULL,
  fecha date NOT NULL CHECK (fecha <= GETDATE()),
  idPersona int NOT NULL
)

CREATE TABLE EstarPlatillo (
  noTicket int NOT NULL,
  idPlatillo int NOT NULL,
  PRIMARY KEY(noTicket, idPlatillo)
)

CREATE TABLE EstarSalsa (
  noTicket int NOT NULL,
  idSalsa int NOT NULL,
  PRIMARY KEY(noTicket, idSalsa)
)

CREATE TABLE TipoPago (
  noTicket int NOT NULL,
  tipoPago nvarchar(255) CHECK (tipoPago IN ('Puntos', 'Tarjeta', 'Efectivo'))
)

ALTER TABLE Bono ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)
ALTER TABLE TelefonoPersona ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)
ALTER TABLE Persona ADD FOREIGN KEY (tipoEmpleado) REFERENCES TipoEmpleado (tipoEmpleado)
ALTER TABLE Persona ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)

ALTER TABLE TelefonoProveedor ADD FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)
ALTER TABLE Proveer ADD FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)

ALTER TABLE Proveer ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE Articulo ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE Producto ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE TelefonoSucursal ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)

ALTER TABLE Recomendar ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE Recomendar ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)

ALTER TABLE TenerPlatillo ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE TenerSalsa ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)
ALTER TABLE TenerPlatillo ADD FOREIGN KEY (idProducto) REFERENCES Producto (idProducto)
ALTER TABLE TenerSalsa ADD FOREIGN KEY (idProducto) REFERENCES Producto (idProducto)

ALTER TABLE TipoPago ADD FOREIGN KEY (noTicket) REFERENCES Pedido (noTicket)
ALTER TABLE Pedido ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)

ALTER TABLE EstarSalsa ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)
ALTER TABLE EstarSalsa ADD FOREIGN KEY (noTicket) REFERENCES Pedido (noTicket)
ALTER TABLE EstarPlatillo ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE EstarPlatillo ADD FOREIGN KEY (noTicket) REFERENCES Pedido (noTicket)

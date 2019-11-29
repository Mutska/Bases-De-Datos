CREATE TABLE Persona (
  idPersona int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255) NOT NULL,
  paterno nvarchar(255) NOT NULL,
  materno nvarchar(255) NOT NULL,
  estado nvarchar(255) NOT NULL,
  municipio nvarchar(255) NOT NULL,
  CP int NOT NULL,
  calle nvarchar(255) NOT NULL,
  numInterno int NOT NULL,
  numExterno int NOT NULL,
  fechaNacmiento date CHECK (DATEDIFF(year, fechaNacimiento, GETDATE()) > 18) NOT NULL,
  correoElectronico nvarchar(255),

  RFC nvarchar(255) UNIQUE NOT NULL,
  CURP nvarchar(255) UNIQUE NOT NULL,
  tipoEmpleado nvarchar(255),
  salario int,
  fechaContratacion date,
  tipoSangre nvarchar(255) CHECK (tipoSangre IN ("O+", "O-", "A+" "A-", "B+", "B-", "AB+", "AB-")),
  transporte nvarchar(255),
  licencia int,

  puntos int,
  esEmpleado int NOT NULL,
  esCliente int NOT NULL,

  idSucursal int UNIQUE,
)
GO

CREATE TABLE Bono (
  numBono int PRIMARY KEY IDENTITY(1, 1),
  monto int,
  fechaEntrega date,
  idPersona int
)
GO

CREATE TABLE Sucursal (
  idSucursal int PRIMARY KEY IDENTITY(1, 1)
)
GO

CREATE TABLE Proveedor (
  idProveedor int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  telefono int,
  categoria nvarchar(255),
  estado nvarchar(255),
  CP int,
  calle nvarchar(255),
  municipio nvarchar(255),
  numExterno int,
  numInterno int
)
GO

CREATE TABLE Proveer (
  idSucursal int,
  idProveedor int,
  monto int,
  fechaPedido datetime
)
GO

CREATE TABLE Productos (
  idProducto int PRIMARY KEY IDENTITY(1, 1),
  precio int,
  cantidad int,
  fechaCompra datetime,
  marca nvarchar(255),
  fechaCaducidad datetime,
  idSucursal int
)
GO

CREATE TABLE Articulos (
  idArticulo int PRIMARY KEY IDENTITY(1, 1),
  precio int,
  cantidad int,
  fechaCompra datetime,
  marca nvarchar(255),
  idSucursal int
)
GO

CREATE TABLE Tener (
  idPlatillo int,
  idSalsa int,
  idProducto int,
  cantidad int
)
GO

CREATE TABLE Platillo (
  idPlatillo int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  precio int
)
GO

CREATE TABLE Recomendar (
  idPlatillo int,
  idSalsa int
)
GO

CREATE TABLE Salsa (
  idSalsa int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  precio int,
  nivelPicor nvarchar(255),
  presentacion nvarchar(255)
)
GO

CREATE TABLE Compra (
  noTicket int,
  costoTotal int,
  tipoPago nvarchar(255),
  fechaCompra date,
  idPlatillo int,
  idSalsa int,
  idPersona int
)
GO


ALTER TABLE Persona ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE Bono ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)

ALTER TABLE Proveer ADD FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)

ALTER TABLE Sucursal ADD FOREIGN KEY (idSucursal) REFERENCES Proveer (idSucursal)
ALTER TABLE Articulos ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE Productos ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)

ALTER TABLE Platillo ADD FOREIGN KEY (idPlatillo) REFERENCES Recomendar (idPlatillo)
ALTER TABLE Platillo ADD FOREIGN KEY (idPlatillo) REFERENCES Tener (idPlatillo)
ALTER TABLE Salsa ADD FOREIGN KEY (idSalsa) REFERENCES Recomendar (idSalsa)
ALTER TABLE Salsa ADD FOREIGN KEY (idSalsa) REFERENCES Tener (idSalsa)

ALTER TABLE Tener ADD FOREIGN KEY (idProducto) REFERENCES Productos (idProducto)
ALTER TABLE Compra ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)

ALTER TABLE Salsa ADD FOREIGN KEY (idSalsa) REFERENCES Compra (idSalsa)

ALTER TABLE Persona ADD FOREIGN KEY (idPersona) REFERENCES Compra (idPersona)

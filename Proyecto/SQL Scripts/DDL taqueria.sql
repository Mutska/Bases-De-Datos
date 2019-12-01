CREATE TABLE Persona (
  idPersona int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  paterno nvarchar(255),
  materno nvarchar(255),
  genero nvarchar(255),
  fechaNacmiento date,
  estado nvarchar(255),
  municipio nvarchar(255),
  CP int,
  calle nvarchar(255),
  numInterno int,
  numExterno int,
  RFC nvarchar(255),
  CURP nvarchar(255),
  tipoEmpleado nvarchar(255),
  salario int,
  fechaContratacion date,
  tipoSangre nvarchar(255),
  transporte nvarchar(255),
  licencia int,
  correoElectronico nvarchar(255),
  puntos int,
  esEmpleado int,
  esCliente int,
  idSucursal int
)
GO

CREATE TABLE TelefonoPersona (
  idPersona int,
  telefono int
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
  idSucursal int PRIMARY KEY IDENTITY(1, 1),
  estado nvarchar(255),
  municipio nvarchar(255),
  CP int,
  calle nvarchar(255),
  numInterno int,
  numExterno int
)
GO

CREATE TABLE TelefonoSucursal (
  idSucursal int,
  telefono int
)
GO

CREATE TABLE Proveedor (
  idProveedor int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  categoria nvarchar(255),
  estado nvarchar(255),
  CP int,
  calle nvarchar(255),
  municipio nvarchar(255),
  numExterno int,
  numInterno int
)
GO

CREATE TABLE TelefonoProveedor (
  idProveedor int,
  telefono int
)
GO

CREATE TABLE Proveer (
  idSucursal int,
  idProveedor int,
  monto int,
  fechaPedido datetime
)
GO

CREATE TABLE Articulos (
  idArticulo int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  precio int,
  cantidad int,
  fechaCompra datetime,
  marca nvarchar(255),
  idSucursal int
)
GO

CREATE TABLE Productos (
  idProducto int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  precio int,
  cantidad int,
  fechaCompra datetime,
  marca nvarchar(255),
  fechaCaducidad datetime,
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

CREATE TABLE Recomendar (
  idPlatillo int,
  idSalsa int
)
GO

CREATE TABLE Platillo (
  idPlatillo int PRIMARY KEY IDENTITY(1, 1),
  nombre nvarchar(255),
  precio int
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

CREATE TABLE TipoDePago (
  noTicket int,
  tipoPago nvarchar(255)
)
GO

ALTER TABLE Bono ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)

ALTER TABLE TelefonoPersona ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)
ALTER TABLE Persona ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)

ALTER TABLE TelefonoProveedor ADD FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)
ALTER TABLE Proveer ADD FOREIGN KEY (idProveedor) REFERENCES Proveedor (idProveedor)

ALTER TABLE Proveer ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE Articulos ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE Productos ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)
ALTER TABLE TelefonoSucursal ADD FOREIGN KEY (idSucursal) REFERENCES Sucursal (idSucursal)

ALTER TABLE Recomendar ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE Recomendar ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)

ALTER TABLE Tener ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE Tener ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)
ALTER TABLE Tener ADD FOREIGN KEY (idProducto) REFERENCES Productos (idProducto)

ALTER TABLE TipoDePago ADD FOREIGN KEY (noTicket) REFERENCES Compra (noTicket)
ALTER TABLE Compra ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)
ALTER TABLE Compra ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE Compra ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)

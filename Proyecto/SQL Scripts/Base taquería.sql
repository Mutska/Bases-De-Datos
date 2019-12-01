CREATE TABLE Persona (
  idPersona int PRIMARY KEY AUTO_INCREMENT,
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
  correoElectronico nvarchar(255) NOT NULL UNIQUE,

  RFC nvarchar(255) UNIQUE NOT NULL,
  CURP nvarchar(255) UNIQUE NOT NULL,
  tipoEmpleado nvarchar(255) CHECK (tipoEmpleado IN ("Taquero", "Tortillero", "Parrillero", "Mesero", "Cajero", "Repartidor")),
  salario int ,
  fechaContratacion date,
  tipoSangre nvarchar(255) CHECK (tipoSangre IN ("O+", "O-", "A+" "A-", "B+", "B-", "AB+", "AB-")),
  transporte nvarchar(255),
  licencia int,

  puntos int,

  esEmpleado int NOT NULL CHECK(),
  esCliente int NOT NULL,

  idSucursal int UNIQUE,
)
GO

CREATE TABLE Bono (
  numBono int PRIMARY KEY AUTO_INCREMENT,
  monto int NOT NULL,
  fechaEntrega date NOT NULL,
  idPersona int NOT NULL
)

CREATE TABLE Sucursal (
  idSucursal int PRIMARY KEY AUTO_INCREMENT
)

CREATE TABLE Proveedor (
  idProveedor int PRIMARY KEY AUTO_INCREMENT,
  nombre nvarchar(255) NOT NULL,
  telefono int NOT NULL,
  categoria nvarchar(255) CHECK (categoria IN("Carnes", "Verduras", "Fruta", "Refrescos", "Harina")) NOT NULL,
  estado nvarchar(255) NOT NULL,
  CP int NOT NULL,
  calle nvarchar(255) NOT NULL,
  municipio nvarchar(255) NOT NULL,
  numExterno int NOT NULL,
  numInterno int
)

CREATE TABLE Proveer (
  idSucursal int NOT NULL,
  idProveedor int NOT NULL,
  monto int NOT NULL,
  fechaPedido datetime NOT NULL
)

CREATE TABLE Productos (
  idProducto int PRIMARY KEY AUTO_INCREMENT,
  precio int NOT NULL,
  cantidad int NOT NULL,
  fechaCompra datetime NOT NULL,
  marca nvarchar(255) NOT NULL,
  fechaCaducidad datetime NOT NULL,
  idSucursal int NOT NULL
)
GO

CREATE TABLE Articulos (
  idArticulo int PRIMARY KEY AUTO_INCREMENT,
  precio int NOT NULL,
  cantidad int NOT NULL,
  fechaCompra datetime NOT NULL,
  marca nvarchar(255) NOT NULL,
  idSucursal int NOT NULL
)
GO

CREATE TABLE Tener (
  idPlatillo int NOT NULL,
  idSalsa int NOT NULL,
  idProducto int NOT NULL,
  cantidad int
)
GO

CREATE TABLE Platillo (
  idPlatillo int PRIMARY KEY AUTO_INCREMENT,
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
  idSalsa int PRIMARY KEY AUTO_INCREMENT,
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

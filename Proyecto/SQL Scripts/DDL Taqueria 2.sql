CREATE TABLE Persona (
  idPersona int PRIMARY KEY AUTO_INCREMENT,
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

  RFC nvarchar(255),
  CURP nvarchar(255),
  tipoEmpleado nvarchar(255) CHECK (tipoEmpleado IN ("Taquero", "Tortillero", "Parrillero", "Mesero", "Cajero", "Repartidor")),
  salario int,
  fechaContratacion date,
  tipoSangre nvarchar(255) CHECK (tipoSangre IN ("O+", "O-", "A+" "A-", "B+", "B-", "AB+", "AB-")),
  transporte nvarchar(255),
  licencia int,

  puntos int,

  esEmpleado int NOT NULL CHECK (esEmpleado = 1 OR esEmpleado = 0),
  esCliente int NOT NULL CHECK (esCliente = 1 OR esCliente = 0),

  idSucursal int
)

CREATE TABLE TelefonoPersona (
  idPersona int NOT NULL,
  telefono int NOT NULL
)

CREATE TABLE Bono (
  numBono int PRIMARY KEY AUTO_INCREMENT,
  monto int NOT NULL,
  fechaEntrega date NOT NULL,
  idPersona int NOT NULL
)

CREATE TABLE Sucursal (
  idSucursal int PRIMARY KEY AUTO_INCREMENT,
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
  idProveedor int PRIMARY KEY AUTO_INCREMENT,
  nombre nvarchar(255) NOT NULL,
  categoria nvarchar(255) NOT NULL CHECK(categoria IN ("Carne", "Verdura", "Fruta", "Bebidas", "Alcohol", "Harinas")),
  estado nvarchar(255) NOT NULL,
  CP int NOT NULL,
  calle nvarchar(255) NOT NULL,
  municipio nvarchar(255) NOT NULL,
  numExterno int NOT NULL,
  numInterno int
)
GO

CREATE TABLE TelefonoProveedor (
  idProveedor int NOT NULL,
  telefono int NOT NULL
)
GO

CREATE TABLE Proveer (
  idSucursal int NOT NULL,
  idProveedor int NOT NULL,
  monto int NOT NULL,
  fechaPedido date NOT NULL
)
GO

CREATE TABLE Articulos (
  idArticulo int PRIMARY KEY AUTO_INCREMENT,
  nombre nvarchar(255) UNIQUE NOT NULL,
  precio int NOT NULL,
  cantidad int NOT NULL,
  fechaCompra date NOT NULL,
  marca nvarchar(255) NOT NULL,
  idSucursal int
)
GO

CREATE TABLE Productos (
  idProducto int PRIMARY KEY AUTO_INCREMENT,
  nombre nvarchar(255) UNIQUE NOT NULL,
  precio int NOT NULL,
  cantidad int NOT NULL,
  fechaCompra date NOT NULL,
  marca nvarchar(255) NOT NULL,
  fechaCaducidad date NOT NULL CHECK(fechaCaducidad > fechaCompra),
  idSucursal int NOT NULL
)
GO

CREATE TABLE Tener (
  idPlatillo int NOT NULL,
  idSalsa int NOT NULL,
  idProducto int NOT NULL,
  cantidad int NOT NULL
)
GO

CREATE TABLE Recomendar (
  idPlatillo int NOT NULL,
  idSalsa int NOT NULL
)
GO

CREATE TABLE Platillo (
  idPlatillo int PRIMARY KEY AUTO_INCREMENT,
  nombre nvarchar(255) NOT NULL CHECK(nombre IN ("Tacos", "Tortas", "Burritos", "Quesadillas", "Gringas", "Bebidas")),
  precio int NOT NULL
)


CREATE TABLE Salsa (
  idSalsa int PRIMARY KEY AUTO_INCREMENT,
  nombre nvarchar(255) NOT NULL,
  precio int NOT NULL,
  nivelPicor nvarchar(255) NOT NULL CHECK (nivelPicor IN("Bajo", "Medio", "Alto", "Extremo")),
  presentacion nvarchar(255) NOT NULL CHECK (presentacion IN("Cuarto", "Medio", "Litro"))
)
GO

CREATE TABLE Compra (
  noTicket int AUTO_INCREMENT UNIQUE NOT NULL,
  costoTotal int,
  fechaCompra date CHECK (fechaCompra <= GETDATE()),
  idPlatillo int,
  idSalsa int,
  idPersona int NOT NULL
)
GO

CREATE TABLE TipoDePago (
  noTicket int,
  tipoPago nvarchar(255) CHECK (tipoPago IN ("Puntos", "Tarjeta", "Efectivo"))
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

ALTER TABLE Compra ADD FOREIGN KEY (idPlatillo) REFERENCES Platillo (idPlatillo)
ALTER TABLE Compra ADD FOREIGN KEY (idSalsa) REFERENCES Salsa (idSalsa)
ALTER TABLE Compra ADD FOREIGN KEY (idPersona) REFERENCES Persona (idPersona)

ALTER TABLE TipoDePago ADD FOREIGN KEY (noTicket) REFERENCES Compra (noTicket)
GO

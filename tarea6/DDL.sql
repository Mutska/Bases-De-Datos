--CREAMOS BASE DE DATOS

--Seleccionamos master para creacion de base
USE Master;
GO
--Validamos en sys si la base ya existe
PRINT N'Validamos si la base existe';
IF EXISTS (SELECT 1 FROM sys.databases WHERE [name] = 'Tarea6')
BEGIN
PRINT N'Base ya existe';
DROP DATABASE Tarea6;
END;
GO
--Creamos la base
CREATE DATABASE Tarea6
ON
( NAME = Tarea6,
  FILENAME = '/fbd/fundamentos/Tarea6.mdf',
  SIZE = 10,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 5 )

LOG ON

( NAME = 'Tarea6_Log',
  FILENAME = '/fbd/fundamentos/Tarea6_Log.ldf',
  SIZE = 5MB,
  MAXSIZE = 100MB,
  FILEGROWTH = 5MB );

PRINT N'Base de datos creada correctamente';
GO
--CREAMOS TABLAS DE LA BASE DE DATOS
SET DATEFORMAT dmy
USE Tarea6;

CREATE TABLE Empleado (
    CURP CHAR(18) PRIMARY KEY NOT NULL,
    nombre NVARCHAR(40) NOT NULL,
    paterno NVARCHAR(40) NOT NULL,
    materno NVARCHAR(40) NOT NULL,
    nacimiento DATETIME NOT NULL CHECK (DATEDIFF(year, nacimiento, GETDATE()) > 18),
    genero NVARCHAR(1) NOT NULL CHECK (genero IN ('M', 'F')),
    ciudad NVARCHAR(40) NOT NULL,
    cp INT NOT NULL,
    calle NVARCHAR(80) NOT NULL,
    num INT NOT NULL,
    supervisor CHAR(18)
)
GO

CREATE TABLE Empresa (
    RFC CHAR(12) PRIMARY KEY NOT NULL,
    razonSocial NVARCHAR(255) NOT NULL,
    ciudad NVARCHAR(40) NOT NULL,
    cp INT NOT NULL,
    calle NVARCHAR(80) NOT NULL,
    num INT NOT NULL
)
GO

CREATE TABLE Proyecto (
    numProy INT IDENTITY(1, 1) PRIMARY KEY,
    nombre NVARCHAR(255) NOT NULL,
    fechaInicio DATETIME NOT NULL,
    fechaFin DATETIME,
    RFC CHAR(12) NOT NULL
)

CREATE TABLE colaborar (
    numProy INT NOT NULL,
    CURP CHAR(18) NOT NULL,
    fechaInicio DATETIME NOT NULL,
    fechaFin DATETIME,
    numHoras Int NOT NULL,
    PRIMARY KEY (numProy, CURP)
)
GO

CREATE TABLE trabajar (
    CURP CHAR(18) NOT NULL,
    RFC  CHAR(12) NOT NULL,
    fechaIngreso DATETIME NOT NULL,
    salarioQuincenal money NOT NULL,
    PRIMARY KEY (CURP, RFC)
)
GO

CREATE TABLE dirigir (
    CURP CHAR(18) NOT NULL,
    RFC  CHAR(12) NOT NULL,
    fechaInicio DATETIME NOT NULL,
    PRIMARY KEY (CURP, RFC)
)
GO

ALTER TABLE [Empleado] ADD FOREIGN KEY ([supervisor]) REFERENCES [Empleado] ([CURP]) ON DELETE NO ACTION ON UPDATE NO ACTION
ALTER TABLE [Proyecto] ADD FOREIGN KEY ([RFC]) REFERENCES [Empresa] ([RFC]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE [colaborar] ADD FOREIGN KEY ([CURP]) REFERENCES [Empleado] ([CURP]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE [colaborar] ADD FOREIGN KEY ([numProy]) REFERENCES [Proyecto] ([numProy]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE [dirigir] ADD FOREIGN KEY ([CURP]) REFERENCES [Empleado] ([CURP]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE [dirigir] ADD FOREIGN KEY ([RFC]) REFERENCES [Empresa] ([RFC]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE [trabajar] ADD FOREIGN KEY ([CURP]) REFERENCES [Empleado] ([CURP]) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE [trabajar] ADD FOREIGN KEY ([RFC]) REFERENCES [Empresa] ([RFC]) ON DELETE CASCADE ON UPDATE CASCADE

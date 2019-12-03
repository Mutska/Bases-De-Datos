USE Taqueria20201;
ALTER TABLE TipoEmpleado CHECK CONSTRAINT ALL;
SET DATEFORMAT dmy
insert into TipoEmpleado (tipoEmpleado, salario) values ('Taquero', 1500);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Tortillero', 1500);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Parrillero', 5000);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Mesero', 5000);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Cajero', 2500);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Repartidor', 2000);

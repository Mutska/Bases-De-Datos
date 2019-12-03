USE Taqueria20201;

--Llenado de la tabla Tipo Empleado
ALTER TABLE TipoEmpleado CHECK CONSTRAINT ALL;
insert into TipoEmpleado (tipoEmpleado, salario) values ('Taquero', 1500);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Tortillero', 1500);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Parrillero', 5000);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Mesero', 5000);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Cajero', 2500);
insert into TipoEmpleado (tipoEmpleado, salario) values ('Repartidor', 2000);

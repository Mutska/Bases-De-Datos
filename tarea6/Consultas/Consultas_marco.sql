

--Ejercicio J  
select info.razonSocial, count(info.num_empleados) as num_empleados, YEAR(info.fechaIngreso) anio,  DATEPART(qq,info.fechaIngreso) trimestre , info.genero  from (select e.razonSocial, t.RFC,  count(m.CURP) num_empleados, genero, fechaIngreso from Empresa e join Trabajar t  on e.RFC = t.RFC join Empleado m on m.CURP = t.CURP group by e.razonSocial,t.RFC , m.genero, t.fechaIngreso) as info group by info.razonSocial, info.fechaIngreso, info.genero

--Ejercicio K aun no sale :v
select e.razonSocial, m.CURP, max(t.salarioQuincenal)  from Empresa e join Trabajar t  on e.RFC = t.RFC join Empleado m on m.CURP = t.CURP group by e.razonSocial, m.CURP, t.salarioQuincenal
 
--Ejercicio N
select p.numProy, p.nombre, p.fechaFin, p.fechaInicio, p.RFC from Colaborar c join Dirigir D on c.CURP = d.CURP join Proyecto p  on p.numProy = c.numProy 
 

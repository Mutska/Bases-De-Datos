from empleado import Empleado
import csv
import pandas

empleado = Empleado("Marco Antonio ","11/11/98","Aqui","Masculino","Universidad","8:00,16:00","27xwer24","Nada")
empleado2 = Empleado("Manuel","10/04/97","Alla","Masculino","Universidad","8:00,16:00","s3kmsnr24","Nada")
empleado3 = Empleado("Tredok","07/12/96","Ningun lugar","Masculino","Universidad","8:00,16:00","28bzxao","Nada")
Datos = [['Nombre', 'Fecha de nacimiento','Direccion','Sexo','Grado De Estudios','Horario','Licencia','Historial'],[
          empleado.nombre, empleado.fecha_de_nacimiento, empleado.direccion, empleado.sexo, empleado.grado, empleado.horario,
          empleado.licencia, empleado.historial], [
          empleado2.nombre, empleado2.fecha_de_nacimiento, empleado2.direccion, empleado2.sexo, empleado2.grado, empleado2.horario,
          empleado2.licencia, empleado2.historial], [
          empleado3.nombre, empleado3.fecha_de_nacimiento, empleado3.direccion, empleado3.sexo, empleado3.grado, empleado3.horario,
          empleado3.licencia, empleado3.historial]]
with open('empleados.csv','w') as CSV:
    writer = csv.writer(CSV)
    writer.writerows(Datos)

CSV.close()

lector = pandas.read_csv('empleados.csv')


print(lector)

from empleado import Empleado
import pandas
import csv
import os.path



def inicio():
    while True:
        print("Seleccione una opcion\n")
        print("1.-Empleados\n")
        print("2.-Licencias\n")
        print("3.-Examenes Medicos\n")
        print("4.-Salir\n")
        choice = input("Opcion: ")
        if choice.isnumeric() and int(choice) >=1 and int(choice) <=4:
            break
        else:
            print("ENTRADA INVALIDA INTENTE DE NUEVO")
    return int(choice)

def seleccion(a):
    if a == 1:
        empleados()

def empleados():
    while True:
        print("1.-Guardar nuevo empleado\n")
        print("2.-Leer lista de empleados\n")
        print("3.-Salir\n")
        choice = input("Opcion: ")
        if choice.isnumeric() and int(choice) == 1:
            print("Por favor llena los siguientes campos: \n")
            nombre = input("Nombre: ")
            apellido_paterno = input("\nApellido paterno: ")
            apellido_materno = input("\nApellido materno: ")
            fecha_de_nacimiento = input("\nFecha de nacimiento: ")
            direccion = input("\nDireccion: ")
            sexo = input("\nSexo: ")
            grado_de_estudios = input("\nGrado de estudios: ")
            horario_inicio = input("\nHora de inicio: ")
            horario_fin = input("\nHora de fin: ")
            historial = input("\nHistorial de placas: ")
            empleado = Empleado(nombre, apellido_paterno, apellido_materno, fecha_de_nacimiento, direccion, sexo, grado_de_estudios,
                                horario_inicio, horario_fin, historial)
            registrar(empleado)
        elif choice.isnumeric() and int(choice) == 2:
            lector = pandas.read_csv('empleados.csv')
            print(lector)
        elif choice.isnumeric() and int(choice) == 3:
            break
        else:
            print("ENTRADA INVALIDA")
    return 

def registrar(empleado):
    datos = [['Nombre', 'Apellido paterno', 'Apellido materno', 'Fecha de nacimiento', 'Direccion', 'Sexo', 'Grado de estudios', 
                'Horario de inicio', 'Horario de fin', 'Historial'], [empleado.nombre, empleado.apellido_paterno, empleado.apellido_materno,
                empleado.fecha_de_nacimiento, empleado.direccion, empleado.sexo, empleado.grado_estudios, empleado.horario_inicio,
                empleado.horario_fin, empleado.historial]]

    fila = [empleado.nombre, empleado.apellido_paterno, empleado.apellido_materno, empleado.fecha_de_nacimiento, empleado.direccion,
            empleado.sexo, empleado.grado_estudios, empleado.horario_inicio, empleado.horario_fin, empleado.historial]

    if os.path.exists('empleados.csv'):
        with open('empleados.csv', 'a') as CSV:
            writer = csv.writer(CSV)
            writer.writerow(fila)
        CSV.close()
    else:
        with open('empleados.csv','w') as CSV:
            writer = csv.writer(CSV)
            writer.writerows(Datos)
        CSV.close()
    return 


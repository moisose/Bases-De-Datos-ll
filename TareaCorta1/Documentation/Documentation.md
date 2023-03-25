# Documentation

## **Instituto Tecnológico de Costa Rica**

## **IC4302 - Bases de Datos II**

## **Documentación Proyecto Opcional**

### **Profesor**: Nereo Campos Araya

### **Estudiantes**:

- Fiorella Zelaya Coto - 2021453615
- Isaac Araya Solano - 2018151703
- Melany Salas Fernández - 2021121147
- Moisés Solano Espinoza - 2021144322
- Pablo Arias Navarro - 2021024635

---

# **Guía de instalación y uso de la tarea**

1- Descomprimir el archivo .zip y abrir la línea de comandos wsl en la ubicación de la carpeta **tareaCorta1**

![paso1](resources/paso1.png)

Posteriormente, puede ir a las carpetas **charts\databases** donde encontrará el archivo **values.yaml**, aquí podrá escoger la base de datos a monitorear cambiando el valor de **enabled** a true

![paso1.2](resources/paso1.2.png)

2- Ir a la carpeta **docker** con el comando **cd docker**

![paso2](resources/paso2.png)

3- Ejecutar el comando **bash build.sh**, si da error al ejecutar, intente con el comando **dos2unix build.sh** y, posteriormente, ejecute de nuevo **bash build.sh**

![paso3](resources/paso3.png)

4- Ir a la carpeta **charts** con el comando **cd ../charts**

![paso4](resources/paso4.png)

5- Ejecutar el comando **bash install.sh**, si da error al ejecutar, intente con el comando **dos2unix install.sh** y, posteriormente, ejecute de nuevo **bash install.sh**, ya con esto, debería ver los distintos pods en lens

![paso5](resources/paso5.png) 

6- Una vez instalado y cuando los pods están arriba, abrir la carpeta **Gatling** e ir a **gatling-charts-highcharts-bundle-3.9.2/bin** y ejecutar **galing.bat**

![paso6](resources/paso6.png)

7- Esperar que abra la consola.

8- Una vez abierta, seleccionar la opción **[1]** presionando las teclas 1, seguido de enter.

![paso8](resources/paso8.png)

9- Aparecerá lo siguiente, debe presionar la tecla enter nuevamente pata que la prueba de carga comience.

![paso9](resources/paso9.png)

10- Puede entrar a la dirección que sale en consola para verificar la cantidad de usuarios que lograron conectarse con éxito.

![paso10](resources/gatlingTest.png)

Si ingresa, puede que salga algo similar a lo siguiente:

![Resultado Gatling](resources/gatlingResult.png)

11- Posteriormente, puede observar las métricas en **Grafana**, seleccionan al pod **grafana-deployment** desde lens

![paso11](resources/paso11.png)

12-  Ir a la sección de containers-ports y seleccionar **foward** para ingresar al Grafana.

![paso12](resources/paso12.png)

13- Va a abrir la siguiente ventana:

![paso13](resources/paso13.png)

14- Para encontrar el password de grafana, dirigirse a secrets en Lens y seleccionar **grafana-admin-credentials** y ver el password, copiarlo y pegarlo en la ventana que se abrió anteriormente.

![paso14](resources/paso14.png)

15- Ingresar y ver las métricas.

16- Para desinstalar, ejecute el comando **bash uninstall.sh**

# **Configuración de las herramientas**

## **MariaDB**

Para instalar el cliente de MariaDB se creó la imagen de MariaDB que incluye al cliente utilizando un Dockerfile. En nombre de esta imagen se guarda en el archivo ubicado en stateless/values.yaml que contiene otros valores de configuracion como el mapName, name y volumeName.

![stateless/valuesyaml](resources/valuesyaml_mariadb.png)

En charts/databases/values.yaml se tienen algunas configuraciones para la instancia de MariaDB, como datos necesarios para la autenticación, la cantidad de replicas que se necesitan, los nombres del nodo primario y nodos secundarios, el namespace y también podemos activar o deactivar la ejecución del pod de MariaDB. 

![databases/valuesyaml](resources/valuesyaml_databases_mariadb.png)

Para iniciar el cliente de MariaDB que permite acceder a la base de datos se utilizó un *Job*. En el archivo *mariadbDB.yaml* se define un ConfigMap y el Job. 

Dentro del Job se declaran las variables de entorno y se asigna el valor de cada una. Se declaran las variables de entorno para el *host, password y database*. También se utilizan los valores de las configuraciones que guardamos en stateless/values.yaml para asignar la imagen que le corresponde al Pod y asignar nombres a volúmenes u otros.

Asimismo, en este Job se indica el comando que se debe ejecutar en *args*, el cual se encarga de cargar el archivo sql *(babynames.sql)* que contiene las tablas y los procedimientos almacenados de la base de datos. 
<br>

## **MariaDB Galera**

Para instalar el cliente de MariaDB Galera se creó la imagen de MariaDB Galera que incluye al cliente utilizando un Dockerfile. En nombre de esta imagen se guarda en el archivo ubicado en stateless/values.yaml que contiene otros valores de configuracion como el mapName, name y volumeName.

![stateless/valuesyaml](resources/valuesyaml_mariadbgalera.png)

En charts/databases/values.yaml se tienen algunas configuraciones para la instancia de MariaDB Galera, como la cantidad de replicas que se requieren y los datos de autenticación (contraseña) para el usuario y la base de datos. También podemos activar o deactivar la ejecución del pod de MariaDB. 

![databases/valuesyaml](resources/valuesyaml_databases_mariadbgalera.png)

Para iniciar el cliente de MariaDB Galera que permite acceder a la base de datos se utilizó un *Job*. En el archivo *mariadbDBGalera.yaml* se define un ConfigMap y el Job.

Dentro del Job se declaran las variables de entorno y se asigna el valor de cada una. Se declaran las variables de entorno para el *host y password*. También se utilizan los valores de las configuraciones que guardamos en stateless/values.yaml para asignar la imagen que le corresponde al Pod y asignar nombres a volúmenes u otros.

Asimismo, en este Job se indica el comando que se debe ejecutar en *args*, el cual se encarga de cargar el archivo sql *(babynames.sql)* que contiene las tablas y los procedimientos almacenados de la base de datos.

<br>

## **PostGreSQL**

Para instalar el cliente de PostGreSQL se creó la imagen de PostGreSQL que incluye al cliente utilizando un Dockerfile. En nombre de esta imagen se guarda en el archivo ubicado en stateless/values.yaml que contiene otros valores de configuracion como el mapName, name y volumeName.

![stateless/valuesyaml](resources/valuesyaml_postgres.png)

En charts/databases/values.yaml se tienen algunas configuraciones para la instancia de PostGreSQL, como datos necesarios para la autenticación (contraseña y nombre de base de datos), el namespace y también podemos activar o desactivar la ejecución del pod de PostGreSQL. 

![databases/valuesyaml](resources/valuesyaml_databases_postgres.png)

Para iniciar el cliente de PostGreSQL que permite acceder a la base de datos se utilizó un *Job*. En el archivo *postgresql.yaml* se define un ConfigMap y el Job.

Dentro del Job se declaran las variables de entorno y se asigna el valor de cada una. Se declaran las variables de entorno para el *host y password*. También se utilizan los valores de las configuraciones que guardamos en stateless/values.yaml para asignar la imagen que le corresponde al Pod y asignar nombres a volúmenes u otros.

Asimismo, en este Job se indica el comando que se debe ejecutar en *args*, el cual se encarga de cargar el archivo sql *(postgres.sql)* que contiene las tablas y los procedimientos almacenados de la base de datos. 

<br>

## **PostGreSQL High Availability**

Para instalar el cliente de PostGreSQL High Availability se creó la misma imagen de PostGreSQL que incluye al cliente utilizando un Dockerfile. En nombre de esta imagen se guarda en el archivo ubicado en stateless/values.yaml que contiene otros valores de configuracion como el mapName, name y volumeName. Se utiliza la misma configuración de PostGreSQL.

![stateless/valuesyaml](resources/valuesyaml_postgres.png)

En charts/databases/values.yaml se tienen algunas configuraciones para la instancia de PostGreSQL High Availability, como datos necesarios para la autenticación (contraseñas), el namespace y también podemos activar o desactivar la ejecución del pod de PostGreSQL. 

![databases/valuesyaml](resources/valuesyaml_databases_postgresha.png)

Para iniciar el cliente de PostGreSQL High Availability que permite acceder a la base de datos se utilizó un *Job*. En el archivo *postgresqlha.yaml* se define un ConfigMap y el Job. 

Dentro del Job se declaran las variables de entorno y se asigna el valor de cada una. Se declaran las variables de entorno para el *host y password*. También se utilizan los valores de las configuraciones que guardamos en stateless/values.yaml para asignar la imagen que le corresponde al Pod y asignar nombres a volúmenes u otros.

Asimismo, en este Job se indica el comando que se debe ejecutar en *args*, el cual se encarga de cargar el archivo sql *(postgres.sql)* que contiene las tablas y los procedimientos almacenados de la base de datos.

# **Otros componentes**

## **API con Flask**

Para realizar las pruebas de carga se necesita usar Gatling, pero no todas las bases de datos tienen una interfaz para utilizar endpoints HTTP, por lo que se necesitó usar una aplicación intermediaria. 

Esta aplicación se desarrolló en Python utilizando la librería Flask. Cada base de datos utiliza un API distinto.

Para poder ejecutar un API de la base de datos se debe tener un Deployment corriendo en Kubernetes. Para lograr esto, se creó la imagen de cada API con un Dockerfile. El nombre de las imágenes se guarda en el archivo ubicado en stateless/values.yaml junto a otras configuraciones que servirán para configurar el Deployment, como name y nameApp.

![databases/valuesyaml](resources/valuesyaml_APIs.png)

El Deployment de cada API se ubica en la carpeta charts/stateless/templates. Todos los Deployments siguen la misma estructura: Primero se define el servicio de tipo Deployment y luego un Servicio de NodePort para exponer el puerto y que se pueda comunicar el API con la base de datos.

En el archivo yaml del Deployment de cada API se accede a los valores definidos en el archivo values.yaml para configurar el Deployment, como nombres de volúmenes o labels. También se definen las variables de entorno con sus valores.

El servicio NodePort de todos los Deployments están configurados en el port 5000, targetPort 5000, nodePort 3000 y porotocol TCP. Aquí también se accede a los valores definidos en el archivo values.yaml para configurar algunos aspectos como el nombre de la app del selector o labels.


# **Pruebas de carga**

## **Dataset**

## **Configuración de las Pruebas**

Se realizó una prueba de carga con la siguiente configuración para los usuarios:

![usersPerSec](resources/userPerSecConfig.png)

    Nota: Para elasticsearch la configuración de los usuarios se hace de otra manera.

Para las distintas consultas se realizaron distintos escenarios, permitiendo simulación de usuarios haciendo distintas consultas de la siguiente manera:

- **Post - Create**

Se hace la simulación de 5 usuarios por segundo durante 30 minutos, para esto se generan escenario que va a mandar consultas post al http que se definió previamente.

![post](resources/gatlingCreate.png)

- **Get - Select**

Se hace la simulación de 2 usuarios por segundo durante 30 minutos, se genera el escenario para enviar consultas get al http que se definió previamente.

![post](resources/gatlingSelect.png)

- **Put - Update**

Se hace la simulación de 2 usuarios por segundo durante 30 minutos, se genera el escenario para enviar  consultas put al http que se definió previamente.

![post](resources/gatlingUpdate.png)

- **Delete - Delete**

Se hace la simulación de 3 usuarios por segundo durante 30 minutos, se genera el escenario para enviar consultas delete al http definido.

![post](resources/gatlingDelete.png)

## **Resultados de las pruebas**

### **1- MariaDB**

### **2- MariaDB Galera**

### **3- PostGreSQL**

### **4- PostGRE HA**

### **5- Elasticsearch**

### **6- MongoDB**

## **Resultados en grafana**

### **1- MariaDB**

![1](resources/mariadb/1.png)

![2](resources/mariadb/2.png)

![3](resources/mariadb/3.png)

![4](resources/mariadb/4.png)

![5](resources/mariadb/5.png)

![6](resources/mariadb/6.png)

![7](resources/mariadb/7.png)

![8](resources/mariadb/8.png)

![9](resources/mariadb/9.png)

![10](resources/mariadb/10.png)

![11](resources/mariadb/11.png)

![12](resources/mariadb/12.png)

### **2- MariaDB Galera**
![1](resources/galera/1.png)

![2](resources/galera/2.png)

![3](resources/galera/3.png)

![4](resources/galera/4.png)

![5](resources/galera/5.png)

![6](resources/galera/6.png)

![7](resources/galera/7.png)

![8](resources/galera/8.png)

![9](resources/galera/9.png)

![10](resources/galera/10.png)

![11](resources/galera/11.png)

![12](resources/galera/12.png)

![13](resources/galera/13.png)

![14](resources/galera/14.png)

![15](resources/galera/15.png)

### **3- PostGreSQL**

![1](resources/PostGreSQL/1.png)

![2](resources/PostGreSQL/2.png)

![3](resources/PostGreSQL/3.png)

![4](resources/PostGreSQL/4.png)

![5](resources/PostGreSQL/5.png)

![6](resources/PostGreSQL/6.png)

![7](resources/PostGreSQL/7.png)

![8](resources/PostGreSQL/8.png)

### **4- PostGre HA**

![1](resources/PostGreHA/1.png)

![2](resources/PostGreHA/2.png)

![3](resources/PostGreHA/3.png)

![4](resources/PostGreHA/4.png)

![5](resources/PostGreHA/5.png)

![6](resources/PostGreHA/6.png)

![7](resources/PostGreHA/7.png)


### **5- Elasticsearch**

### **6- MongoDB**

# **Conclusiones**

**1-** Es importante la comunicación entre el los miembros de grupo de trabajo.

**2-** Se debe mantener la organización para poder realizar la tarea.

**3-** Entender los conceptos vistos en clase ayuda en la realización de la tarea.

**4-** El tener un buen control de versiones y saber utilizar github facilita el trabajo en equipo.

**5-** Se deben aplicar buenas prácticas de programación para mantener el orden.

**6-** Mantener la estructura del proyecto es esencial.

**7-** Se debe asegurar un código legible y entendible.

**8-**  Docker es una herramienta muy útil para nosotros como desarrolladores, pues nos permite ejecutar una aplicación de manera consistente en cualquier entorno, facilitando en muchos casos el desarrollo del software y aún más importante, permitiendo la portabilidad y escalabilidad de la aplicación.

**9-** Grafana es una herramienta de visualización y monitoreo que es muy utilizada en una amplia gama de casos y entornos de trabajo, ya que por medio de paneles de visualización nos brinda una visualización clara de los sistemas y aplicaciones, esto nos ayuda a nosotros como usuarios, debido a que nos permite ver el rendimiento de la aplicación o sistema,  identificar problemas, reconocer  irregularidades y tomar medidas correctivas rápidamente.  

**10-** Similar a Grafana, Gatling es una herramienta de mucha utilidad principalmente para ver el rendimiento de un sistema e identificar posibles errores que podrían presentarse en diferentes entornos antes de que el sistema sea lanzado o se implemente en una empresa. Con esta somos capaces de realizar pruebas de carga y estrés en el sistema para identificar posibles cuellos de botella en el rendimiento simulando grandes cargas de trabajo. Lo anterior es fundamental para nosotros, pues nos permite asegurar el buen rendimiento y funcionamiento del sistema o aplicación que estemos desarrollando.

# **Recomendaciones**

**1-** Hacer reuniones periódicas para ver el avance de la tarea.

**2-** Mantener la organización de la tarea, según el ejemplo del profesor.

**3-** Repasar los conceptos vistos en clase y complementar con investigación.

**4-** Aprender a hacer uso de github.

**5-** Seguir un estándar de código.

**6-** Seguir aprendiendo y enriqueciendo el conocimiento después de finalizar la tarea.

**7-** Investigar sobre las diferentes herramientas esenciales para desarrollar la solución e ir tomando apuntes sobre los aspectos importantes de cada uno de estas.

**8-** Tener una buena estructura del proyecto y dividir el proyecto de forma funcional.

**9-** Repartir y asignar tareas a cada integrante del equipo para progresar.

**10-** Definir roles en el equipo de trabajo para mantener el orden.
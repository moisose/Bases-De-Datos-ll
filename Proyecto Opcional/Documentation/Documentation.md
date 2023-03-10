## **Instituto Tecnológico de Costa Rica**

## **IC4302 - Bases de Datos II** 

## **Documentación Proyecto Opcional** 

### **Profesor**: Nereo Campos Araya 

### **Estudiantes**:

* Fiorella Zelaya Coto - 2021453615
* Isaac Araya Solano - 2018151703
* Melany Salas Fernández - 2021121147
* Moisés Solano Espinoza - 2021144322

-------------------------------

## **Diagramas**

### Diagrama Entidad Relación

![DiagramaER](Resources/Proyecto%20Opcional%20Bases%202.png)

[Diagramas en LucidChart](https://lucid.app/lucidchart/1471d6bb-d75f-4f22-af71-f25823766e56/edit?viewport_loc=57%2C62%2C2127%2C877%2C0_0&invitationId=inv_534ef551-eae1-471f-8f29-38809b47fe84)

-------------------------------

## **Pasos para la ejecución**

1- Abrir una consola WSL, en la carpeta del proyecto <br>
![paso1](Resources/Paso1.png)

2- Ir a la carpeta "WindyUI" y luego a la carpeta "Docker" <br>
![paso2](Resources/Paso2.png)

3- Ejecutar el archivo build.sh con el siguiente comando: **bash build.sh** <br>
![paso3](Resources/Paso3.png)

4- En la misma consola WSL, en la carpeta del proyecto ir a la carpeta "WindyUI" y luego a la carpeta "Charts" <br>
![paso4](Resources/Paso4.png)

5- Ejecutar el archivo install.sh con el siguiente comando: **bash install.sh** <br>
![paso5](Resources/Paso5.png)

-------------------------------

## **Componentes**

### **Countries/States CronJob**

El countries y states cronjobs consiste en dos componentes de tipo Cronjob que se ejecutan una vez al día. <br>
Estos estan compuestos por una **carpeta app**, ubicada en **WindyUI -> Docker -> CountriesCronjob**, o en caso de states, **StatesCronjob** que contiene:

* **app.py:** Consiste en un achivo python que se encarga de leer el archivo "ghcnd-countries.txt" de la página del NOA, mediante los modulos requests, ademas, se calcula el MD5 del archivo y se crea la conexión con MariaDB, cargando los países a la base de datos de WindyUI. <br>

![readCountries.py](Resources/readCountries.png)

* **requirements.txt:** Archivo que contiene los modulos necesarios para el .py. <br>

![requi.py](Resources/requ.png)

En el countries/states cronjob tambien se encuentra el **dockerfile** necesario para la creación de la imagen que será usada en el los objetos de cronjobs respectivos.<br>

![dockerFile.py](Resources/dockerFileCronjobs.png)

Tambien usan el template **countriesCronjob.yaml** (en caso de countries) o el template **statesCronjob.yaml** (en caso de states), estos estam ubicados en **WindyUI -> charts -> stateless -> template**, cada uno de estos archivos sigue la estructura de un cronjob.<br>

![dockerFile.py](Resources/cronjob.png)

Todo esto se conecta con la base de datos en **MariaDB** mediante el modulo **mysql.connector**, que se encarga de hacer una llamada a la funcion **"executeProcedure"**, que recibe el nombre del procedimiento a utilizar, más los parametros del procedimiento, en forma de lista de strings no con None en caso de tener datos NULL.

### **Station CronJob**

Es similar al anterior, consiste en un componente de tipo Cronjob que se ejecuta una vez al día. <br>

![stations.py](Resources/stat.png)

Estos estan compuestos por una **caperta app**, ubicada en **WindyUI -> Docker -> StationCronjob** que contiene: <br>

* **app.py:** Consiste en un achivo python que se encarga de leer el archivo "ghcnd-stations.txt" de la página del NOA, mediante los modulos requests, ademas, se calcula el MD5 del archivo y se crea la conexión con MariaDB, cargando las estaciones a la base de datos de WindyUI. <br>

<img src="Resources/readSta.png" alt="drawing" width="600"/>

* **requirements.txt:** Archivo que contiene los modulos necesarios para el .py. <br>

![requi.py](Resources/requ.png)

En el countries/states cronjob tambien se encuentra el **dockerfile** necesario para la creación de la imagen que será usada en el los objetos de cronjobs respectivos.<br>

![dockerFile.py](Resources/dockerFileCronjobs.png)

Tambien usan el template **countriesCronjob.yaml** (en caso de countries) o el template **statesCronjob.yaml** (en caso de states), estos están ubicados en **WindyUI -> charts -> stateless -> template**, cada uno de estos archivos sigue la estructura de un cronjob. <br>

De igual forma, se conecta con la base de datos en **MariaDB** mediante el modulo **mysql.connector**, que se encarga de hacer una llamada a la funcion **"executeProcedure"**, que recibe el nombre del procedimiento a utilizar, más los parametros del procedimiento, en forma de lista de strings no con None en caso de tener datos NULL.

### **Orchestrator CronJob**

Este es un componente tipo Cronjob, que se ejecuta una vez al día y se encarga de listar los archivos de la página **[www.ncei.noaa.gov](https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/)**.

Está estan compuestos por una **caperta app**, ubicada en **WindyUI/Docker/orchestratorCronjob** que contiene: <br>

![stations.py](Resources/orchestrator.png)

- **app.py:** este es un archivo Python que se conecta a la página del noaa y lista todos los archivos, se toma cada dirección que se encuentra y se manda un mensaje a la cola de rabbitmq llamada TO_PROCESS, y se agrega o actualiza la tabla weather.files con los datos del archivo. Todo lo que se utiliza en este .py se maneja por variables de entorno, como el nombre de la cola y los credenciales de rabbitmq.

<center>
<img src="Resources/orchestratorApp.png" alt="drawing" width="570"/>
</center>

- **requirements.txt:** Archivo que contiene los modulos necesarios para el .py.

![stations.py](Resources/orchestratorR.png)

Se usa el template llamado **orchestratorCronjob.yaml** que es de tipo cronjob, ubicado en la carpeta **WindyUI/charts/stateless/templates/**.

En la carpeta orchestratorCronjob se encuentra el dockerfile para la creación e la imagen y publicación a dockerhub, que será usada en los componentes cronjob.

![dockerFile.py](Resources/dockerFileCronjobs.png)

### **Processor**

Este es un componente de Kubernets tipo deployment que va a estar esperando trabajo de la cola TO_PROCESS de rabbitmq.
Lo que hace es tomar el mensaje de la cola y descargar el archivo, calcula el MD5 y se verifica por si existen datos nuevos. 
Se maneja un índice en Elasticsearch que guardará el nombre y el contenido de los nuevos archivos. 
También se tendrá otra cola de rabbitmq llamada TO_PROCESS en la que se enviarán mensajes al componente Parser.

Está compuesto por una **caperta app**, ubicada en **WindyUI/Docker/processorDeployment/** que contiene: <br>

![requi.py](Resources/processor.png)

- **app.py:** este es un archivo Python que va a recibir mensajes de la cola TO_PROCESS, en cada uno va a venir el enlace de descarga de un archivo. Se calcula el MD5 para saber si es igual o diferente, si es diferente se sube al índice de Elasticsearch y se actualiza el estado en la base de datos de mariadb. 
    - Finalmente se publica a la cola TO_PARSE el nombre del archivo para que este sea parseado.
  
<center>
<img src="Resources/processorPy.png" alt="drawing" width="570"/>
</center>

- **requirements.txt:** Archivo que contiene los modulos necesarios para el .py.

![stations.py](Resources/processorReq.png)

Se usa el template llamado **orchestratorCronjob.yaml** que es de tipo cronjob, ubicado en la carpeta **WindyUI/charts/stateless/templates/**.

En la carpeta orchestratorCronjob se encuentra el dockerfile para la creación e la imagen y publicación a dockerhub, que será usada en los componentes cronjob.

![dockerFile.py](Resources/dockerFileCronjobs.png)

### **Parser**

### **Otros**

* **Función excecuteProcedure**: Es una función que se encarga de hacer la conexión con la base de datos en MariaDB y ejecutar el proceso almacenado que recibe por parametros. Retorna un arreglo con los resultados que da la base de datos al cargar los datos. Si falla en hacer la conexion, retorna un arreglo con el string 'error'. <br>

<img src="Resources/executeP.png" alt="executeProcedurte" width="500"/>


* **Función getMD5**: Esta función se encarga de calcular el md5 de un archivo, este es usado para saber si el archivo ha sido modificado. Recibe un string con lo que contiene el archivo y retorna el calculo del MD5. <br>

![md5.py](Resources/md5.png)

* **Procedure loadFile:** Este procedure se encarga de verificar el md5 de los archivos, para saber si el archivo es totalmente nuevo y hay que crear un nuevo textFile, o si el md5 del archivo cambio y hay que actualizar los datos, o si el archivo sigue igual y no hay cambios en los datos. <br>

![loadF.py](Resources/loadFile.png)

* **Procedure readCountries:** Este procedure se encarga de descargar el archivo txt que contiene los datos (codigo de pais, nombre de pais) mediante la utilizacion de la libreria requests. Una vez descargado, calcula el md5 utilizando la funcion getMd5(). Luego, mediante la funcion executeProcedure() se ejecuta el proceso almacenado loadFile en MariaDB para revisar el md5 y guardar el archivo en la base de datos *weather*. Finalmente, si la conexion con la base de datos falla se retorna un string 'Conexion fallida', de lo contrario, dependiendo del resultado del proceso almacenado, se lee el archivo txt y se agregan los datos a la base de datos o simplemente no se modifica el archivo. Se retorna un string "El archivo se modifico" o "El archivo no se modifico".<br>

![loadF.py](Resources/readCountries.png)

* **Procedure readStates:** Este procedure se encarga de descargar el archivo txt que contiene los datos (codigo de estado, nombre de estado) mediante la utilizacion de la libreria requests. Una vez descargado, calcula el md5 utilizando la funcion getMd5(). Luego, mediante la funcion executeProcedure() se ejecuta el proceso almacenado loadFile en MariaDB para revisar el md5 y guardar el archivo en la base de datos *weather*. Finalmente, si la conexion con la base de datos falla se retorna un string 'Conexion fallida', de lo contrario, dependiendo del resultado del proceso almacenado, se lee el archivo txt y se agregan los datos a la base de datos o simplemente no se modifica el archivo. Se retorna un string "El archivo se modifico" o "El archivo no se modifico".<br>

![loadF.py](Resources/readStates.png)

* **Procedure readStations:** Este procedure se encarga de descargar el archivo txt que contiene los datos (id, codigo de pais, latitud, longitud, elevacion, estado, nombre, gsn, hcn, wmo) mediante la utilizacion de la libreria requests. Una vez descargado, calcula el md5 utilizando la funcion getMd5(). Luego, mediante la funcion executeProcedure() se ejecuta el proceso almacenado loadFile en MariaDB para revisar el md5 y guardar el archivo en la base de datos *weather*. Finalmente, si la conexion con la base de datos falla se retorna un string 'Conexion fallida', de lo contrario, dependiendo del resultado del proceso almacenado, se lee el archivo txt y se agregan los datos a la base de datos o simplemente no se modifica el archivo. Se retorna un string "El archivo se modifico" o "El archivo no se modifico".<br>

<center>
<img src="Resources/readStations.png" alt="readStations" width="500"/>
</center>

* **Función processorJson** Esta es una función que se encarga de recibir la información de los archivos publicados en la cola to_process y transformaro al formato Json necesario, donde se colocan tanto el nombre del archivo como sus contenidos. 

<center>
<img src="Resources/processorJson.png" alt="processorJson" width="500"/>
</center>

* **Función parserJson** Esta es una función que se encarga de transformar la información de cada set de datos extraídos del archivo y convertirlos en formato Json para luego ser publicados en la cola to_transform. En esta se recibe la información del station_id, date, type, value, mflag, qflag y sflag. Después de recibir esa información se crea un solo json que tiene el nombre del archivo y luego la lista de datos.   

<center>
<img src="Resources/parserJson.png" alt="parserJson" width="500"/>
</center>

* **Función transformationJson** Esta es una función que recibe un archivo json proveniente de la cola to_transform que tiene el formato producido por la función parserJson. El objetivo de esta función es obtener más información a partir del json recibido fragmentando la fecha, el station_id y agregando el nombre del type. En este método se utiliza un diccionario que incluye los tipos indicados en la especificación del proyecto. De ese diccionario se extrae el nombre completo que se relaciona al acrónimo presente en el atributo type de cada json. Además se extrae de la fecha el mes y el año de los datos y luego se extrae del station_id el código de país, el código de network y el idetificador de estación real. 

<center>
Este es el diccionario de tipos:
<img src="Resources/typesDictionary.png" alt="typesDictionary" width="500"/>

Función transformationJson:


<img src="Resources/transformationJson.png" alt="transformationJson" width="500"/>
</center>

-------------------------------

## **Pruebas**

### **Prueba de Station CronJob**

Es esta prueba se verifica que la conexión de la base de datos se haga correctamente.

![pruebaUnitaria1.py](Resources/pruebaUnitaria2.png)

### **Prueba de Countries/States CronJob**

Es esta prueba se verifica que la conexión de la base de datos se haga correctamente.

![pruebaUnitaria2.py](Resources/pruebaUnitaria3.png)

### **Prueba de Orchestrator CronJob**

<center>
<img src="Resources/UTorchestrator.png" alt="unitTestStates" />
</center>

### **Prueba de Processor**

### **Prueba de Parser**

-------------------------------

## **Resultados de pruebas unitarias**

### **Prueba de Station CronJob**

<center>
<img src="Resources/PUStations.png" alt="unitTestStates" />
</center>

### **Prueba de Countries/States CronJob**

<center>
<img src="Resources/PUCountries.png" alt="unitTestStates" />
</center>

#### States
Cuando la conexión con la base datos falla, la imagen no se crea.

<center>
<img src="Resources/PUStatesFailed.png" alt="unitTestStates" />
</center>

### **Prueba de Orchestrator CronJob**

<center>
<img src="Resources/PUOrchestrator.png" alt="unitTestStates" />
</center>

### **Prueba de Processor**

### **Prueba de Parser**

-------------------------------

## **Recomendaciones**

1- Empezar por lo primero, no apresurarse y empezar con partes del proyecto que estan más avanzadas. <br>
2- Repartir y asignar tareas a cada integrante del equipo para progresar. <br>
3- Investigar los conceptos esenciales para desarrollar la solución. <br>
4- Tener un buen conocimiento de como se utilizan las herramientas necesarias para el desarrollo del proyecto. <br>
5- Utilizar un buen control de versiones y tener un buen manejo de github. <br>
6- Tener una buena estructura del proyecto y dividir el proyecto de forma funcional. <br>
7- Implementar buenas prácticas de programación. <br>
8- Tener una buena comunicación con el equipo de trabajo. <br>
9- Realizar pruebas. <br>
10- Seguir aprendiendo y enriqueciendo el conocimiento después de finalizar el proyecto. <br>

-------------------------------

## **Conclusiones**

1- La organización es importante para poder llevar a cabo el proyecto. <br>
2- El trabajo en equipo es esencial para llevar finalizar el proyecto. <br>
3- El conocimiento de conceptos básicos es sustancial para entender los pasos que hay que realizar al desarrollar el proyecto. <br>
4- El tener un buen entendimiento del funcionamiento de las herramientas que se van a necesitar facilita el avance del desarrollo de la solución. <br>
5- El tener un buen control de versiones y saber utilizar github facilita el trabajo en equipo y es una buena práctica. <br>
6- El tener una buena organización y estructura del proyecto es importante para tener un mayor orden, y por ende, facilitar el trabajo. <br>
7- El utilizar buenas prácticas de programación asegura que el código sea legible y entendible para continuar su desarrollo en un futuro de forma eficaz. <br>
8- El tener una buena comunicación tiene como resultado un proyecto de calidad y organizado que avanza progresivamente. <br>
9- Es importante la realización de pruebas para garantizar el buen funcionamiento del programa. <br>
10- Para reforzar habilidades y mejorar de forma continua, es importante continuar la investigación de los temas que se estudiaron. <br>

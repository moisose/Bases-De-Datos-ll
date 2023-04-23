## **Instituto Tecnológico de Costa Rica**

## **IC4302 - Bases de Datos II**

## **Documentación Proyecto 1**

### **Profesor**: Nereo Campos Araya

### **Estudiantes**:

- Fiorella Zelaya Coto - 2021453615
- Isaac Araya Solano - 2018151703
- Melany Salas Fernández - 2021121147
- Moisés Solano Espinoza - 2021144322
- Pablo Arias Navarro - 2021024635

# **Diagrama entidad-relación**

<center>
    <img src="Resources/name.png" alt="Diagrama Entidad Relación" />
</center>

# **Enlace a proyecto Thunkable**

[Proyecto Thunkable](https://x.thunkable.com/copy/89e0768b7d57e9aedc6183c58bf2d7b4)

# **Instrucciones de ejecución**

1-

2-

3-

# **Pruebas realizadas**

# **Resultados de pruebas unitarias**

# **Componentes**

## **APIS**

## **Firebase**

Firebase se utiliza para la autenticación de los usuarios que se crean desde el proyecto Thunkable, se hace mediante correo electrónico y password.
<center>
    <img src="Resources/firebaseAut.png" alt="Firebase" />
</center>

## **NodeJS**

## **Thunkable**

### **Log In Screen**

En la pantalla  de inicio de sesión el usuario debe ingresar el email y el password que se encuentra reguistrado en firebase.

<center>
    <img src="Resources/LogInScreen.png" alt="Log In Screen" />
</center>

<center>
    <img src="Resources/logInF.png" alt="Log In Screen" />
</center>

Se hace uso de la función **firebase sign in** de thunkable, haciendo uso del email y el password ingresado por el usuario mediante text inputs, firebase retorna error en caso de que alguno de los datos este incorrecto y se hace el despliegue de una alerta al usuario, donde se coloca el mesaje de error.

Hce uso de variables stored para guardar el userid, email y password en caso de que necesiten usarse en otras partes de la applicación.

Cuando la ventaja se va a cerrar para dirigirse al homeScreen, se "limpian" los campos y se abre la nueva ventana.

<center>
    <img src="Resources/alertSignIn.png" alt="Alert Sign In Screen" />
</center>

La función para llamar alertas recibe el mensaje y le muestra lo sigiente al usuario:

<center>
    <img src="Resources/errorSignIn.png" alt="Alert Sign In Screen" />
</center>

El mensaje va a variar de acuerdo al error.

<center>
    <img src="Resources/signInOtrasFunciones.png" alt="Alert Sign In Screen" />
</center>

También, el resto de botones tienen otros bloques de código para registrarse a la app o hacer la recupeción de la contraseña.

### **Sign In Screen**

<center>
    <img src="Resources/SignUpScreen.png" alt="Sign In Screen" />
</center>

### **Home Screen**

### **Enroll Screen**

### **Check Enrollment Date Screen**

### **Enrolled Courses Screen**

### **Reset Password Screen**

<center>
    <img src="Resources/resetPasswordScreen.png" alt="Reset Password Screen" />
</center>

# **Conclusiones**

**1-** La comunicación entre el los miembros de grupo de trabajo es fundamental para un buen desarrollo del proyecto.

**2-** Se debe mantener una buena organización para poder realizar el trabajo.

**3-** Es de gran importancia entender los conceptos básicos vistos en clase para realizar el proyecto.

**4-** El tener un buen control de versiones y la correcta utilización de github facilita el trabajo en equipo.

**5-** Se deben aplicar buenas prácticas de programación para mantener el orden.

**6-** Mantener la estructura definida del proyecto es esencial para evitar el desorden.

**7-** Se debe desarollar un código legible y entendible.

# **Recomendaciones**

**1-** Hacer reuniones periódicas para discutir los avances del proyecto y mejorar la comunicación.

**2-** Mantener la organización de la tarea, siguiendo la infraestructura y recomendaciones dadas por el profesor.

**3-** Repasar los conceptos vistos en clase y complementar con investigación mejorar el entendimiento y aumentar la eficacia con la que se trabajará.

**4-** Aprender a hacer uso de github para el control de versiones y trabajo en conjunto.

**5-** Seguir un estándar de código.

**6-** Seguir aprendiendo y enriqueciendo el conocimiento después de finalizar el trabajo.

**7-** Investigar sobre las diferentes herramientas esenciales para desarrollar la solución e ir tomando apuntes sobre los aspectos importantes de cada uno de estas. Esto facilitará el desarrollo de la solución.

**8-** Tener una buena estructura del proyecto y dividir el proyecto de forma funcional para avanzar progresivamente.

**9-** Repartir y asignar tareas a cada integrante del equipo.

**10-** Definir roles en el equipo de trabajo para mantener el orden y procurar buena dinámica de trabajo.

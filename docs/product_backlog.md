title,body,labels
"US1.1: Registro de Usuarios","**Como** cocinero nuevo, **quiero** crear una cuenta con mi correo y contraseña, **para** acceder a las funciones de creación de recetas.

### Criterios de Aceptación:
- [ ] Formulario con campos: Nombre, Correo y Contraseña (con confirmación).
- [ ] Validar que el correo no esté registrado previamente.
- [ ] Contraseña encriptada en base de datos.
- [ ] Redirigir al Login tras un registro exitoso.","epic:autenticacion,prioridad:alta"
"US1.2: Inicio y Cierre de Sesión","**Como** usuario registrado, **quiero** iniciar y cerrar sesión con mis credenciales, **para** proteger y administrar mis platillos guardados.

### Criterios de Aceptación:
- [ ] Formulario con campos: Correo y Contraseña.
- [ ] Mostrar mensaje de error si las credenciales son incorrectas.
- [ ] Mantener la sesión activa mediante tokens/cookies.
- [ ] Botón visible de 'Cerrar sesión' que destruya la sesión actual.","epic:autenticacion,prioridad:alta"
"US2.1: Crear un Platillo (Create)","**Como** chef autenticado, **quiero** registrar un nuevo platillo con su nombre, categoría y descripción, **para** que forme parte del catálogo general.

### Criterios de Aceptación:
- [ ] Formulario con campos obligatorios: Nombre del platillo, Descripción, Categoría (Entrada, Fuerte, Postre).
- [ ] Permitir subir o enlazar una URL de imagen del platillo (opcional).","epic:crud-platillos,prioridad:alta"
"US2.2: Visualizar Platillos (Read)","**Como** usuario de la plataforma, **quiero** ver una lista de todos los platillos registrados, **para** explorar las opciones disponibles.

### Criterios de Aceptación:
- [ ] Vista de catálogo tipo 'tarjetas' (cards) con foto, nombre y descripción corta.
- [ ] Vista de detalle: Al hacer clic en un platillo, se abre una página dedicada con toda su información.","epic:crud-platillos,prioridad:alta"
"US2.3: Modificar un Platillo (Update)","**Como** creador del platillo, **quiero** editar los datos de un platillo existente, **para** corregir errores o actualizar su información.

### Criterios de Aceptación:
- [ ] Botón 'Editar' visible únicamente para el usuario dueño del platillo o administrador.
- [ ] Formulario precargado con los datos actuales del platillo.","epic:crud-platillos,prioridad:media"
"US2.4: Eliminar un Platillo (Delete)","**Como** creador del platillo, **quiero** borrar un platillo del sistema, **para** quitar del catálogo platos que ya no se preparan.

### Criterios de Aceptación:
- [ ] Botón 'Eliminar' protegido.
- [ ] Alerta de confirmación intermedia ('¿Estás seguro?') para evitar borrados accidentales.","epic:crud-platillos,prioridad:baja"
"US3.1: Añadir Receta Avanzada a un Platillo","**Como** chef o cocinero, **quiero** desglosar los ingredientes y pasos de preparación dentro de un platillo, **para** que otros usuarios puedan replicar el plato con exactitud.

### Criterios de Aceptación:
- [ ] La sección de 'Receta' se asocia directamente al ID de un Platillo existente.
- [ ] Permite añadir ingredientes de forma dinámica (cantidad, unidad y nombre).
- [ ] Lista numerada de pasos para el procedimiento.","epic:recetas,prioridad:alta"

# Product Backlog - El Culinario

## US1.1: Registro de Usuarios
**Como** cocinero nuevo, **quiero** crear una cuenta con mi correo y contraseña, **para** acceder a las funciones de creación de recetas.

### Descripción Detallada
El usuario debe poder registrarse de forma rápida y segura. El sistema validará la información para evitar duplicados y asegurar contraseñas fuertes.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Registro exitoso con información válida**
```gherkin
Dado que estoy en la página de registro
Y no tengo una cuenta en la plataforma
Cuando completo el formulario con:
  | Campo         | Valor                        |
  | Nombre        | Juan Pérez                   |
  | Correo        | juan@example.com             |
  | Contraseña    | SecurePass123!               |
  | Confirmación  | SecurePass123!               |
Y acepto los términos y condiciones
Y completo el CAPTCHA
Y hago clic en "Registrarse"
Entonces el sistema valida que el correo no esté registrado
Y encripta la contraseña con bcrypt
Y envía un email de confirmación
Y redirige a la página de login
Y muestro el mensaje "Cuenta creada. Revisa tu email para confirmar"
```

**Escenario 2: Rechazo por duplicado**
```gherkin
Dado que existe una cuenta con correo juan@example.com
Y estoy en la página de registro
Cuando completo el formulario con correo juan@example.com
Y hago clic en "Registrarse"
Entonces el sistema rechaza el registro
Y muestra error: "Este correo ya está registrado"
```

**Escenario 3: Rechazo por contraseña débil**
```gherkin
Dado que estoy en la página de registro
Cuando intento registrarme con contraseña "123456"
Entonces el sistema valida la fortaleza
Y rechaza la contraseña
Y muestra error: "La contraseña debe tener mínimo 8 caracteres, mayúsculas, números y símbolos"
```

**Escenario 4: Rechazo por confirmación de contraseña incorrecta**
```gherkin
Dado que completo el formulario
Cuando ingreso contraseña "SecurePass123!" y confirmación "OtherPass123!"
Y hago clic en "Registrarse"
Entonces el sistema detecta que las contraseñas no coinciden
Y muestra error: "Las contraseñas no coinciden"
```

**Escenario 5: Bloqueo de bots con CAPTCHA**
```gherkin
Dado que estoy en la página de registro
Cuando intento registrarme sin completar el CAPTCHA
Y hago clic en "Registrarse"
Entonces el sistema rechaza el envío
Y muestra error: "Debes completar el CAPTCHA"
```

---

## US1.2: Inicio y Cierre de Sesión
**Como** usuario registrado, **quiero** iniciar y cerrar sesión con mis credenciales, **para** proteger y administrar mis platillos guardados.

### Descripción Detallada
El usuario autenticado accede a la plataforma de forma segura. Las sesiones se mantienen activas y pueden ser cerradas en cualquier momento.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Inicio de sesión exitoso**
```gherkin
Dado que estoy en la página de login
Y tengo una cuenta con correo usuario@example.com y contraseña SecurePass123!
Cuando ingreso el correo usuario@example.com
Y ingreso la contraseña SecurePass123!
Y hago clic en "Iniciar sesión"
Entonces el sistema valida las credenciales
Y genera un token JWT con expiración de 24 horas
Y genera un refresh token con expiración de 7 días
Y almacena las cookies con flags HttpOnly, Secure y SameSite
Y redirige al dashboard del usuario
Y muestra el mensaje "Sesión iniciada correctamente"
```

**Escenario 2: Rechazo por credenciales incorrectas**
```gherkin
Dado que estoy en la página de login
Cuando ingreso un correo o contraseña incorrecta
Y hago clic en "Iniciar sesión"
Entonces el sistema rechaza la solicitud
Y muestra error: "Correo o contraseña incorrectos"
Y registra el intento fallido
```

**Escenario 3: Bloqueo por intentos fallidos**
```gherkin
Dado que ingreso credenciales incorrectas 5 veces
Cuando intento iniciar sesión nuevamente
Entonces el sistema bloquea la cuenta temporalmente
Y muestra error: "Cuenta bloqueada por seguridad. Intenta en 15 minutos"
```

**Escenario 4: Cerrar sesión exitosamente**
```gherkin
Dado que tengo una sesión activa
Cuando hago clic en "Cerrar sesión"
Entonces el sistema destruye el token JWT
Y elimina las cookies de sesión
Y invalida el refresh token
Y redirige a la página de login
Y muestra el mensaje "Sesión cerrada correctamente"
```

**Escenario 5: Opción "Recuérdame"**
```gherkin
Dado que estoy en la página de login
Cuando marco la opción "Recuérdame por 30 días"
Y completo el login exitosamente
Entonces el sistema genera una cookie persistente
Y la sesión se mantiene activa por 30 días
Y al volver a la plataforma, no necesito ingresar credenciales
```

**Escenario 6: Timeout de sesión por inactividad**
```gherkin
Dado que tengo una sesión activa
Cuando permanezco inactivo por 20 minutos
Entonces el sistema invalida la sesión automáticamente
Y redirige a la página de login
Y muestra mensaje: "Tu sesión expiró por inactividad"
```

**Escenario 7: Notificación de sesión en nuevo dispositivo**
```gherkin
Dado que tengo una cuenta registrada
Y mi última sesión fue en un Mac con IP 192.168.1.1
Cuando inicio sesión desde Windows con IP 192.168.2.5
Entonces el sistema detecta un nuevo dispositivo
Y envía notificación por email: "Se inició sesión en tu cuenta desde un nuevo dispositivo"
Y muestra la IP, navegador y ubicación aproximada
```

---

## US1.2.1: Recuperación de Contraseña
**Como** usuario, **quiero** recuperar acceso a mi cuenta si olvido mi contraseña, **para** continuar usando la plataforma.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Solicitud de recuperación exitosa**
```gherkin
Dado que estoy en la página de login
Cuando hago clic en "¿Olvidaste tu contraseña?"
Y ingreso mi correo usuario@example.com
Y hago clic en "Enviar enlace de recuperación"
Entonces el sistema genera un token de reseteo único
Y envía un email a usuario@example.com con enlace válido por 1 hora
Y muestra mensaje: "Revisa tu email para continuar"
```

**Escenario 2: Rechazo por correo no registrado**
```gherkin
Dado que estoy en la página de recuperación
Cuando ingreso correo inexistente@example.com
Y hago clic en "Enviar enlace de recuperación"
Entonces el sistema no encuentra la cuenta
Y muestra mensaje: "Si existe una cuenta con este correo, recibirás un email"
```

**Escenario 3: Cambio de contraseña con nueva contraseña válida**
```gherkin
Dado que recibí email de recuperación con enlace válido
Y hago clic en el enlace
Y accedo al formulario de cambio de contraseña
Cuando ingreso nueva contraseña "NewSecure456!"
Y confirmo la contraseña "NewSecure456!"
Y hago clic en "Cambiar contraseña"
Entonces el sistema valida que cumpla requisitos de seguridad
Y encripta la nueva contraseña con bcrypt
Y actualiza la contraseña en la base de datos
Y invalida todos los tokens JWT activos
Y redirige a login
Y muestra mensaje: "Contraseña cambiada exitosamente"
```

**Escenario 4: Rechazo por contraseña débil en recuperación**
```gherkin
Dado que estoy en el formulario de cambio de contraseña
Cuando ingreso contraseña débil "123456"
Y hago clic en "Cambiar contraseña"
Entonces el sistema valida la fortaleza
Y rechaza el cambio
Y muestra error: "La contraseña debe tener mínimo 8 caracteres, mayúsculas, números y símbolos"
```

**Escenario 5: Enlace de recuperación expirado**
```gherkin
Dado que el enlace de recuperación fue enviado hace 2 horas
Cuando intento acceder al formulario de cambio
Entonces el sistema detecta que el token expiró
Y redirige a la página de login
Y muestra error: "El enlace de recuperación expiró. Solicita uno nuevo"
```

**Escenario 6: Confirmación de cambio por email**
```gherkin
Dado que cambié mi contraseña exitosamente
Entonces el sistema envía email de confirmación
Y el email contiene IP, navegador y fecha del cambio
Y incluye enlace para reportar cambio no autorizado
```

---

## US2.1: Crear un Platillo (Create)
**Como** chef autenticado, **quiero** registrar un nuevo platillo con su nombre, categoría y descripción, **para** que forme parte del catálogo general.

### Descripción Detallada
La creación de platillos es el corazón de la plataforma. Permite a los chefs compartir sus creaciones con metadatos completos.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Crear platillo con todos los datos requeridos**
```gherkin
Dado que soy un chef autenticado
Y estoy en la página "Crear nuevo platillo"
Cuando completo el formulario con:
  | Campo                   | Valor                                  |
  | Nombre                  | Tacos al Pastor                        |
  | Descripción             | Tacos tradicionales con marinada...    |
  | Categoría               | Entrada                                |
  | Dificultad              | Media                                  |
  | Tiempo de preparación   | 45                                     |
  | Número de porciones     | 4                                      |
  | Ingredientes principales| Carne de cerdo, piña, cebolla         |
Y subo una imagen en formato JPG
Y acepto los términos
Y hago clic en "Crear platillo"
Entonces el sistema valida todos los campos
Y comprime y optimiza la imagen
Y la carga en CDN
Y genera un slug único para la URL
Y registra timestamp de creación
Y asocia el platillo al usuario autenticado
Y muestra mensaje: "Platillo creado exitosamente"
Y ofrece opción "Añadir receta ahora"
Y redirige a la página de detalle del platillo
```

**Escenario 2: Rechazo por campos obligatorios faltantes**
```gherkin
Dado que estoy en la página "Crear nuevo platillo"
Cuando intento crear un platillo sin llenar el campo "Nombre"
Y hago clic en "Crear platillo"
Entonces el sistema valida los campos
Y muestra error: "El nombre del platillo es obligatorio"
Y no crea el platillo
```

**Escenario 3: Rechazo por imagen inválida**
```gherkin
Dado que estoy creando un platillo
Cuando intento subir un archivo de imagen mayor a 5MB
O en formato no soportado (BMP, TIFF, etc.)
Y hago clic en "Crear platillo"
Entonces el sistema rechaza la imagen
Y muestra error: "Formato inválido. Usa JPG, PNG o WebP. Máximo 5MB"
```

**Escenario 4: Platillo sin imagen (opcional)**
```gherkin
Dado que estoy en la página "Crear nuevo platillo"
Cuando completo todos los campos requeridos
Y NO subo una imagen
Y hago clic en "Crear platillo"
Entonces el sistema acepta la creación
Y asigna imagen por defecto (placeholder)
Y crea el platillo exitosamente
```

**Escenario 5: Máximo 5 ingredientes principales**
```gherkin
Dado que estoy creando un platillo
Cuando intento añadir más de 5 ingredientes principales
Entonces el sistema deshabilita el campo "Agregar ingrediente"
Y muestra aviso: "Máximo 5 ingredientes principales"
```

---

## US2.2: Visualizar Platillos (Read)
**Como** usuario de la plataforma, **quiero** ver una lista de todos los platillos registrados, **para** explorar las opciones disponibles.

### Descripción Detallada
Una vista galería intuitiva con búsqueda y filtrado para descubrir platillos de forma efectiva.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Ver catálogo de platillos**
```gherkin
Dado que accedo a la página de catálogo
Cuando carga la página
Entonces veo 12 platillos por página en formato de tarjetas
Y cada tarjeta muestra: foto, nombre, categoría, descripción corta
Y veo botones de navegación: Anterior, Siguiente, números de página
```

**Escenario 2: Filtrar por categoría**
```gherkin
Dado que estoy en el catálogo
Cuando selecciono la categoría "Postre"
Y hago clic en "Filtrar"
Entonces el sistema filtra los platillos
Y muestra solo postres
Y actualiza el contador: "Mostrando X de Y platillos"
```

**Escenario 3: Filtrar por dificultad**
```gherkin
Dado que estoy en el catálogo
Cuando selecciono dificultad "Fácil"
Entonces el sistema filtra por dificultad
Y muestra solo platillos categorizados como "Fácil"
```

**Escenario 4: Filtrar por tiempo de preparación**
```gherkin
Dado que estoy en el catálogo
Cuando selecciono rango de tiempo "15-30 minutos"
Entonces el sistema filtra platillos con tiempo estimado en ese rango
Y muestra solo los coincidentes
```

**Escenario 5: Buscar por nombre o ingredientes**
```gherkin
Dado que estoy en el catálogo
Cuando escribo "pollo" en el buscador
Y presiono Enter o hago clic en "Buscar"
Entonces el sistema busca en nombres e ingredientes
Y muestra platillos que contienen "pollo"
Y resalta las coincidencias
```

**Escenario 6: Ordenar platillos**
```gherkin
Dado que estoy en el catálogo
Cuando selecciono ordenamiento "Más populares"
Entonces el sistema ordena por número de visualizaciones
Y muestra los platillos más vistos primero
```

**Escenario 7: Ver detalle del platillo**
```gherkin
Dado que veo una tarjeta de platillo
Cuando hago clic en ella
Entonces se abre página dedicada mostrando:
  | Información         |
  | Nombre              |
  | Foto grande         |
  | Descripción completa|
  | Ingredientes        |
  | Dificultad          |
  | Tiempo de prep      |
  | Porciones           |
  | Notas dietéticas    |
  | Autor y fecha       |
  | Contador de vistas  |
Y muestro botón "Ver receta" si existe
```

**Escenario 8: Contador de visualizaciones**
```gherkin
Dado que veo la página de detalle de un platillo
Entonces puedo ver el contador: "1,234 personas lo han visto"
Y cada nueva visualización incrementa el contador
```

---

## US2.3: Modificar un Platillo (Update)
**Como** creador del platillo, **quiero** editar los datos de un platillo existente, **para** corregir errores o actualizar su información.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Editar platillo como propietario**
```gherkin
Dado que soy el creador del platillo "Tacos al Pastor"
Cuando veo la página de detalle
Entonces veo un botón "Editar" visible
Y cuando hago clic en "Editar"
Se abre el formulario precargado con datos actuales
Y puedo modificar: nombre, descripción, categoría, imagen, etc.
Y hago clic en "Guardar cambios"
Entonces el sistema valida los cambios
Y registra en auditoría: quién, cuándo y qué cambió
Y muestra mensaje: "Platillo actualizado exitosamente"
```

**Escenario 2: Botón editar oculto para otros usuarios**
```gherkin
Dado que veo un platillo creado por otro usuario
Entonces NO veo el botón "Editar"
Y si intento acceder a la URL de edición directamente
Entonces el sistema rechaza con error: "No tienes permisos para editar"
```

**Escenario 3: Ver historial de versiones**
```gherkin
Dado que estoy editando mi platillo
Cuando hago clic en "Ver historial"
Entonces veo lista de versiones anteriores con:
  | Información          |
  | Versión número       |
  | Fecha de cambio      |
  | Usuario que editó    |
  | Resumen de cambios   |
```

**Escenario 4: Restaurar versión anterior**
```gherkin
Dado que veo el historial de versiones
Cuando hago clic en "Restaurar" en una versión anterior
Entonces el sistema muestra confirmación: "¿Restaurar esta versión?"
Y si confirmo
Entonces se restaura esa versión
Y se registra como nueva edición en auditoría
Y muestra mensaje: "Versión restaurada exitosamente"
```

**Escenario 5: Validación de cambios antes de guardar**
```gherkin
Dado que estoy editando un platillo
Cuando intento guardar sin nombre
Entonces el sistema valida campos obligatorios
Y muestra error: "Nombre del platillo es obligatorio"
Y no guarda los cambios
```

**Escenario 6: Notificación a seguidores**
```gherkin
Dado que edito un platillo que tiene 10 seguidores
Cuando guardo los cambios exitosamente
Entonces el sistema notifica a los seguidores
Y cada uno recibe notificación: "El platillo 'Tacos al Pastor' fue actualizado"
```

---

## US2.4: Eliminar un Platillo (Delete)
**Como** creador del platillo, **quiero** borrar un platillo del sistema, **para** quitar del catálogo platos que ya no se preparan.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Borrado temporal (soft delete)**
```gherkin
Dado que soy el creador del platillo "Ceviche"
Y veo la página de detalle
Cuando hago clic en "Eliminar"
Entonces el sistema muestra confirmación: "¿Estás seguro de que deseas eliminar este platillo?"
Y si confirmo
Entonces el platillo se marca como soft-deleted
Y desaparece del catálogo
Y se envía email de confirmación
Y se registra en auditoría
Y muestra mensaje: "Platillo eliminado. Será eliminado permanentemente en 30 días"
```

**Escenario 2: Botón eliminar oculto para otros usuarios**
```gherkin
Dado que veo un platillo creado por otro usuario
Entonces NO veo el botón "Eliminar"
Y si intento acceder a la URL de eliminación directamente
Entonces el sistema rechaza con error: "No tienes permisos"
```

**Escenario 3: Restaurar platillo dentro del período de gracia**
```gherkin
Dado que eliminé un platillo hace 5 días
Y accedo a mi perfil -> "Platillos eliminados"
Cuando hago clic en "Restaurar"
Entonces el sistema reactiva el platillo
Y vuelve a aparecer en el catálogo
Y muestra mensaje: "Platillo restaurado exitosamente"
```

**Escenario 4: Borrado permanente después de 30 días**
```gherkin
Dado que un platillo fue soft-deleted hace 30 días o más
Cuando se ejecuta el job de limpieza
Entonces el sistema elimina permanentemente del storage
Y archive los datos (backup de seguridad)
Y registra en auditoría log: "Hard delete ejecutado"
```

**Escenario 5: Notificar a seguidores sobre eliminación**
```gherkin
Dado que elimino un platillo que tiene 5 seguidores
Entonces cada seguidor recibe notificación:
  | Contenido                                           |
  | "El platillo 'Ceviche' ha sido eliminado"         |
  | "Fue eliminado por: [nombre del creador]"         |
  | "Será permanentemente borrado en 30 días"         |
  | "¿Te gustaría ver otras opciones similares?"      |
```

**Escenario 6: Cascada de eliminación de recetas**
```gherkin
Dado que elimino un platillo que tiene 3 recetas asociadas
Entonces el sistema marca todas las recetas como soft-deleted
Y notifica a usuarios que han guardado esas recetas
Y mantiene los datos de auditoría
```

---

## US3.1: Añadir Receta Avanzada a un Platillo
**Como** chef o cocinero, **quiero** desglosar los ingredientes y pasos de preparación dentro de un platillo, **para** que otros usuarios puedan replicar el dish.

### Descripción Detallada
Las recetas son el complemento detallado de cada platillo. Permiten instrucciones paso a paso con ingredientes precisos.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Crear receta para platillo existente**
```gherkin
Dado que soy chef autenticado
Y tengo un platillo "Tacos al Pastor" creado
Cuando voy a la página del platillo
Y hago clic en "Añadir receta"
Y accedo al formulario de receta
Entonces puedo:
  1. Asociar la receta al platillo (pre-seleccionado)
  2. Agregar ingredientes dinámicamente
  3. Agregar pasos numerados
  4. Agregar consejos del chef
  5. Guardar como borrador o publicar
```

**Escenario 2: Agregar ingredientes con validación**
```gherkin
Dado que estoy en el formulario de receta
Cuando hago clic en "Agregar ingrediente"
Entonces aparece campo con:
  | Campo      | Tipo        |
  | Cantidad   | Número      |
  | Unidad     | Dropdown    |
  | Ingrediente| Autocomplete|
Y cuando escribo "ce" en ingrediente
Entonces se sugieren: "Cebolla", "Cerdo", "Célula..."
Y puedo seleccionar o escribir uno nuevo
```

**Escenario 3: Notas especiales por ingrediente**
```gherkin
Dado que añado un ingrediente "Cebolla"
Cuando hago clic en "Agregar nota"
Entonces puedo escribir: "Cortada en juliana fina"
Y la nota se asocia al ingrediente
Y aparece en la receta final
```

**Escenario 4: Crear pasos con editor rico**
```gherkin
Dado que estoy en la sección de "Pasos"
Cuando hago clic en "Agregar paso"
Entonces aparece editor con opciones:
  | Opción          |
  | Texto plano     |
  | Negrita         |
  | Listas          |
  | Subir imagen    |
  | Tiempo estimado |
Y puedo escribir: "**Marinada:** Mezcla carne con..."
Y subo una imagen del paso
Y especifico tiempo: 30 minutos
```

**Escenario 5: Máximo 20 pasos en receta**
```gherkin
Dado que tengo 20 pasos en mi receta
Cuando intento agregar el paso 21
Entonces el botón "Agregar paso" se deshabilita
Y muestra aviso: "Máximo 20 pasos permitidos"
```

**Escenario 6: Guardar como borrador**
```gherkin
Dado que estoy creando una receta
Cuando hago clic en "Guardar como borrador"
Entonces la receta se guarda sin publicar
Y aparece en mi perfil como "Borrador"
Y puedo continuarla después
Y muestra mensaje: "Receta guardada como borrador"
```

**Escenario 7: Publicar receta**
```gherkin
Dado que tengo una receta completada
Cuando hago clic en "Publicar"
Entonces el sistema valida que tenga:
  - Mínimo 1 ingrediente
  - Mínimo 1 paso
  - Descripción o título
Y si cumple, la publica
Y aparece en el catálogo de recetas
Y notifica a seguidores del platillo
Y muestra mensaje: "¡Receta publicada exitosamente!"
```

**Escenario 8: Visualización de receta imprimible**
```gherkin
Dado que tengo una receta publicada
Cuando hago clic en "Imprimir"
Entonces se abre vista imprimible con:
  - Título y descripción
  - Tabla de ingredientes (sin decoraciones)
  - Pasos numerados con fuente clara
  - Logo del chef (opcional)
Y puedo imprimir a PDF o papel
```

---

## US3.2: Editar y Versioning de Recetas
**Como** chef, **quiero** editar recetas existentes y ver el historial de cambios, **para** mejorar las instrucciones continuamente.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Editar receta como propietario**
```gherkin
Dado que soy el creador de la receta "Tacos al Pastor"
Cuando voy a su página
Entonces veo botón "Editar receta"
Y cuando hago clic
Se abre el formulario precargado
Y puedo modificar ingredientes, pasos, tips
Y hago clic en "Guardar cambios"
Entonces el sistema:
  - Valida que mínimo tenga 1 ingrediente y 1 paso
  - Crea nueva versión con timestamp
  - Registra cambios en historial
  - Notifica a usuarios que la guardan/comentan
  - Muestra mensaje: "Receta actualizada"
```

**Escenario 2: Ver historial de versiones**
```gherkin
Dado que estoy en página de receta
Cuando hago clic en "Historial de versiones"
Entonces veo lista con:
  | Campo              |
  | Versión #          |
  | Fecha de cambio    |
  | Usuario que editó  |
  | Resumen de cambios |
```

**Escenario 3: Comparar dos versiones**
```gherkin
Dado que veo el historial
Cuando selecciono "Versión 1" y "Versión 3"
Y hago clic en "Comparar"
Entonces veo view con:
  - Cambios resaltados en verde (añadido)
  - Cambios resaltados en rojo (removido)
  - Cambios resaltados en amarillo (modificado)
```

**Escenario 4: Restaurar versión anterior**
```gherkin
Dado que veo versión anterior en historial
Cuando hago clic en "Restaurar esta versión"
Entonces el sistema pide confirmación
Y si confirmo:
  - Se restaura esa versión exacta
  - Se crea como nueva versión actual
  - Se registra en auditoría: quién, cuándo, restauró qué
  - Se notifica a seguidores
  - Muestra mensaje: "Versión restaurada exitosamente"
```

**Escenario 5: Notificación de cambios a seguidores**
```gherkin
Dado que publico cambios en receta con 15 seguidores
Entonces cada seguidor recibe notificación:
  | Contenido                                          |
  | "La receta 'Tacos al Pastor' fue actualizada"    |
  | "Cambios: Ingredientes modificados, 2 pasos [...] |
  | Enlace a la receta actualizada                    |
```

---

## US3.3: Reseñas y Valoraciones de Recetas
**Como** usuario, **quiero** calificar y comentar las recetas, **para** compartir mi experiencia preparando el platillo.

### Criterios de Aceptación (Gherkin)

**Escenario 1: Calificar receta con estrellas**
```gherkin
Dado que tengo la receta guardada
Y estoy en la página de receta
Cuando hago clic en la sección de "Reseñas"
Entonces veo estrellas 1-5 para seleccionar
Y puedo hacer clic en la 4ª estrella
Entonces se resalta: ★★★★☆
Y se registra mi calificación
Y muestra mensaje: "Gracias por tu calificación"
```

**Escenario 2: Escribir comentario en reseña**
```gherkin
Dado que califiqué la receta
Cuando hago clic en campo de "Comentario"
Entonces puedo escribir hasta 500 caracteres
Y mostrador de caracteres: "120/500"
Y puedo hacer clic en "Publicar reseña"
Entonces se registra comentario + calificación
Y aparece con mi nombre y foto de perfil
Y muestra timestamp: "hace 2 minutos"
```

**Escenario 3: Subir foto de resultado en reseña**
```gherkin
Dado que estoy escribiendo una reseña
Cuando hago clic en "Subir foto"
Entonces puedo seleccionar imagen del dispositivo
Y compruebo que sea JPG, PNG o WebP (máx 5MB)
Y aparece preview de la foto
Y se sube junto con la reseña
Entonces en la reseña aparece la foto del platillo preparado
```

**Escenario 4: Mostrar promedio de calificaciones**
```gherkin
Dado que una receta tiene 50 reseñas:
  - 30 calificaciones de 5 estrellas
  - 15 de 4 estrellas
  - 5 de 3 estrellas
Cuando veo la página de receta
Entonces muestro:
  | Información                 |
  | Promedio: ⭐⭐⭐⭐ (4.3/5)   |
  | "Basado en 50 reseñas"      |
  | Desglose: 5★ (60%), 4★ (30%)|
```

**Escenario 5: Solo usuarios con receta guardada pueden reseñar**
```gherkin
Dado que no he guardado la receta
Cuando intento escribir una reseña
Entonces el sistema rechaza
Y muestra mensaje: "Debes guardar la receta primero para reseñarla"
Y ofrezco botón "Guardar receta"
```

**Escenario 6: Marcar comentario como útil**
```gherkin
Dado que veo una reseña de otro usuario
Y ella contiene comentario: "Agregué más canela y quedó perfecta!"
Cuando hago clic en "👍 Útil"
Entonces se incrementa contador de utilidad
Y el sistema ordena comentarios por más útiles primero
```

**Escenario 7: Moderar comentarios inapropiados**
```gherkin
Dado que una reseña contiene lenguaje inapropiado
Cuando hago clic en "⚠️ Reportar"
Entonces aparece opción para indicar razón:
  | Razón                    |
  | Lenguaje ofensivo        |
  | Spam o publicidad        |
  | Contenido sexual         |
  | Otro                     |
Y envío el reporte
Entonces los moderadores revisan dentro de 24h
Y si es violación, ocultan comentario
```

**Escenario 8: Eliminar mi propia reseña**
```gherkin
Dado que escribí una reseña
Cuando veo "Mi reseña" en la página
Y hago clic en "Eliminar"
Entonces sistema pide confirmación
Y si confirmo, se elimina la reseña
Y se recalcula el promedio
Y muestra mensaje: "Reseña eliminada"
```


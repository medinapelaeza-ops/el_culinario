title,body,labels,acceptance_criteria,technical_notes
"US1.1: Registro de Usuarios","**Como** cocinero nuevo, **quiero** crear una cuenta con mi correo y contraseña, **para** acceder a las funciones de creación de recetas.

### Descripción Detallada:
El usuario debe poder registrarse de forma rápida y segura. El sistema validará la información para evitar duplicados y asegurar contraseñas fuertes.

### Criterios de Aceptación:
- [ ] Formulario con campos: Nombre completo, Correo electrónico y Contraseña (con confirmación).
- [ ] Validar que el correo no esté registrado previamente (mostrar error claro).
- [ ] Validar fortaleza de contraseña (mínimo 8 caracteres, mayúsculas, números y símbolos).
- [ ] Contraseña encriptada en base de datos (usar bcrypt o similar).
- [ ] Enviar email de confirmación para validar el correo.
- [ ] Redirigir al Login tras un registro exitoso.
- [ ] Mostrar notificación de éxito: 'Cuenta creada. Revisa tu email para confirmar'.
- [ ] Implementar CAPTCHA para evitar bots.
- [ ] Términos y condiciones (checkbox obligatorio).","epic:autenticacion,prioridad:alta,sprint:1","1. Email validation (regex + backend check)
2. Password hashing (bcrypt, salt rounds ≥ 10)
3. Email confirmation token (JWT, 24h expiry)
4. CAPTCHA integration (reCAPTCHA v3)
5. Error handling for duplicate emails","- Use nodemailer or SendGrid for email
- Store hashed passwords only
- Implement rate limiting
- Log registration attempts"
"US1.2: Inicio y Cierre de Sesión","**Como** usuario registrado, **quiero** iniciar y cerrar sesión con mis credenciales, **para** proteger y administrar mis platillos guardados.

### Descripción Detallada:
El usuario autenticado accede a la plataforma de forma segura. Las sesiones se mantienen activas y pueden ser cerradas en cualquier momento.

### Criterios de Aceptación:
- [ ] Formulario con campos: Correo y Contraseña.
- [ ] Botón 'Olvidé mi contraseña' con recuperación por email.
- [ ] Mostrar mensaje de error si las credenciales son incorrectas (sin especificar si correo o contraseña).
- [ ] Mantener la sesión activa mediante JWT (tokens) o cookies seguras (HttpOnly, Secure, SameSite).
- [ ] Botón visible de 'Cerrar sesión' que destruya la sesión actual.
- [ ] Remember me (opcional): mantener sesión por 30 días si se selecciona.
- [ ] Mostrar último acceso en el perfil.
- [ ] Implementar timeout de sesión (15-30 minutos de inactividad).
- [ ] Notificación de 'Sesión iniciada desde nuevo dispositivo'.","epic:autenticacion,prioridad:alta,sprint:1","1. JWT token generation (HS256, 24h expiry)
2. Refresh token rotation (7d expiry)
3. Password reset flow (email token)
4. Session timeout middleware
5. Device tracking (user-agent + IP)","- Use secure cookie flags
- Implement refresh token strategy
- Log login/logout events
- Track failed login attempts (rate limit after 5 attempts)"
"US1.2.1: Recuperación de Contraseña","**Como** usuario, **quiero** recuperar acceso a mi cuenta si olvido mi contraseña, **para** continuar usando la plataforma.

### Criterios de Aceptación:
- [ ] Página con campo de correo para iniciar recuperación.
- [ ] Enviar email con enlace de reseteo (válido por 1 hora).
- [ ] Formulario para ingresar nueva contraseña con validación de fortaleza.
- [ ] Confirmación de cambio exitoso.
- [ ] Invalidar todos los tokens activos tras cambio de contraseña.","epic:autenticacion,prioridad:alta,sprint:2","1. Reset token generation (UUID + expiry)
2. Email with secure reset link
3. Token validation and invalidation
4. Password strength validation","- Store reset tokens in DB with timestamp
- Send confirmation email after reset
- Audit log for security"
"US2.1: Crear un Platillo (Create)","**Como** chef autenticado, **quiero** registrar un nuevo platillo con su nombre, categoría y descripción, **para** que forme parte del catálogo general.

### Descripción Detallada:
La creación de platillos es el corazón de la plataforma. Permite a los chefs compartir sus creaciones con metadatos completos.

### Criterios de Aceptación:
- [ ] Formulario con campos obligatorios: Nombre del platillo, Descripción, Categoría (Entrada, Fuerte, Postre, Bebida, Snack).
- [ ] Permitir subir o enlazar una URL de imagen del platillo (opcional).
- [ ] Campo de dificultad (Fácil, Media, Difícil).
- [ ] Tiempo estimado de preparación (en minutos).
- [ ] Número de porciones.
- [ ] Ingredientes principales (tags, máximo 5).
- [ ] Notas especiales (alergenos, dietéticas: vegetariano, vegano, sin gluten, etc.).
- [ ] Validar campos antes de guardar.
- [ ] Mostrar mensaje de éxito con opción de añadir receta al platillo.
- [ ] Redirigir a la página de detalle del platillo creado.","epic:crud-platillos,prioridad:alta,sprint:1","1. Form validation (client + server)
2. Image upload to S3 or similar
3. Slug generation for URLs
4. Timestamp tracking (created_at)
5. User ID association","- Implement image compression
- Use CDN for image delivery
- Validate image format (JPG, PNG, WebP)
- Max file size: 5MB"
"US2.2: Visualizar Platillos (Read)","**Como** usuario de la plataforma, **quiero** ver una lista de todos los platillos registrados, **para** explorar las opciones disponibles.

### Descripción Detallada:
Una vista galería intuitiva con búsqueda y filtrado para descubrir platillos de forma efectiva.

### Criterios de Aceptación:
- [ ] Vista de catálogo tipo 'tarjetas' (cards) con foto, nombre, categoría y descripción corta.
- [ ] Filtrar por categoría, dificultad y tiempo de preparación.
- [ ] Buscador por nombre o ingredientes principales.
- [ ] Ordenamiento: Recientes, Más populares, A-Z.
- [ ] Vista de detalle: Al hacer clic en un platillo, se abre página dedicada.
- [ ] Página de detalle muestra: Nombre, foto, descripción, ingredientes principales, dificultad, tiempo, porciones, notas dietéticas.
- [ ] Botón para ver receta asociada (si existe).
- [ ] Mostrar autor del platillo y fecha de creación.
- [ ] Contador de visualizaciones.","epic:crud-platillos,prioridad:alta,sprint:1","1. Pagination (12-15 items per page)
2. Search indexing (ElasticSearch optional)
3. Caching strategy (Redis)
4. Database query optimization
5. Analytics tracking","- Implement lazy loading for images
- Use API filtering/sorting
- Cache popular platillos
- Track view counts in analytics"
"US2.3: Modificar un Platillo (Update)","**Como** creador del platillo, **quiero** editar los datos de un platillo existente, **para** corregir errores o actualizar su información.

### Criterios de Aceptación:
- [ ] Botón 'Editar' visible únicamente para el usuario dueño del platillo o administrador.
- [ ] Formulario precargado con los datos actuales del platillo.
- [ ] Permitir cambiar todos los campos (nombre, descripción, categoría, imagen, etc.).
- [ ] Registro de auditoría: quién editó, cuándo y qué cambió.
- [ ] Opción de ver historial de versiones anteriores.
- [ ] Validar cambios antes de guardar.
- [ ] Confirmación de cambios exitosos.","epic:crud-platillos,prioridad:media,sprint:2","1. Version control (audit log)
2. Diff tracking for changes
3. Rollback capability
4. Update timestamp
5. Change notification to followers","- Implement soft deletes
- Track who made changes
- Notify followers of updates
- Validate no duplicate names"
"US2.4: Eliminar un Platillo (Delete)","**Como** creador del platillo, **quiero** borrar un platillo del sistema, **para** quitar del catálogo platos que ya no se preparan.

### Criterios de Aceptación:
- [ ] Botón 'Eliminar' protegido (solo propietario o admin).
- [ ] Alerta de confirmación intermedia ('¿Estás seguro?').
- [ ] Opción de borrado temporal (soft delete) por defecto.
- [ ] Borrado permanente solo disponible después de 30 días (para recuperación).
- [ ] Crear notificación para usuarios que siguieron este platillo.
- [ ] Confirmar eliminación con email.","epic:crud-platillos,prioridad:baja,sprint:2","1. Soft delete implementation
2. Hard delete after 30 days
3. Cascade delete for orphaned recipes
4. Audit log entry
5. Notification system","- Use soft_deleted_at field
- Archive data before permanent delete
- Log deletions for compliance
- Notify linked users"
"US3.1: Añadir Receta Avanzada a un Platillo","**Como** chef o cocinero, **quiero** desglosar los ingredientes y pasos de preparación dentro de un platillo, **para** que otros usuarios puedan replicar la receta.

### Descripción Detallada:
Las recetas son el complemento detallado de cada platillo. Permiten instrucciones paso a paso con ingredientes precisos.

### Criterios de Aceptación:
- [ ] La sección de 'Receta' se asocia directamente al ID de un Platillo existente.
- [ ] Permite añadir ingredientes de forma dinámica: Cantidad, Unidad (g, ml, taza, cucharada, etc.), Nombre del ingrediente.
- [ ] Validar ingredientes contra base de datos de ingredientes comunes (autocomplete).
- [ ] Campo de notas especiales por ingrediente (opcional: 'cortado fino', 'a temperatura ambiente', etc.).
- [ ] Lista numerada de pasos para el procedimiento (máximo 20 pasos).
- [ ] Editor de pasos con formato rico (negrita, listas, imágenes opcionales).
- [ ] Campo de tiempo estimado por paso.
- [ ] Sección de consejos/tips del chef (opcional).
- [ ] Opción de guardar como borrador antes de publicar.
- [ ] Mostrar receta con formato legible y imprimible.
- [ ] Contador de valoraciones y comentarios en la receta.","epic:recetas,prioridad:alta,sprint:1","1. Nested data structure (recipe -> steps, ingredients)
2. Ingredient database/autocomplete
3. Rich text editor (Markdown or WYSIWYG)
4. Image upload per step
5. Version control for recipes","- Use structured data (JSON schema)
- Implement rich text with sanitization
- Support print-friendly CSS
- Track recipe ratings/reviews
- Cache popular recipes"
"US3.2: Editar y Versioning de Recetas","**Como** chef, **quiero** editar recetas existentes y ver el historial de cambios, **para** mejorar las instrucciones continuamente.

### Criterios de Aceptación:
- [ ] Botón 'Editar receta' visible solo para propietario o admin.
- [ ] Formulario precargado con datos actuales.
- [ ] Historial de versiones con opción de restaurar versiones anteriores.
- [ ] Comparador de versiones (ver qué cambió).
- [ ] Notificación a usuarios que han guardado/comentado la receta sobre cambios.","epic:recetas,prioridad:media,sprint:2","1. Version history table
2. Diff comparison tool
3. Rollback mechanism
4. Change notifications
5. Audit trail","- Implement version numbers
- Store all recipe versions
- Send notifications to followers
- Track changes in detail"
"US3.3: Reseñas y Valoraciones de Recetas","**Como** usuario, **quiero** calificar y comentar las recetas, **para** compartir mi experiencia preparando el platillo.

### Criterios de Aceptación:
- [ ] Sistema de calificación de 1-5 estrellas.
- [ ] Campo de comentario de texto libre (máximo 500 caracteres).
- [ ] Foto opcional de cómo quedó el platillo (user-generated content).
- [ ] Mostrar promedio de calificaciones y número de reseñas.
- [ ] Moderar comentarios (opcionalmente).
- [ ] Marcar comentarios como útiles ('Útil', 'No útil').
- [ ] Solo usuarios que han guardado la receta pueden reseñarla.","epic:recetas,prioridad:media,sprint:2","1. Rating aggregation (avg, count)
2. Comment moderation system
3. User-generated content handling
4. Image upload for reviews
5. Sentiment analysis (optional)","- Implement comment moderation
- Store ratings with timestamps
- Calculate weighted ratings
- Show helpful comments first"

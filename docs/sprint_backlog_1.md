# Sprint Backlog 1 - El Culinario

**Sprint Duration:** 2 weeks  
**Sprint Goal:** Establecer los cimientos de autenticación y gestión de usuarios para la plataforma El Culinario.

---

## Sprint Tasks Overview

| Task ID | User Story | Prioridad | Estimación | Estado |
|---------|-----------|-----------|------------|--------|
| TASK-1 | US1.1: Registro de Usuarios | Alta | 8 pts | Por hacer |
| TASK-2 | US1.2: Inicio y Cierre de Sesión | Alta | 13 pts | Por hacer |
| TASK-3 | US1.2.1: Recuperación de Contraseña | Media | 8 pts | Por hacer |
| TASK-4 | US2.1: Crear un Platillo | Alta | 13 pts | Por hacer |
| TASK-5 | US2.2: Visualizar Platillos | Alta | 13 pts | Por hacer |

---

## Detailed Tasks

### TASK-1: US1.1 - Registro de Usuarios
**Prioridad:** Alta  
**Puntos:** 8  
**Estado:** Por hacer

#### Descripción
El usuario debe poder registrarse de forma rápida y segura con validaciones robustas.

#### Subtareas
- [ ] **Frontend - Crear formulario de registro**
  - Campos: Nombre, Correo, Contraseña, Confirmación
  - Validación en cliente de campos requeridos
  - Integración de CAPTCHA
  - Aceptación de términos y condiciones
  - Estilos responsivos

- [ ] **Backend - Implementar endpoint POST /auth/register**
  - Validar email único en base de datos
  - Validar fortaleza de contraseña (8+ chars, mayúsculas, números, símbolos)
  - Validar coincidencia de contraseñas
  - Validar CAPTCHA con servicio externo
  - Encriptar contraseña con bcrypt
  - Generar token de confirmación de email

- [ ] **Backend - Envío de email de confirmación**
  - Configurar servicio de email (SendGrid, Mailgun, etc.)
  - Crear template de email de confirmación
  - Implementar endpoint de validación de email
  - Almacenar estado de email confirmado

- [ ] **Pruebas**
  - Test: Registro exitoso con datos válidos
  - Test: Rechazo por email duplicado
  - Test: Rechazo por contraseña débil
  - Test: Rechazo por contraseñas no coincidentes
  - Test: Rechazo sin CAPTCHA completado

#### Criterios de Aceptación Específicos
✓ Escenario 1: Registro exitoso con información válida  
✓ Escenario 2: Rechazo por duplicado  
✓ Escenario 3: Rechazo por contraseña débil  
✓ Escenario 4: Rechazo por confirmación incorrecta  
✓ Escenario 5: Bloqueo de bots con CAPTCHA  

---

### TASK-2: US1.2 - Inicio y Cierre de Sesión
**Prioridad:** Alta  
**Puntos:** 13  
**Estado:** Por hacer

#### Descripción
Gestión completa de sesiones de usuario con tokens JWT, refresh tokens y seguridad.

#### Subtareas
- [ ] **Frontend - Crear página de login**
  - Campos: Correo, Contraseña
  - Checkbox "Recuérdame por 30 días"
  - Link "¿Olvidaste tu contraseña?"
  - Manejo de errores y mensaje de bloqueo

- [ ] **Backend - Implementar autenticación JWT**
  - Endpoint POST /auth/login
  - Validar credenciales
  - Generar JWT con expiración 24 horas
  - Generar refresh token con expiración 7 días
  - Configurar cookies HttpOnly, Secure, SameSite

- [ ] **Backend - Implementar refresh token**
  - Endpoint POST /auth/refresh
  - Validar refresh token
  - Generar nuevo JWT
  - Renovar refresh token

- [ ] **Backend - Implementar bloqueo por intentos fallidos**
  - Registrar intentos fallidos
  - Bloquear cuenta después de 5 intentos
  - Bloqueo temporal de 15 minutos
  - Notificar usuario por email

- [ ] **Frontend - Logout**
  - Botón "Cerrar sesión" en dashboard
  - Destruir tokens en cliente
  - Eliminar cookies
  - Redirigir a login

- [ ] **Backend - Logout endpoint**
  - Endpoint POST /auth/logout
  - Invalidar refresh token
  - Registrar en auditoría

- [ ] **Backend - Detectar nuevo dispositivo**
  - Registrar IP, navegador, ubicación en login
  - Comparar con sesiones anteriores
  - Detectar nuevo dispositivo
  - Enviar notificación por email

- [ ] **Backend - Timeout de sesión**
  - Middleware para verificar inactividad
  - Invalidar sesión después de 20 minutos inactivo
  - Redirigir a login con mensaje

- [ ] **Pruebas**
  - Test: Login exitoso
  - Test: Credenciales incorrectas
  - Test: Bloqueo por 5 intentos fallidos
  - Test: Logout exitoso
  - Test: Refresh token funciona
  - Test: Timeout de inactividad
  - Test: Nuevo dispositivo notificado

#### Criterios de Aceptación Específicos
✓ Escenario 1: Inicio de sesión exitoso  
✓ Escenario 2: Rechazo por credenciales incorrectas  
✓ Escenario 3: Bloqueo por intentos fallidos  
✓ Escenario 4: Cerrar sesión exitosamente  
✓ Escenario 5: Opción "Recuérdame"  
✓ Escenario 6: Timeout de sesión por inactividad  
✓ Escenario 7: Notificación en nuevo dispositivo  

---

### TASK-3: US1.2.1 - Recuperación de Contraseña
**Prioridad:** Media  
**Puntos:** 8  
**Estado:** Por hacer

#### Descripción
Flujo seguro para recuperación de contraseña con tokens de reseteo.

#### Subtareas
- [ ] **Frontend - Página de recuperación**
  - Formulario de email
  - Link "¿Olvidaste tu contraseña?" desde login
  - Mensaje de confirmación

- [ ] **Backend - Generar token de reseteo**
  - Endpoint POST /auth/forgot-password
  - Generar token único (no reversible)
  - Almacenar token con expiración 1 hora
  - Enviar email con link

- [ ] **Frontend - Formulario de cambio de contraseña**
  - Validar token en URL
  - Campos: nueva contraseña, confirmación
  - Validar requisitos de seguridad
  - Mostrar mensaje si token expiró

- [ ] **Backend - Endpoint de cambio de contraseña**
  - POST /auth/reset-password
  - Validar token no expirado
  - Validar fortaleza de nueva contraseña
  - Encriptar nueva contraseña
  - Invalidar todos los JWT activos

- [ ] **Email de confirmación**
  - Enviar confirmación después de cambio
  - Incluir IP, navegador, fecha
  - Incluir link para reportar acceso no autorizado

- [ ] **Pruebas**
  - Test: Solicitud de recuperación exitosa
  - Test: Correo no registrado
  - Test: Cambio con contraseña válida
  - Test: Rechazo por contraseña débil
  - Test: Enlace expirado
  - Test: Email de confirmación enviado

#### Criterios de Aceptación Específicos
✓ Escenario 1: Solicitud de recuperación exitosa  
✓ Escenario 2: Rechazo por correo no registrado  
✓ Escenario 3: Cambio con nueva contraseña válida  
✓ Escenario 4: Rechazo por contraseña débil  
✓ Escenario 5: Enlace de recuperación expirado  
✓ Escenario 6: Confirmación de cambio por email  

---

### TASK-4: US2.1 - Crear un Platillo
**Prioridad:** Alta  
**Puntos:** 13  
**Estado:** Por hacer

#### Descripción
Funcionalidad core para crear platillos con validaciones y almacenamiento de imágenes.

#### Subtareas
- [ ] **Frontend - Formulario de creación**
  - Campos: nombre, descripción, categoría, dificultad
  - Campos: tiempo prep, porciones, ingredientes principales
  - Preview de imagen
  - Validación en cliente de campos requeridos

- [ ] **Frontend - Upload de imagen**
  - Soporte JPG, PNG, WebP
  - Validación de tamaño (máx 5MB)
  - Preview antes de crear
  - Mensaje de error para formatos inválidos

- [ ] **Backend - Endpoint POST /dishes**
  - Validar usuario autenticado
  - Validar campos obligatorios
  - Validar imagen (formato, tamaño)
  - Comprimir y optimizar imagen
  - Generar slug único
  - Asociar al usuario
  - Registrar timestamp

- [ ] **Almacenamiento de imágenes**
  - Integrar con CDN (CloudFront, Cloudinary, etc.)
  - Optimizar resoluciones múltiples
  - Almacenar path en base de datos

- [ ] **Validación de ingredientes**
  - Máximo 5 ingredientes principales
  - Deshabilitar campo al llegar a 5

- [ ] **Redirección post-creación**
  - Mostrar mensaje "Platillo creado exitosamente"
  - Ofrecer opción "Añadir receta ahora"
  - Redirigir a página de detalle

- [ ] **Pruebas**
  - Test: Crear con todos datos requeridos
  - Test: Rechazo sin nombre
  - Test: Rechazo por imagen inválida
  - Test: Platillo sin imagen (placeholder)
  - Test: Máximo 5 ingredientes

#### Criterios de Aceptación Específicos
✓ Escenario 1: Crear con todos datos requeridos  
✓ Escenario 2: Rechazo por campos obligatorios faltantes  
✓ Escenario 3: Rechazo por imagen inválida  
✓ Escenario 4: Platillo sin imagen (opcional)  
✓ Escenario 5: Máximo 5 ingredientes principales  

---

### TASK-5: US2.2 - Visualizar Platillos
**Prioridad:** Alta  
**Puntos:** 13  
**Estado:** Por hacer

#### Descripción
Galería de platillos con búsqueda, filtrado y ordenamiento.

#### Subtareas
- [ ] **Frontend - Galería de platillos**
  - Layout grid de tarjetas (12 por página)
  - Cada tarjeta: foto, nombre, categoría, descripción
  - Paginación (Anterior, Siguiente, números)

- [ ] **Frontend - Filtros**
  - Filtro por categoría (dropdown)
  - Filtro por dificultad
  - Filtro por rango de tiempo
  - Contador: "Mostrando X de Y platillos"

- [ ] **Frontend - Búsqueda**
  - Buscador por nombre e ingredientes
  - Resaltar coincidencias
  - Enter o botón buscar

- [ ] **Frontend - Ordenamiento**
  - Ordenar por: Más populares, Reciente, Mejor valorado
  - Selector dropdown

- [ ] **Frontend - Página de detalle**
  - Mostrar todos los detalles
  - Botón "Ver receta"
  - Contador de visualizaciones
  - Autor y fecha

- [ ] **Backend - Endpoint GET /dishes**
  - Paginación (limit, offset)
  - Filtros (category, difficulty, time_range)
  - Búsqueda (name, ingredients)
  - Ordenamiento

- [ ] **Backend - Endpoint GET /dishes/:id**
  - Retornar detalles completos
  - Incrementar contador de vistas

- [ ] **Backend - Contador de vistas**
  - Incrementar con cada acceso a detalle
  - No contar vistas del propietario (opcional)

- [ ] **Pruebas**
  - Test: Ver catálogo con paginación
  - Test: Filtrar por categoría
  - Test: Filtrar por dificultad
  - Test: Filtrar por tiempo
  - Test: Búsqueda por nombre
  - Test: Búsqueda por ingredientes
  - Test: Ordenar por popularidad
  - Test: Ver detalle y contador incrementa

#### Criterios de Aceptación Específicos
✓ Escenario 1: Ver catálogo de platillos  
✓ Escenario 2: Filtrar por categoría  
✓ Escenario 3: Filtrar por dificultad  
✓ Escenario 4: Filtrar por tiempo de preparación  
✓ Escenario 5: Buscar por nombre o ingredientes  
✓ Escenario 6: Ordenar platillos  
✓ Escenario 7: Ver detalle del platillo  
✓ Escenario 8: Contador de visualizaciones  

---

## Definición de Hecho (Definition of Done)

- [ ] Código revisado y aprobado en PR
- [ ] Tests unitarios con cobertura >80%
- [ ] Tests de integración pasando
- [ ] Documentación actualizada
- [ ] Sin console.log o código de debug
- [ ] Validaciones de seguridad implementadas
- [ ] Manejo de errores robusto
- [ ] Responsive en mobile/tablet/desktop
- [ ] Performance aceptable (Lighthouse >85)
- [ ] Accesibilidad WCAG 2.1 AA
- [ ] Pruebas manuales QA completadas

---

## Notas del Sprint

- Enfoque en autenticación y seguridad como base
- Establecer patrones de código reutilizable
- Documentar decisiones de arquitectura
- Preparar CI/CD pipeline

---

## Roles

- **Product Owner:** medinapelaeza-ops
- **Scrum Master:** (Asignar)
- **Equipo de Desarrollo:** (Asignar)

---

## Links Relacionados

- [Product Backlog](./product_backlog.md)
- [Sprint Planning](./sprint_planning.md) (por crear)
- [Architecture Decision Records](./adr/) (por crear)


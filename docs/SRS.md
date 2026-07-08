# El Culinario - Especificación Técnica Flutter/Dart

## Alcance
Documento de especificación de requisitos para la implementación de la aplicación móvil multiplataforma usando Dart/Flutter, manteniendo la paridad de funcionalidades con la versión web (Next.js) y adaptando los requisitos al contexto móvil.

---

## 1. Requisitos Funcionales (RF) ✔️

RF-1: Registro de Usuarios (US1.1)
- RF-1.1: Formulario nativo de registro con campos: Nombre, Correo electrónico y Contraseña.
- RF-1.2: Validación cliente en tiempo real; validar unicidad del correo contra backend.
- RF-1.3: Validar fortaleza de contraseña (mínimo 8 caracteres, mayúsculas, números y símbolos) con indicador visual.
- RF-1.4: Validar coincidencia entre contraseña y confirmación.
- RF-1.5: Checkbox de aceptación de términos y condiciones; integración con reCAPTCHA v3 o alternativa móvil.
- RF-1.6: Integración segura con backend para encriptación de contraseña con bcrypt.
- RF-1.7: Envío de email de confirmación con token; activación de cuenta tras validación por enlace deep-linked.
- RF-1.8: Notificaciones nativas y mensajes de error claros para: correo duplicado, contraseña débil, confirmación incorrecta.

RF-2: Inicio y Cierre de Sesión (US1.2)
- RF-2.1: Pantalla de login con campos de email/contraseña; opción "Recuérdame".
- RF-2.2: Autenticación con JWT (24h) y refresh token (7 días); almacenamiento seguro en Keystore (Android) / Keychain (iOS).
- RF-2.3: Biometric authentication (huella dactilar, reconocimiento facial) como opción de login rápido.
- RF-2.4: Refresh de tokens automático; notificación silenciosa al detectar reautenticación.
- RF-2.5: Logout que invalida refresh token y sesión del lado servidor.
- RF-2.6: Bloqueo de cuenta temporalmente tras 5 intentos fallidos (15 minutos).
- RF-2.7: Notificación por push cuando se detecta nuevo login desde otro dispositivo (IP, navegador, ubicación).
- RF-2.8: Timeout automático tras 20 minutos de inactividad; redirigir a login con mensaje.

RF-3: Recuperación de Contraseña (US1.2.1)
- RF-3.1: Pantalla para solicitar recuperación; generar token único y envío por email (válido 1 hora).
- RF-3.2: Validación de token con deep link; formulario para cambiar contraseña.
- RF-3.3: Validar requisitos de contraseña antes de enviar al backend.
- RF-3.4: Invalidar todos los JWT activos tras el cambio.
- RF-3.5: Enviar email de confirmación con opción para reportar acceso no autorizado.
- RF-3.6: Manejo de token expirado con UI clara y opción para solicitar nuevo enlace.

RF-4: Crear Platillo (US2.1)
- RF-4.1: Formulario nativo para crear platillo con campos: Nombre, Categoría, Descripción, Dificultad, Tiempo, Porciones, Ingredientes (máx 5).
- RF-4.2: Validación cliente/servidor de campos obligatorios (nombre requerido).
- RF-4.3: Selector de cámara/galería para imagen; validación de formato (JPG/PNG/WebP) y tamaño (máx 5MB).
- RF-4.4: Compresión y optimización de imagen local antes de carga; mostrar progress bar de carga.
- RF-4.5: Generación de slug único en backend; sincronización con cliente.
- RF-4.6: Asociación automática al usuario autenticado; timestamp de creación.
- RF-4.7: Imagen placeholder por defecto si no se sube.
- RF-4.8: UI dinámica para agregar ingredientes hasta máximo 5; deshabilitar botón al alcanzar límite.

RF-5: Visualizar Platillos (US2.2)
- RF-5.1: Pantalla de catálogo con scroll infinito (carga 12 platillos iniciales, luego 12 más al llegar al final).
- RF-5.2: Filtros nativos por: categoría, dificultad, rango de tiempo; aplicación en tiempo real.
- RF-5.3: Búsqueda por nombre e ingredientes con debouncing; resaltar coincidencias.
- RF-5.4: Ordenamiento por: más populares, recientes, mejor valorados.
- RF-5.5: Detalle de platillo con foto grande, descripción, ingredientes, dificultad, tiempo, porciones, autor, fecha, contador de vistas.
- RF-5.6: Incrementar contador de vistas en cada acceso al detalle; excluir vistas del propietario.

RF-6: Modificar Platillo (US2.3)
- RF-6.1: Botón "Editar" visible solo para el creador; acceso protegido a pantalla de edición.
- RF-6.2: Formulario precargado con datos existentes; validación antes de guardar.
- RF-6.3: Registro de auditoría en backend (quién, cuándo, qué).
- RF-6.4: Acceso a historial de versiones con metadatos (número, fecha, usuario, resumen).
- RF-6.5: Opción para restaurar versión anterior; crea nueva versión preservando historial.
- RF-6.6: Notificación por push a seguidores cuando se publican cambios.

RF-7: Eliminar Platillo (US2.4)
- RF-7.1: Botón eliminar visible solo para creador; confirmación mediante diálogo modal.
- RF-7.2: Soft-delete: marcar como eliminado, ocultar del catálogo, email de confirmación.
- RF-7.3: Pantalla de "Platillos eliminados" dentro de perfil con opción restaurar (30 días de gracia).
- RF-7.4: Período de gracia de 30 días; aviso de eliminación permanente.
- RF-7.5: Cascada lógica: marcar recetas asociadas como soft-deleted; notificar a usuarios que las guardaron.
- RF-7.6: Notificación por push a seguidores sobre eliminación.

RF-8: Añadir Receta Avanzada (US3.1)
- RF-8.1: Pantalla para agregar receta asociada a platillo existente (pre-seleccionado o selector).
- RF-8.2: Selector dinámico de ingredientes: cantidad (input), unidad (dropdown), ingrediente (autocomplete con sugerencias del servidor).
- RF-8.3: Notas asociadas por ingrediente con UI expansible.
- RF-8.4: Editor de pasos con: texto enriquecido básico (negrita, cursiva, listas), cámara/galería por paso, tiempo estimado.
- RF-8.5: Máximo 20 pasos por receta; validación en cliente y servidor.
- RF-8.6: Guardar como borrador (almacenado localmente y en servidor) o publicar; validar mínimo 1 ingrediente, 1 paso, título.

RF-9: Editar y Versioning de Recetas (US3.2)
- RF-9.1: El creador puede editar receta; cada guardado crea nueva versión con timestamp y changelog.
- RF-9.2: Pantalla de historial con lista de versiones; comparación entre versiones (cambios resaltados) y opción restaurar.
- RF-9.3: Notificación por push a seguidores al publicar cambios significativos.

RF-10: Reseñas y Valoraciones (US3.3)
- RF-10.1: Usuarios que guardaron receta pueden calificar (1-5 estrellas con UI táctil) y comentar (máx 500 caracteres).
- RF-10.2: Selector de galería/cámara para foto del resultado; validación (JPG/PNG/WebP, máx 5MB).
- RF-10.3: Visualización de promedio de calificaciones y desglose por estrellas.
- RF-10.4: Botón "Útil" para comentarios; ordenamiento por utilidad.
- RF-10.5: Opción reportar reseña inapropiada con selección de razón; sistema de moderación en backend.
- RF-10.6: El autor puede eliminar su propia reseña; recálculo automático del promedio.

---

## 2. Requisitos No Funcionales (RNF) ✖️

Seguridad
- RNF-1: Todas las comunicaciones HTTPS/TLS con certificate pinning para mayor seguridad móvil.
- RNF-2: Contraseñas nunca almacenadas localmente; encriptadas en bcrypt en backend.
- RNF-3: Tokens JWT almacenados en Keystore (Android 4.3+) / Keychain (iOS 11+) con acceso seguro.
- RNF-4: Rate-limiting por IP (100 requests/min) y por usuario (200 requests/min).
- RNF-5: Validar y sanitizar todas las entradas para prevenir inyecciones y XSS.
- RNF-6: Implementar SSL Pinning con fallback seguro.
- RNF-7: Permisos granulares para cámara, galería, micrófono; solicitar con contexto claro.
- RNF-8: Registro de auditoría en backend para acciones críticas.

Rendimiento y Escalabilidad
- RNF-9: Tiempo de carga de catálogo < 2s en conexión 4G; < 5s en 3G (optimizar con lazy loading).
- RNF-10: Endpoints críticos (login, detalle) < 300ms en condiciones normales.
- RNF-11: Tamaño del APK < 100MB (sin assets); AAB < 80MB.
- RNF-12: Tamaño IPA < 120MB.
- RNF-13: Consumo de memoria < 150MB en operaciones normales.
- RNF-14: Soporte para conexiones lentas y offline con caché local (Hive/sqflite).

Disponibilidad y Sincronización
- RNF-15: Sincronización automática de datos cuando se restaura conexión.
- RNF-16: Modo offline con funcionalidades limitadas (lectura de datos cacheados).
- RNF-17: Notificaciones push confiables (Firebase Cloud Messaging / Apple Push Notification service).

Usabilidad y Accesibilidad
- RNF-18: Interfaz adaptativa (phones, tablets) con orientación portrait/landscape.
- RNF-19: Cumplir WCAG 2.1 AA adaptada a móvil: contraste de colores, tamaño de texto escalable, navegación con screen reader (TalkBack/VoiceOver).
- RNF-20: Mensajes de error claros y localizados (español por defecto).
- RNF-21: Gesture intuitivos: swipe, tap, long-press con feedback háptico.

Privacidad y Cumplimiento
- RNF-22: Cumplir GDPR, LGPD (si aplica): permitir borrado de datos personales, portar datos.
- RNF-23: Tokens y secretos gestionados con backend secure; no hardcodeados en app.
- RNF-24: Política de privacidad clara y consentimiento explícito para datos sensibles.

Mantenibilidad y Observabilidad
- RNF-25: Código en Dart con tipado estricto (null-safety) y análisis estático (dart analyze).
- RNF-26: Cobertura de pruebas unitarias objetivo > 80% en módulos críticos.
- RNF-27: Logs estructurados enviados a backend para análisis; error tracking con Sentry.
- RNF-28: Versioning semántico para releases (versionCode Android, CFBundleVersion iOS).

Calidad y Pruebas
- RNF-29: Tests unitarios (test package) y widget tests (flutter_test) con mock de APIs.
- RNF-30: Tests de integración simulando flujos completos (login, crear platillo, valorar receta).
- RNF-31: Tests E2E con integration_test package en dispositivos reales/emuladores.
- RNF-32: Pruebas de performance (jank, frame time < 60fps en scroll).

Plataforma y Distribución
- RNF-33: Soporte mínimo: Android API 21+ (5.0), iOS 12.0+.
- RNF-34: Compilación multi-arquitectura: arm64, armv7 (Android); arm64 (iOS).
- RNF-35: Distribución por Google Play Store y Apple App Store con versionamiento automático.
- RNF-36: Rollout gradual (staged rollout) con monitoreo de crashes y análisis de usuarios afectados.

Operaciones
- RNF-37: Pipeline CI/CD para build, test y deploy (GitHub Actions con fastlane).
- RNF-38: Notificación automática de nuevas versiones in-app.
- RNF-39: Recolección de metrics de uso y crashes (Firebase Crashlytics, Analytics).

Otros
- RNF-40: Internacionalización: español e inglés por defecto; estructura para agregar más idiomas (easy localization / intl package).
- RNF-41: Theme claro/oscuro adaptable a preferencia del SO.
- RNF-42: Optimización de imágenes con caché en disco (cached_network_image) y memoria.

---

## 3. Stacks Tecnológicos (recomendado) ⏏️

### Frontend Móvil
- **Lenguaje/Framework**: Dart + Flutter (versión 3.0+).
- **Arquitectura**: Clean Architecture o BLoC pattern; GetIt para inyección de dependencias.
- **State Management**: BLoC + cubit (bloc package) o Riverpod para funcionalidad más compleja.
- **Routing**: go_router para navegación declarativa y deep linking.
- **UI Components**: Material 3 (flutter 3.0+) o Cupertino (iOS-native style).
- **Persistencia Local**: Hive (key-value) para tokens y caché; sqflite para datos más complejos.
- **Networking**: Dio + Chopper para HTTP; retry automático.
- **JSON Serialization**: json_serializable + build_runner.
- **Image Handling**: cached_network_image, image_picker, image_cropper.
- **Form Validation**: formz package o validadores custom.
- **Analytics y Crash Reporting**: Firebase Crashlytics, Firebase Analytics.

### Testing
- **Unit Tests**: test package; mockito para mocks.
- **Widget Tests**: flutter_test; golden tests para UI.
- **Integration Tests**: integration_test package en dispositivos reales.
- **Performance Testing**: DevTools, Performance overlay.

### Notificaciones
- **Push**: Firebase Cloud Messaging (FCM) para Android/iOS.
- **Local**: flutter_local_notifications para notificaciones programadas.

### Backend (Compartido con Web)
- **Plataforma**: Node.js + TypeScript.
- **Framework**: NestJS (API REST + WebSockets para notificaciones en tiempo real).
- **Autenticación**: JWT (acceso/refresh) con tokens en Keystore/Keychain móvil.
- **Base de datos**: PostgreSQL con Prisma ORM.
- **Caché/Sesiones**: Redis.
- **Storage**: AWS S3 / Cloudinary.

### Dependencias Críticas de Flutter
```yaml
# BLoC y State Management
flutter_bloc: ^8.1.0
bloc: ^8.1.0
cubit: ^0.1.0
get_it: ^7.4.0
riverpod: ^2.3.0

# Networking
dio: ^5.0.0
chopper: ^7.0.0

# Persistencia
hive: ^2.2.0
hive_flutter: ^1.1.0
sqflite: ^2.2.0

# UI/UX
cached_network_image: ^3.2.0
image_picker: ^0.8.5
image_cropper: ^5.0.0
flutter_local_notifications: ^13.0.0

# Routing
go_router: ^7.0.0

# Validación y Serialización
formz: ^0.6.0
json_serializable: ^6.6.0
equatable: ^2.0.0

# Analytics
firebase_core: ^2.11.0
firebase_analytics: ^10.1.0
firebase_crashlytics: ^2.8.0
firebase_messaging: ^14.1.0

# Internacionalización
easy_localization: ^3.0.0
intl: ^0.18.0

# Testing
mockito: ^5.3.0
mocktail: ^0.3.0

Herramientas de Desarrollo y Calidad 
- Linter: ESLint + Prettier.
- Hooks: Husky (pre-commit), lint-staged.
- Documentación de API: OpenAPI / Swagger.
- Postman collections / Insomnia para pruebas manuales.


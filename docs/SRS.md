# El Culinario

## Alcance
Documento de especificación de requisitos centrado en Requisitos Funcionales, Requisitos No Funcionales y Stacks Tecnológicos, construido a partir de las historias de usuario del backlog.

---

## 1. Requisitos Funcionales (RF) ✔️

RF-1: Registro de Usuarios (US1.1)
- RF-1.1: El sistema debe permitir crear una cuenta con: Nombre, Correo electrónico y Contraseña.
- RF-1.2: Validar unicidad del correo; rechazar registro si el correo ya existe.
- RF-1.3: Validar fortaleza de contraseña (mínimo 8 caracteres, mayúsculas, números y símbolos).
- RF-1.4: Validar coincidencia entre contraseña y confirmación.
- RF-1.5: Requerir aceptación de términos y condiciones y CAPTCHA válido antes de procesar registro.
- RF-1.6: Encriptar la contraseña usando bcrypt antes de persistir.
- RF-1.7: Generar y enviar email de confirmación con token; activar cuenta tras validación por enlace.
- RF-1.8: Mostrar mensajes de error claros para: correo duplicado, contraseña débil, confirmación incorrecta, CAPTCHA no completado.

RF-2: Inicio y Cierre de Sesión (US1.2)
- RF-2.1: Proveer endpoint de login que valide credenciales.
- RF-2.2: Generar JWT con expiración de 24 horas y refresh token con expiración de 7 días al autenticar.
- RF-2.3: Almacenar tokens en cookies con flags HttpOnly, Secure y SameSite; soportar opción "Recuérdame" (sesión persistente 30 días).
- RF-2.4: Implementar endpoint para refresh de tokens.
- RF-2.5: Implementar logout que invalide refresh token y destruya sesión del lado servidor/cliente.
- RF-2.6: Registrar intentos fallidos y bloquear cuenta temporalmente tras 5 intentos fallidos (15 minutos).
- RF-2.7: Detectar inicio de sesión desde nuevo dispositivo/IP y notificar por email con IP, navegador y ubicación aproximada.
- RF-2.8: Invalidar sesión por inactividad (timeout) tras 20 minutos y redirigir a login con mensaje.

RF-3: Recuperación de Contraseña (US1.2.1)
- RF-3.1: Endpoint para solicitar recuperación que genere token único y lo envíe por email (válido 1 hora).
- RF-3.2: Página/formulario para cambiar contraseña que valide token y requisitos de contraseña.
- RF-3.3: Encriptar nueva contraseña con bcrypt y actualizar la cuenta.
- RF-3.4: Invalidar todos los JWT activos tras el cambio de contraseña.
- RF-3.5: Enviar email de confirmación del cambio con IP, navegador y fecha, y link para reportar acceso no autorizado.
- RF-3.6: Manejar token expirado con mensaje y opción para solicitar nuevo enlace.

RF-4: Crear Platillo (US2.1)
- RF-4.1: Formulario para crear platillo con campos obligatorios: Nombre, Categoría, Descripción; opcionales: imagen, dificultad, tiempo, porciones, ingredientes (máx 5).
- RF-4.2: Validación cliente/servidor de campos obligatorios; rechazar creación si falta nombre.
- RF-4.3: Validar imagen: formatos permitidos JPG/PNG/WebP, tamaño máximo 5MB.
- RF-4.4: Comprimir/optimizar imagen y cargarla en CDN; almacenar referencia en BD.
- RF-4.5: Generar slug único para la URL del platillo.
- RF-4.6: Asociar platillo al usuario autenticado y registrar timestamp de creación.
- RF-4.7: Si no se sube imagen, asignar imagen placeholder por defecto.
- RF-4.8: Limitar a 5 ingredientes principales; deshabilitar añadir cuando se alcance el límite.

RF-5: Visualizar Platillos (US2.2)
- RF-5.1: Endpoint paginado (12 por página) para listar platillos con filtros: categoría, dificultad, rango de tiempo.
- RF-5.2: Búsqueda por nombre e ingredientes (resaltar coincidencias en UI).
- RF-5.3: Ordenamiento por: más populares, recientes, mejor valorados.
- RF-5.4: Detalle de platillo con: nombre, foto grande, descripción completa, ingredientes, dificultad, tiempo, porciones, notas dietéticas, autor, fecha, contador de vistas y botón "Ver receta" si existe.
- RF-5.5: Incrementar contador de vistas en cada acceso al detalle; opción de no contar vistas del propietario.

RF-6: Modificar Platillo (US2.3)
- RF-6.1: Sólo el creador ve botón "Editar" y puede acceder a la URL de edición.
- RF-6.2: Formulario de edición precargado; validar campos antes de guardar.
- RF-6.3: Registrar auditoría de cambios (quién, cuándo, qué).
- RF-6.4: Historial de versiones con metadatos (número de versión, fecha, usuario, resumen).
- RF-6.5: Restaurar versión anterior creando nueva versión que preserve historial.
- RF-6.6: Notificar a seguidores del platillo cuando se publican cambios.

RF-7: Eliminar Platillo (US2.4)
- RF-7.1: El creador puede eliminar; mostrar confirmación antes de soft-delete.
- RF-7.2: Soft-delete: marcar platillo eliminado, ocultarlo del catálogo y enviar email de confirmación; indicar periodo de gracia (30 días).
- RF-7.3: Restaurar platillo desde "Platillos eliminados" durante el periodo de gracia.
- RF-7.4: Job programado que ejecute hard-delete después de 30 días: borrar storage, archivar backup y registrar en auditoría.
- RF-7.5: Cascada lógica: marcar recetas asociadas como soft-deleted y notificar a usuarios que las guardaron.
- RF-7.6: Notificar a seguidores sobre la eliminación con detalles (creador, periodo de borrado).

RF-8: Añadir Receta Avanzada (US3.1)
- RF-8.1: Formulario para agregar receta asociada a un platillo existente (pre-seleccionado).
- RF-8.2: Agregar ingredientes dinámicamente con campos: cantidad (num), unidad (dropdown), ingrediente (autocomplete).
- RF-8.3: Permitir notas por ingrediente y asociarlas.
- RF-8.4: Editor rico para pasos: texto enriquecido, listas, subir imagen por paso, tiempo estimado.
- RF-8.5: Limitar a 20 pasos por receta.
- RF-8.6: Guardar como borrador o publicar; publicar requiere mínimo 1 ingrediente, 1 paso y título/ descripción.

RF-9: Editar y Versioning de Recetas (US3.2)
- RF-9.1: El creador puede editar receta; guardar crea nueva versión con timestamp y registro de cambios.
- RF-9.2: Historial de versiones, comparación entre versiones (cambios resaltados) y posibilidad de restaurar.
- RF-9.3: Notificar a seguidores de la receta al publicar cambios significativos.

RF-10: Reseñas y Valoraciones (US3.3)
- RF-10.1: Usuarios que han guardado una receta pueden calificarla (1-5 estrellas) y comentar (máx 500 caracteres).
- RF-10.2: Permitir subir foto del resultado con validación de formato y tamaño (JPG/PNG/WebP, máx 5MB).
- RF-10.3: Mostrar promedio de calificaciones y desglose por estrellas.
- RF-10.4: Permitir marcar comentarios como "útil" y ordenar por utilidad.
- RF-10.5: Permitir reportar reseñas inapropiadas con razones; sistema de moderación que revisa reportes en <24h.
- RF-10.6: El autor puede eliminar su propia reseña; recalcular promedio tras eliminación.

---

## 2. Requisitos No Funcionales (RNF) ✖️

Seguridad
- RNF-1: Todas las comunicaciones deben usar HTTPS/TLS.
- RNF-2: Contraseñas almacenadas sólo en forma encriptada con bcrypt (sal adecuado).
- RNF-3: Cookies de sesión con HttpOnly, Secure y SameSite=strict o lax según requerimiento.
- RNF-4: Implementar rate-limiting por IP (ej. 100 requests/min por endpoint público) y protección contra ataques de fuerza bruta.
- RNF-5: Validar y sanitizar todas las entradas para prevenir XSS, SQL injection y CSRF (usar tokens CSRF donde aplique).
- RNF-6: Registro de auditoría para acciones críticas (login, cambios en recursos, eliminaciones).

Rendimiento y Escalabilidad
- RNF-7: Tiempo de carga de la página catálogo < 1.5s en red móvil 3G simulada (mejorar mediante lazy loading y CDN).
- RNF-8: Endpoints críticos (login, vista detalle) < 300ms en condiciones normales (punto de referencia).
- RNF-9: Soportar escalado horizontal para backend y CDN para activos estáticos/imagenes.

Disponibilidad y Recuperación
- RNF-10: SLA objetivo uptime 99.9% para la API en producción.
- RNF-11: Backups automáticos de la base de datos diarios; retención mínima 30 días.
- RNF-12: RTO objetivo < 4 horas, RPO objetivo < 24 horas (definible según infra).

Usabilidad y Accesibilidad
- RNF-13: Interfaz responsive (mobile/tablet/desktop).
- RNF-14: Cumplir WCAG 2.1 AA en vistas principales (formularios de registro/login, detalles de receta/platillo).
- RNF-15: Mensajes de error claros y localizados (español por defecto).

Privacidad y Cumplimiento
- RNF-16: Cumplir con normativas de protección de datos aplicables (p. ej. GDPR si aplica): permitir borrado de datos personales, portar datos si se solicita.
- RNF-17: Tokens sensibles y secretos gestionados con vault/secret manager; no almacenarlos en repositorios.

Mantenibilidad y Observabilidad
- RNF-18: Código en TypeScript (backend/frontend) con tipado estricto y cobertura de pruebas automatizadas.
- RNF-19: Logs estructurados (JSON) y centralizados; métricas básicas expuestas para monitoreo.
- RNF-20: Errores críticos reportados a sistema de trazabilidad (Sentry u otro).

Calidad y Pruebas
- RNF-21: Tests unitarios con cobertura objetivo >80% por módulo crítico; pruebas de integración para flujos de auth y creación de platillo.
- RNF-22: Pruebas E2E (Cypress) para los flujos: registro/login, crear platillo, ver catálogo, publicar receta.

Operaciones
- RNF-23: Pipeline CI/CD automatizado para pruebas y despliegue (ver Stack).
- RNF-24: Deploys reversibles (blue/green o canary) según plataforma.

Otros
- RNF-25: Internacionalización: soporte para al menos español e inglés con posibilidad de agregar más lenguajes.
- RNF-26: Latencia de carga de imágenes optimizadas < 200ms desde CDN en regiones primarias.

---

## 3. Stacks Tecnológicos (recomendado) ⏏️

Frontend
- Framework: Next.js (React) con TypeScript — por SEO y facilidad de SSR/SSG para catálogos.
- Estilos: Tailwind CSS o CSS-in-JS (Emotion/Styled-Components).
- Build/Bundle: Vercel (hosting frontend) o similar.
- Testing: Jest + React Testing Library; E2E: Cypress.

Backend / API
- Plataforma: Node.js con TypeScript.
- Framework recomendado: NestJS o Express + arquitectura modular (preferible NestJS por estructura y DI).
- Autenticación: JWT (acceso) + Refresh tokens almacenados en base de datos/Redis; password hashing con bcrypt.
- Validación: class-validator / Joi / Zod.
- Tests: Jest, supertest para integración.

Base de datos y caché
- Principal: PostgreSQL (relacional para consultas, integridad y full-text básica).
- ORM: Prisma o TypeORM (recomiendo Prisma con TypeScript).
- Caché y sesiones efímeras / bloqueo de intentos: Redis.

Almacenamiento y CDN
- Storage de archivos: AWS S3 (u opción Cloudinary para simplificar transformación/optimización).
- CDN: CloudFront o CDN del proveedor (Cloudinary, Cloudflare).
- Procesamiento de imágenes: sharp (en backend) o delegar a Cloudinary para transformaciones on-the-fly.

Emails y Notificaciones
- Email transactional: SendGrid o Mailgun (SendGrid recomendado).
- Notificaciones por dispositivo: email (primario); push/otros en roadmap.

CAPTCHA y Bot Protection
- Google reCAPTCHA v2/v3 o hCaptcha (configurable).

Búsqueda
- Inicial: PostgreSQL Full-Text Search para búsquedas por nombre/ingredientes.
- Opcional: Algolia o Elasticsearch para búsquedas avanzadas y relevancia.

Versioning, Storage y Jobs
- Versioning de entidades: almacenar versiones en tablas específicas (ej. recipe_versions) o sistema de auditoría.
- Jobs programados: worker con BullMQ / Redis (procesamiento asíncrono: optimización de imágenes, limpieza hard-delete, envío masivo de emails).

Observabilidad y Monitoreo
- Logging: Winston/Pino con export a sistema central (ELK / Datadog / Logflare).
- Error tracking: Sentry.
- Métricas: Prometheus + Grafana o servicio gestionado.

CI/CD / Infraestructura / DevOps
- Repositorio: GitHub.
- CI/CD: GitHub Actions (pipelines para lint, tests, build, deploy).
- Contenedores: Docker; orquestación: ECS/EKS (AWS) o servicios gestionados (Render, Heroku, Vercel para frontend).
- Secret management: AWS Secrets Manager / HashiCorp Vault.

Seguridad y Buenas Prácticas
- WAF y protección DDoS por proveedor infra.
- Escaneo de dependencias (Dependabot/GitHub Alerts).
- Análisis estático (ESLint, SonarCloud opcional).
- Políticas de CORS, CSP, headers de seguridad (helmet).

Herramientas de Desarrollo y Calidad 
- Linter: ESLint + Prettier.
- Hooks: Husky (pre-commit), lint-staged.
- Documentación de API: OpenAPI / Swagger.
- Postman collections / Insomnia para pruebas manuales.


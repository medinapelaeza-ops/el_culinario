   # Diagrama Entidad-Relación - El Culinario

## Diagrama ER Completo

```mermaid
erDiagram
    USUARIO ||--o{ PLATILLO : crea
    USUARIO ||--o{ RESENA : escribe
    USUARIO ||--o{ FAVORITO : guarda
    USUARIO ||--o{ NOTIFICACION : recibe
    USUARIO ||--o{ HISTORIAL_PLATILLO : registra
    USUARIO ||--o{ HISTORIAL_RECETA : registra

    CATEGORIA ||--o{ PLATILLO : clasifica

    PLATILLO ||--|| RECETA : contiene
    PLATILLO ||--o{ HISTORIAL_PLATILLO : tiene
    PLATILLO ||--o{ SEGUIDOR_PLATILLO : es_seguido

    RECETA ||--o{ PASO : contiene
    RECETA ||--o{ RECETA_INGREDIENTE : utiliza
    RECETA ||--o{ RESENA : recibe
    RECETA ||--o{ FAVORITO : es_favorito
    RECETA ||--o{ HISTORIAL_RECETA : tiene

    INGREDIENTE ||--o{ RECETA_INGREDIENTE : pertenece

    USUARIO ||--o{ SEGUIDOR_PLATILLO : sigue

    USUARIO {
        int id PK
        string nombre
        string email
        string password_hash
        string foto_perfil
        bool email_verificado
        datetime fecha_registro
        bool activo
    }

    CATEGORIA {
        int id PK
        string nombre
        string descripcion
    }

    PLATILLO {
        int id PK
        int usuario_id FK
        int categoria_id FK
        string nombre
        string descripcion
        string dificultad
        int tiempo_preparacion
        int porciones
        string imagen
        string slug
        int vistas
        bool eliminado
        datetime creado_en
    }

    RECETA {
        int id PK
        int platillo_id FK
        string titulo
        string descripcion
        string consejos
        bool publicada
        bool borrador
        datetime fecha_publicacion
    }

    INGREDIENTE {
        int id PK
        string nombre
    }

    RECETA_INGREDIENTE {
        int id PK
        int receta_id FK
        int ingrediente_id FK
        double cantidad
        string unidad
        string nota
    }

    PASO {
        int id PK
        int receta_id FK
        int numero
        string descripcion
        string imagen
        int tiempo
    }

    RESENA {
        int id PK
        int receta_id FK
        int usuario_id FK
        int estrellas
        string comentario
        string foto
        datetime fecha
    }

    FAVORITO {
        int id PK
        int usuario_id FK
        int receta_id FK
        datetime fecha
    }

    SEGUIDOR_PLATILLO {
        int id PK
        int usuario_id FK
        int platillo_id FK
    }

    NOTIFICACION {
        int id PK
        int usuario_id FK
        string titulo
        string mensaje
        bool leida
        datetime fecha
    }

    HISTORIAL_PLATILLO {
        int id PK
        int platillo_id FK
        int usuario_id FK
        int version
        string cambios
        datetime fecha
    }

    HISTORIAL_RECETA {
        int id PK
        int receta_id FK
        int usuario_id FK
        int version
        string cambios
        datetime fecha
    }


``` Mermaid
erDiagram

    Usuario {
        int id PK
        string nombre
        string email
        string passwordHash
        string fotoPerfil
        bool emailVerificado
        datetime fechaRegistro
        bool activo
    }

    Categoria {
        int id PK
        string nombre
        string descripcion
    }

    Platillo {
        int id PK
        int usuarioId FK
        int categoriaId FK
        string nombre
        string descripcion
        string dificultad
        int tiempoPreparacion
        int porciones
        string imagen
        string slug
        int vistas
        bool eliminado
        datetime creadoEn
    }

    Receta {
        int id PK
        int platilloId FK
        string titulo
        string descripcion
        string consejos
        bool publicada
        bool borrador
        datetime fechaPublicacion
    }

    Ingrediente {
        int id PK
        string nombre
    }

    RecetaIngrediente {
        int id PK
        int recetaId FK
        int ingredienteId FK
        double cantidad
        string unidad
        string nota
    }

    Paso {
        int id PK
        int recetaId FK
        int numero
        string descripcion
        string imagen
        int tiempo
    }

    Resena {
        int id PK
        int recetaId FK
        int usuarioId FK
        int estrellas
        string comentario
        string foto
        datetime fecha
    }

    Favorito {
        int id PK
        int usuarioId FK
        int recetaId FK
        datetime fecha
    }

    SeguidorPlatillo {
        int id PK
        int usuarioId FK
        int platilloId FK
    }

    Notificacion {
        int id PK
        int usuarioId FK
        string titulo
        string mensaje
        bool leida
        datetime fecha
    }

    HistorialPlatillo {
        int id PK
        int platilloId FK
        int usuarioId FK
        int version
        string cambios
        datetime fecha
    }

    HistorialReceta {
        int id PK
        int recetaId FK
        int usuarioId FK
        int version
        string cambios
        datetime fecha
    }

    Usuario ||--o{ Platillo : crea

    Categoria ||--o{ Platillo : clasifica

    Platillo ||--|| Receta : posee

    Receta ||--o{ Paso : contiene

    Receta ||--o{ RecetaIngrediente : utiliza

    Ingrediente ||--o{ RecetaIngrediente : pertenece

    Usuario ||--o{ Resena : escribe

    Receta ||--o{ Resena : recibe

    Usuario ||--o{ Favorito : guarda

    Receta ||--o{ Favorito : favorito

    Usuario ||--o{ SeguidorPlatillo : sigue

    Platillo ||--o{ SeguidorPlatillo : tiene

    Usuario ||--o{ Notificacion : recibe

    Platillo ||--o{ HistorialPlatillo : versiones

    Receta ||--o{ HistorialReceta : versiones
    ``` Mermaid

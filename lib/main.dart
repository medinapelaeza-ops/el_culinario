import 'dart:async';
import 'package:flutter/material';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ============================================================================
// 1. MODELOS DE DATOS (Basados estrictamente en el Diagrama ER)
// ============================================================================

class Platillo extends Equatable {
  final int id;
  final int usuarioId;
  final int categoriaId;
  final String nombre;
  final String descripcion;
  final String dificultad;
  final int tiempoPreparacion;
  final int porciones;
  final String imagen;
  final String slug;
  final int vistas;
  final bool eliminado;
  final DateTime creadoEn;

  const Platillo({
    required this.id,
    required this.usuarioId,
    required this.categoriaId,
    required this.nombre,
    required this.descripcion,
    required this.dificultad,
    required this.tiempoPreparacion,
    required this.porciones,
    required this.imagen,
    required this.slug,
    this.vistas = 0,
    this.eliminado = false,
    required this.creadoEn,
  });

  Platillo copyWith({int? vistas, bool? eliminado}) {
    return Platillo(
      id: id,
      usuarioId: usuarioId,
      categoriaId: categoriaId,
      nombre: nombre,
      descripcion: descripcion,
      dificultad: dificultad,
      tiempoPreparacion: tiempoPreparacion,
      porciones: porciones,
      imagen: imagen,
      slug: slug,
      vistas: vistas ?? this.vistas,
      eliminado: eliminado ?? this.eliminado,
      creadoEn: creadoEn,
    );
  }

  @override
  List<Object?> get props => [
        id, usuarioId, categoriaId, nombre, descripcion, dificultad,
        tiempoPreparacion, porciones, imagen, slug, vistas, eliminado, creadoEn
      ];
}

class RecetaIngrediente extends Equatable {
  final int id;
  final String nombre;
  final double cantidad;
  final String unidad;
  final String? nota;

  const RecetaIngrediente({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    this.nota,
  });

  @override
  List<Object?> get props => [id, nombre, cantidad, unidad, nota];
}

class PasoReceta extends Equatable {
  final int id;
  final int numero;
  final String descripcion;
  final String? imagen;
  final int? tiempo;

  const PasoReceta({
    required this.id,
    required this.numero,
    required this.descripcion,
    this.imagen,
    this.tiempo,
  });

  @override
  List<Object?> get props => [id, numero, descripcion, imagen, tiempo];
}

class Receta extends Equatable {
  final int id;
  final int platilloId;
  final String titulo;
  final String descripcion;
  final String? consejos;
  final bool publicada;
  final List<RecetaIngrediente> ingredientes;
  final List<PasoReceta> pasos;

  const Receta({
    required this.id,
    required this.platilloId,
    required this.titulo,
    required this.descripcion,
    this.consejos,
    this.publicada = true,
    required this.ingredientes,
    required this.pasos,
  });

  @override
  List<Object?> get props => [id, platilloId, titulo, descripcion, consejos, publicada, ingredientes, pasos];
}

// ============================================================================
// 2. CAPA DE SERVICIO (Mock Data con Paginación de 12 elementos y Latencia)
// ============================================================================

class MockCulinarioService {
  // Generamos 24 elementos simulados en memoria
  final List<Platillo> _platillosDb = List.generate(24, (index) {
    return Platillo(
      id: index + 1,
      usuarioId: 101 + (index % 2),
      categoriaId: (index % 3) + 1, 
      nombre: index % 2 == 0 ? "Tacos al Pastor $index" : "Enchiladas Verdes $index",
      descripcion: "Una deliciosa receta tradicional mexicana preparada con ingredientes frescos del mercado local.",
      dificultad: index % 3 == 0 ? "Fácil" : (index % 3 == 1 ? "Media" : "Avanzado"),
      tiempoPreparacion: 20 + (index * 5),
      porciones: 2 + (index % 3),
      imagen: "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=500",
      slug: "platillo-slug-$index",
      vistas: 120 * index,
      creadoEn: DateTime.now().subtract(Duration(days: index)),
    );
  });

  final Map<int, Receta> _recetasDb = {
    1: const Receta(
      id: 501,
      platilloId: 1,
      titulo: "Tacos al Pastor Estilo CDMX",
      descripcion: "Pasos exactos para recrear el trompo casero tradicional en sartén.",
      consejos: "Dejar marinar la carne por al menos 4 horas para potenciar el sabor de los condimentos.",
      ingredientes: [
        RecetaIngrediente(id: 1, nombre: "Carne de cerdo", cantidad: 1.0, unidad: "kg", nota: "Fileteada delgada"),
        RecetaIngrediente(id: 2, nombre: "Pasta de Achiote", cantidad: 100, unidad: "g"),
        RecetaIngrediente(id: 3, nombre: "Piña", cantidad: 1, unidad: "pieza", nota: "Fresca en cubos"),
      ],
      pasos: [
        PasoReceta(id: 1, numero: 1, descripcion: "Licuar el achiote con chiles, vinagre y especias hasta homogeneizar.", tiempo: 10),
        PasoReceta(id: 2, numero: 2, descripcion: "Marinar la carne de cerdo capa por capa y refrigerar.", tiempo: 30),
      ],
    )
  };

  Future<List<Platillo>> fetchPlatillos({required int pagina, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 700)); // Simular retraso de red (RNF-9)
    Iterable<Platillo> filtrados = _platillosDb.where((p) => !p.eliminado);

    if (query != null && query.isNotEmpty) {
      filtrados = filtrados.where((p) => p.nombre.toLowerCase().contains(query.toLowerCase()));
    }

    const int tamanoPagina = 12;
    final int inicio = (pagina - 1) * tamanoPagina;
    if (inicio >= filtrados.length) return [];
    return filtrados.skip(inicio).take(tamanoPagina).toList();
  }

  Future<Receta?> getRecetaPorPlatillo(int platilloId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _recetasDb[platilloId] ?? Receta(
      id: 999,
      platilloId: platilloId,
      titulo: "Receta Genérica Autogenerada",
      descripcion: "Detalles técnicos de preparación simulados para el proyecto escolar.",
      ingredientes: const [RecetaIngrediente(id: 1, nombre: "Ingrediente de prueba", cantidad: 2, unidad: "piezas")],
      pasos: const [PasoReceta(id: 1, numero: 1, descripcion: "Mezclar los ingredientes y cocinar a fuego lento.")],
    );
  }
}

// ============================================================================
// 3. ARQUITECTURA DE ESTADOS (BLoC)
// ============================================================================

abstract class CatalogoEvent extends Equatable {
  const CatalogoEvent();
  @override
  List<Object?> get props => [];
}

class ObtenerPlatillosIniciales extends CatalogoEvent {
  final String? query;
  const ObtenerPlatillosIniciales({this.query});
  @override
  List<Object?> get props => [query];
}

class CargarSiguientePagina extends CatalogoEvent {}

enum CatalogoStatus { inicial, cargando, exito, error }

class CatalogoState extends Equatable {
  final CatalogoStatus status;
  final List<Platillo> platillos;
  final int paginaActual;
  final bool haLlegadoAlFinal;
  final String? query;

  const CatalogoState({
    this.status = CatalogoStatus.inicial,
    this.platillos = const [],
    this.paginaActual = 1,
    this.haLlegadoAlFinal = false,
    this.query,
  });

  CatalogoState copyWith({
    CatalogoStatus? status,
    List<Platillo>? platillos,
    int? paginaActual,
    bool? haLlegadoAlFinal,
    String? query,
  }) {
    return CatalogoState(
      status: status ?? this.status,
      platillos: platillos ?? this.platillos,
      paginaActual: paginaActual ?? this.paginaActual,
      haLlegadoAlFinal: haLlegadoAlFinal ?? this.haLlegadoAlFinal,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [status, platillos, paginaActual, haLlegadoAlFinal, query];
}

class CatalogoBloc extends Bloc<CatalogoEvent, CatalogoState> {
  final MockCulinarioService _service;

  CatalogoBloc({required MockCulinarioService service})
      : _service = service,
        super(const CatalogoState()) {
    on<ObtenerPlatillosIniciales>(_onObtenerPlatillosIniciales);
    on<CargarSiguientePagina>(_onCargarSiguientePagina);
  }

  Future<void> _onObtenerPlatillosIniciales(ObtenerPlatillosIniciales event, Emitter<CatalogoState> emit) async {
    emit(state.copyWith(status: CatalogoStatus.cargando, query: event.query, paginaActual: 1, haLlegadoAlFinal: false));
    try {
      final platillos = await _service.fetchPlatillos(pagina: 1, query: event.query);
      emit(state.copyWith(status: CatalogoStatus.exito, platillos: platillos, haLlegadoAlFinal: platillos.length < 12));
    } catch (_) {
      emit(state.copyWith(status: CatalogoStatus.error));
    }
  }

  Future<void> _onCargarSiguientePagina(CargarSiguientePagina event, Emitter<CatalogoState> emit) async {
    if (state.haLlegadoAlFinal || state.status == CatalogoStatus.cargando) return;
    final siguientePagina = state.paginaActual + 1;
    try {
      final nuevosPlatillos = await _service.fetchPlatillos(pagina: siguientePagina, query: state.query);
      if (nuevosPlatillos.isEmpty) {
        emit(state.copyWith(haLlegadoAlFinal: true));
      } else {
        emit(state.copyWith(
          status: CatalogoStatus.exito,
          platillos: List.from(state.platillos)..addAll(nuevosPlatillos),
          paginaActual: siguientePagina,
          haLlegadoAlFinal: nuevosPlatillos.length < 12,
        ));
      }
    } catch (_) {}
  }
}

// ============================================================================
// 4. PRESENTACIÓN / INTERFAZ GRÁFICA (UI FLUTTER)
// ============================================================================

void main() {
  runApp(const ElCulinarioApp());
}

class ElCulinarioApp extends StatelessWidget {
  const ElCulinarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mockService = MockCulinarioService();

    return RepositoryProvider.value(
      value: mockService,
      child: BlocProvider(
        create: (context) => CatalogoBloc(service: mockService)..add(const ObtenerPlatillosIniciales()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'El Culinario',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            useMaterial3: true,
          ),
          home: const CatalogoScreen(),
        ),
      ),
    );
  }
}

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<CatalogoBloc>().add(CargarSiguientePagina());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CatalogoBloc>().add(ObtenerPlatillosIniciales(query: query));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Culinario - Catálogo'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar platillo...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder<CatalogoBloc, CatalogoState>(
              builder: (context, state) {
                if (state.status == CatalogoStatus.cargando && state.platillos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.platillos.isEmpty) {
                  return const Center(child: Text('No se encontraron platillos.'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.haLlegadoAlFinal ? state.platillos.length : state.platillos.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.platillos.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final platillo = state.platillos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.restaurant, color: Colors.orange, size: 40),
                        title: Text(platillo.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${platillo.descripcion}\nDificultad: ${platillo.dificultad} • ${platillo.tiempoPreparacion} min'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleRecetaScreen(platillo: platillo),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetalleRecetaScreen extends StatelessWidget {
  final Platillo platillo;

  const DetalleRecetaScreen({super.key, required this.platillo});

  @override
  Widget build(BuildContext context) {
    final service = context.read<MockCulinarioService>();

    return Scaffold(
      appBar: AppBar(title: Text(platillo.nombre)),
      body: FutureBuilder<Receta?>(
        future: service.getRecetaPorPlatillo(platillo.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final receta = snapshot.data;
          if (receta == null) return const Center(child: Text('Receta no encontrada.'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(receta.titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown)),
                const SizedBox(height: 8),
                Text(receta.descripcion, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                const Divider(height: 30),
                const Text('Ingredientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...receta.ingredientes.map((ing) => Text('• ${ing.cantidad} ${ing.unidad} de ${ing.nombre} ${ing.nota ?? ""}')),
                const Divider(height: 30),
                const Text('Pasos de Preparación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...receta.pasos.map((paso) => ListTile(
                      leading: CircleAvatar(child: Text('${paso.numero}')),
                      title: Text(paso.descripcion),
                      subtitle: paso.tiempo != null ? Text('Tiempo estimado: ${paso.tiempo} min') : null,
                    )),
                if (receta.consejos != null) ...[
                  const Divider(height: 30),
                  const Text('Consejos del Chef', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                  Text(receta.consejos!),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}

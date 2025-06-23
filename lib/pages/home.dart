import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/services/plan_provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'dart:async';
import 'package:servicios_de_modelaje3d/pages/character_builder_page.dart';
import 'package:servicios_de_modelaje3d/pages/profile_page.dart';
import 'package:servicios_de_modelaje3d/pages/about_us_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<String> pageTitles = [
    'Inicio',
    'Arma tu personaje',
    'Sobre Nosotros',
  ];
  Timer? _carouselTimer;

  // Modelos destacados
  final List<Map<String, dynamic>> featuredModels = [
    {
      'title': 'Caballero Élite',
      'image': 'assets/images/Medieval.png',
      'description': 'Armadura detallada con efectos de batalla',
      'rating': 4.8,
    },
    {
      'title': 'Francotirador Futurista',
      'image': 'assets/images/sniper.png',
      'description': 'Diseño futurista con armas personalizables',
      'rating': 4.7,
    },
    {
      'title': 'Explorador Mágico',
      'image': 'assets/images/Adventura.png',
      'description': 'Personaje con habilidades mágicas y equipo de aventura',
      'rating': 4.9,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoCarousel();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    super.dispose();
  }

  void _startAutoCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF3A3C3D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          pageTitles[_selectedIndex],
          style: const TextStyle(color: Colors.white),
        ),
        actions:
            _selectedIndex == 0
                ? [
                  IconButton(
                    icon: const CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/FotoPerfil.jpeg',
                      ),
                      radius: 16,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                  ),
                ]
                : null,
      ),
      extendBody: true,
      body:
          [
            _buildHomeContent(planProvider),
            const CharacterBuilderPage(),
            const AboutUsPage(),
          ][_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFF600DD),
            unselectedItemColor: Colors.white70,
            onTap: _onItemTapped,
            backgroundColor: Colors.black.withOpacity(0.7),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                icon: Icon(Icons.build),
                label: 'Arma tu personaje',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Sobre Nosotros',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(PlanProvider planProvider) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Stack(
        children: [
          Container(
            height: 600,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Fondo_main.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                height: 300,
                child: ModelViewer(
                  src: 'assets/camaraman.glb',
                  alt: 'Modelo 3D de camaraman',
                  ar: false,
                  autoRotate: false,
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Modelos 3D',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Crea tu personaje con sus características únicas',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  setState(() => _selectedIndex = 1); // Cambiado a índice 1
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF600DD),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Cotizar'),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Nuestros Modelos Destacados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 380, // Reducimos la altura del contenedor del Swiper
                child: Swiper(
                  itemCount: featuredModels.length,
                  itemBuilder: (context, index) {
                    final model = featuredModels[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0, // Reducimos el padding vertical
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const RadialGradient(
                            colors: [Color(0xFF3c096c), Color(0xFF240046)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 20),
                              child: Image.asset(
                                // Eliminamos el ClipRRect
                                model['image'],
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          16, // Reducimos el tamaño de fuente
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size:
                                            16, // Reducimos el tamaño del icono
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        ' ${model['rating']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              12, // Reducimos el tamaño de fuente
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ), // Reducimos el espacio
                                  Text(
                                    model['description'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize:
                                          12, // Reducimos el tamaño de fuente
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '\$25',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              16, // Reducimos el tamaño de fuente
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      FloatingActionButton(
                                        mini: true,
                                        heroTag: 'fab_${model['title']}_$index',
                                        onPressed: () {
                                          setState(() => _selectedIndex = 1);
                                        },
                                        backgroundColor: const Color(
                                          0xFFd3d3d3,
                                        ),
                                        foregroundColor: const Color(
                                          0xFFF600DD,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                        ), // Reducimos el icono
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  viewportFraction: 0.8,
                  scale: 0.9,
                  autoplay: true,
                  autoplayDelay: 5000,
                  duration: 800,
                ),
              ),
              _buildHowItWorksSection(),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Cómo crear tu personaje 3D perfecto',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),

        // Tarjeta 1 - Presentación
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3c096c), Color(0xFF240046)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Servicios de Modelaje 3D Profesional',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Creamos personajes únicos para juegos, animación y más. Nuestros modelos son altamente personalizables y listos para usar en cualquier motor 3D.',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () => _selectedIndex = 1,
                          ); // Cambiado a índice 1
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF600DD),
                          minimumSize: const Size(120, 40),
                        ),
                        child: const Text('Conócenos'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/proceso1.png',
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tarjeta 2 - Proceso de creación (imagen a la izquierda)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3c096c), Color(0xFF240046)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/proceso2.png',
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personaliza cada detalle',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Elige género, estilo (fantasía, futurista, post-apocalíptico), armas, accesorios y más. Cada opción afecta el precio final.',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () => _selectedIndex = 1,
                          ); // Cambiado a índice 1
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF600DD),
                          minimumSize: const Size(120, 40),
                        ),
                        child: const Text('Comenzar'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tarjeta 3 - Resultado final
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3c096c), Color(0xFF240046)],
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recibe tu modelo 3D completo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Al finalizar el proceso, recibirás una cotización por email con el precio final. Si aceptas, crearemos tu modelo con todos los detalles solicitados.',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Formatos soportados: .fbx, .obj, .glb, .blend',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          setState(
                            () => _selectedIndex = 1,
                          ); // Cambiado a índice 1
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF600DD),
                          minimumSize: const Size(120, 40),
                        ),
                        child: const Text('Crear Personaje'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/proceso3.png',
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() => _selectedIndex = 1); // Cambiado a índice 1
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF600DD),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text(
            '¡Crea tu personaje ahora!',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

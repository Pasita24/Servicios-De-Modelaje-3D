import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/widgets/plan_card.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';
import 'package:servicios_de_modelaje3d/widgets/favorite_plan_card.dart';
import 'package:servicios_de_modelaje3d/pages/plan_form_page.dart';
import 'package:servicios_de_modelaje3d/services/plan_provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';
  final List<String> pageTitles = ['Inicio', 'Favoritos', 'Categorías'];

  final PageController _pageController = PageController(viewportFraction: 0.7);
  double _currentPage = 0;

  final List<String> categories = [
    'Todos',
    'Medieval',
    'Shooter',
    'Aventura',
    'Carreras',
    'Terror',
    'Fantasía',
    'Futurista',
    'Puzzle',
    'Deportes',
    'RPG',
    'Plataformas',
    'Simulación',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  List<PlanData> getFilteredPlans(List<PlanData> plans) {
    if (_selectedCategory == 'Todos') return plans;
    return plans.where((plan) => plan.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanProvider>(
      builder: (context, planProvider, child) {
        final filteredPlans = getFilteredPlans(planProvider.plans);
        return Scaffold(
          backgroundColor: const Color(0xFF3A3C3D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF3A3C3D),
            title: Text(pageTitles[_selectedIndex]),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlanFormPage()),
                  );
                },
              ),
            ],
          ),
          body:
              [
                _buildHomeContent(filteredPlans, planProvider),
                _buildFavorites(planProvider),
                _buildCategories(),
              ][_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFF600DD),
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoritos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categorías',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeContent(
    List<PlanData> filteredPlans,
    PlanProvider planProvider,
  ) {
    return SingleChildScrollView(
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
                  ar: true,
                  autoRotate: true,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cotización iniciada')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF600DD),
                ),
                child: const Text('Cotizar'),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isSelected
                                        ? const Color(0xFFF600DD)
                                        : Colors.grey.shade300,
                                foregroundColor:
                                    isSelected ? Colors.white : Colors.black,
                              ),
                              onPressed: () => _onCategorySelected(cat),
                              child: Text(cat),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 400,
                child:
                    filteredPlans.isEmpty
                        ? const Center(
                          child: Text(
                            'No hay modelos disponibles',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                        : PageView.builder(
                          controller: _pageController,
                          itemCount: filteredPlans.length,
                          itemBuilder: (context, index) {
                            final difference = (_currentPage - index).abs();
                            final scale = (1 - difference * 0.1).clamp(
                              0.9,
                              1.0,
                            );
                            final offset = (difference * 20).clamp(0.0, 40.0);
                            return Transform.translate(
                              offset: Offset(0, offset),
                              child: Transform.scale(
                                scale: scale,
                                child: PlanCard(
                                  title: filteredPlans[index].title,
                                  imagePath: filteredPlans[index].imagePath,
                                  description: filteredPlans[index].description,
                                  onAddFavorite:
                                      () => planProvider.addToFavorites(
                                        filteredPlans[index],
                                      ),
                                  index: index,
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites(PlanProvider planProvider) {
    if (planProvider.favorites.isEmpty) {
      return const Center(
        child: Text(
          'Aún no hay favoritos',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: planProvider.favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final plan = planProvider.favorites[index];
          return FavoritePlanCard(
            title: plan.title,
            imagePath: plan.imagePath,
            onBuy: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Agregado al carrito: ${plan.title}')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children:
          categories.map((cat) {
            return Card(
              child: ListTile(
                title: Text(cat),
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                    _selectedCategory = cat;
                  });
                },
              ),
            );
          }).toList(),
    );
  }
}

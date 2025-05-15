import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/widgets/plan_card.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';

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

  final List<PlanData> plans = [
    PlanData(
      category: 'Medieval',
      title: 'Medieval',
      imagePath: 'assets/images/Medieval.png',
      description: 'Para mundos medievales',
    ),
    PlanData(
      category: 'Shooter',
      title: 'Shooter',
      imagePath: 'assets/images/Medieval.png',
      description: 'Ideal para shooters llenos de acción',
    ),
    PlanData(
      category: 'Aventura',
      title: 'Aventura',
      imagePath: 'assets/images/Medieval.png',
      description: 'Perfecto para aventuras épicas',
    ),
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

  final List<PlanData> _favorites = [];
  void _addToFavorites(PlanData plan) {
    if (!_favorites.contains(plan)) {
      setState(() {
        _favorites.add(plan);
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  List<PlanData> get filteredPlans {
    if (_selectedCategory == 'Todos') return plans;
    return plans.where((plan) => plan.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildHomeContent(),
      _buildFavorites(),
      _buildCategories(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA78976),
        title: Text(widget.title),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFA78976),
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
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Categorías',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                    ? const Color(0xFFA78976)
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
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              itemCount: filteredPlans.length,
              itemBuilder: (context, index) {
                final difference = (_currentPage - index).abs();
                final scale = (1 - difference * 0.1).clamp(0.9, 1.0);
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
                          () => _addToFavorites(filteredPlans[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    if (_favorites.isEmpty) {
      return const Center(
        child: Text('Aún no hay favoritos', style: TextStyle(fontSize: 18)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: _favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final plan = _favorites[index];
          return PlanCard(
            title: plan.title,
            imagePath: plan.imagePath,
            description: plan.description,
            onAddFavorite: () {}, // no hace nada aquí
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

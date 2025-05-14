import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/pages/profile.dart';
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

  List<PlanData> get filteredPlans {
    if (_selectedCategory == 'Todos') return plans;
    return plans.where((plan) => plan.category == _selectedCategory).toList();
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);
  void _onCategorySelected(String category) =>
      setState(() => _selectedCategory = category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      body: Center(
        child:
            _selectedIndex == 0
                ? _buildHomeContent()
                : _selectedIndex == 1
                ? const Text(
                  'Index 1: Profile',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )
                : const Text(
                  'Index 2: School',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyprofilePage(title: 'Profile'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
                                    ? Colors.deepPurple
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
            height: 370,
            child: PageView.builder(
              controller: _pageController,
              itemCount: filteredPlans.length,
              itemBuilder: (context, index) {
                final scale = index == _currentPage.round() ? 1.0 : 0.9;
                final offset = index == _currentPage.round() ? 0.0 : 20.0;
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: Transform.scale(
                    scale: scale,
                    child: PlanCard(
                      title: filteredPlans[index].title,
                      imagePath: filteredPlans[index].imagePath,
                      description: filteredPlans[index].description,
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
}

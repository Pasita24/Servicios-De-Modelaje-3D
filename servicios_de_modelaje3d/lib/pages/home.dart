import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/pages/profile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

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

  final List<_PlanData> plans = [
    _PlanData(
      category: 'Medieval',
      title: 'Medieval',
      imagePath: 'assets/images/Medieval.png',
      description: 'Para mundos medievales',
    ),
  ];

  List<_PlanData> get filteredPlans {
    if (_selectedCategory == 'Todos') return plans;
    return plans.where((plan) => plan.category == _selectedCategory).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  List<Widget> get _widgetOptions => <Widget>[
    SingleChildScrollView(
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
          const SizedBox(height: 20),
          ...filteredPlans.map(
            (plan) => _PlanCard(
              title: plan.title,
              imagePath: plan.imagePath,
              description: plan.description,
            ),
          ),
        ],
      ),
    ),
    Text('Index 1: Profile', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
  ];

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
      body: Center(child: _widgetOptions[_selectedIndex]),
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
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;

  const _PlanCard({
    required this.title,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Card(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(imagePath),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' 4.3', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '\$25',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          // Acción al agregar al carrito
                        },
                        backgroundColor: Colors.deepPurple,
                        child: const Icon(Icons.add_shopping_cart),
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
  }
}

class _PlanData {
  final String category;
  final String title;
  final String imagePath;
  final String description;

  _PlanData({
    required this.category,
    required this.title,
    required this.imagePath,
    required this.description,
  });
}

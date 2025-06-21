import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class CharacterBuilderPage extends StatefulWidget {
  const CharacterBuilderPage({super.key});

  @override
  State<CharacterBuilderPage> createState() => _CharacterBuilderPageState();
}

class _CharacterBuilderPageState extends State<CharacterBuilderPage> {
  String? _selectedCategory;
  String? _selectedGender;
  String? _selectedStyle;
  String? _selectedWeapon;
  String? _selectedAccessory;

  // Precios base para cada categoría
  final Map<String, int> categoryPrices = {
    'Héroe': 100,
    'Villano': 120,
    'NPC': 80,
    'Criatura': 150,
    'Jefe': 200,
  };

  // Precios adicionales por características
  final Map<String, int> genderPrices = {
    'Masculino': 0,
    'Femenino': 0,
    'Otro': 0,
  };

  final Map<String, int> stylePrices = {
    'Fantasía': 30,
    'Futurista': 40,
    'Post-apocalíptico': 50,
    'Medieval': 20,
    'Moderno': 10,
  };

  final Map<String, int> weaponPrices = {
    'Espada': 25,
    'Arco': 20,
    'Pistola láser': 35,
    'Bastón mágico': 30,
    'Ninguna': 0,
  };

  final Map<String, int> accessoryPrices = {
    'Capa': 15,
    'Armadura pesada': 40,
    'Gafas de realidad aumentada': 25,
    'Amuleto mágico': 20,
    'Ninguno': 0,
  };

  final List<String> categories = [
    'Héroe',
    'Villano',
    'NPC',
    'Criatura',
    'Jefe',
  ];

  final List<String> genders = ['Masculino', 'Femenino', 'Otro'];

  final List<String> styles = [
    'Fantasía',
    'Futurista',
    'Post-apocalíptico',
    'Medieval',
    'Moderno',
  ];

  final List<String> weapons = [
    'Espada',
    'Arco',
    'Pistola láser',
    'Bastón mágico',
    'Ninguna',
  ];

  final List<String> accessories = [
    'Capa',
    'Armadura pesada',
    'Gafas de realidad aumentada',
    'Amuleto mágico',
    'Ninguno',
  ];

  // Función para calcular el precio total
  int _calculateTotalPrice() {
    int total = 0;

    if (_selectedCategory != null) {
      total += categoryPrices[_selectedCategory]!;
    }
    if (_selectedGender != null) {
      total += genderPrices[_selectedGender]!;
    }
    if (_selectedStyle != null) {
      total += stylePrices[_selectedStyle]!;
    }
    if (_selectedWeapon != null) {
      total += weaponPrices[_selectedWeapon]!;
    }
    if (_selectedAccessory != null) {
      total += accessoryPrices[_selectedAccessory]!;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3C3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A3C3D),
        title: const Text(
          'Constructor de Personajes 3D',
        ), // Título único y más descriptivo
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 300, child: _buildModelPreview()),
            const SizedBox(height: 20),

            _buildSelectionCard(
              title: 'Categoría',
              value: _selectedCategory,
              items: categories,
              onChanged: (value) {
                setState(() => _selectedCategory = value);
              },
            ),

            _buildSelectionCard(
              title: 'Género',
              value: _selectedGender,
              items: genders,
              onChanged: (value) {
                setState(() => _selectedGender = value);
              },
            ),

            _buildSelectionCard(
              title: 'Estilo',
              value: _selectedStyle,
              items: styles,
              onChanged: (value) {
                setState(() => _selectedStyle = value);
              },
            ),

            _buildSelectionCard(
              title: 'Arma',
              value: _selectedWeapon,
              items: weapons,
              onChanged: (value) {
                setState(() => _selectedWeapon = value);
              },
            ),

            _buildSelectionCard(
              title: 'Accesorio',
              value: _selectedAccessory,
              items: accessories,
              onChanged: (value) {
                setState(() => _selectedAccessory = value);
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed:
                  _selectedCategory != null
                      ? () => _showQuoteDialog(context)
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF600DD),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Generar Cotización',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildModelPreview() {
    return ModelViewer(
      src: 'assets/camaraman.glb',
      alt: 'Modelo 3D de personaje',
      ar: false,
      autoRotate: true,
      cameraControls: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF3c096c),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items:
                  items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: onChanged,
              hint: const Text('Selecciona una opción'),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuoteDialog(BuildContext context) {
    final totalPrice = _calculateTotalPrice();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF3c096c),
            title: const Text(
              'Cotización de tu personaje',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_selectedCategory != null)
                  _buildQuoteDetailItem(
                    'Categoría',
                    _selectedCategory!,
                    '\$${categoryPrices[_selectedCategory]}',
                  ),

                if (_selectedGender != null)
                  _buildQuoteDetailItem(
                    'Género',
                    _selectedGender!,
                    '\$${genderPrices[_selectedGender]}',
                  ),

                if (_selectedStyle != null)
                  _buildQuoteDetailItem(
                    'Estilo',
                    _selectedStyle!,
                    '\$${stylePrices[_selectedStyle]}',
                  ),

                if (_selectedWeapon != null)
                  _buildQuoteDetailItem(
                    'Arma',
                    _selectedWeapon!,
                    '\$${weaponPrices[_selectedWeapon]}',
                  ),

                if (_selectedAccessory != null)
                  _buildQuoteDetailItem(
                    'Accesorio',
                    _selectedAccessory!,
                    '\$${accessoryPrices[_selectedAccessory]}',
                  ),

                const SizedBox(height: 20),
                const Divider(color: Colors.white70),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$$totalPrice',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Atrás',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cotización enviada a tu correo'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF600DD),
                ),
                child: const Text('Enviar Cotización'),
              ),
            ],
          ),
    );
  }

  Widget _buildQuoteDetailItem(String title, String value, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title: $value', style: const TextStyle(color: Colors.white)),
          Text(price, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

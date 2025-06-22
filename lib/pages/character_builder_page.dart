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
  bool _hasWeapon = false;
  bool _hasAccessory = false;
  String? _otherDetails;

  // Mapa de modelos 3D por categoría
  final Map<String, String> categoryModels = {
    'Anime': 'assets/Anime.glb',
    'Boss': 'assets/Boss.glb',
    'LowPoly': 'assets/LowPoly.glb',
    'Medieval': 'assets/Medieval.glb',
    'Shooter': 'assets/Shooter.glb',
  };

  // Mapa de imágenes de fondo por categoría
  final Map<String, String> categoryBackgrounds = {
    'Anime': 'assets/images/AnimeImage.jpeg',
    'Boss': 'assets/images/BossImage.jpeg',
    'LowPoly': 'assets/images/LowPolyImage.jpeg',
    'Medieval': 'assets/images/MedievalImage.jpeg',
    'Shooter': 'assets/images/WarImage.jpeg',
  };

  // Precios base para cada categoría
  final Map<String, int> categoryPrices = {
    'Anime': 120,
    'Boss': 200,
    'LowPoly': 90,
    'Medieval': 150,
    'Shooter': 180,
  };

  // Precios adicionales por características
  final Map<String, int> genderPrices = {
    'Masculino': 0,
    'Femenino': 0,
    'Otro': 0,
  };

  final Map<String, int> stylePrices = {
    'Realista': 50,
    'Estilizado': 30,
    'Pixel Art': 40,
    'Cartoon': 20,
  };

  final int weaponPrice = 35;
  final int accessoryPrice = 25;

  final List<String> categories = [
    'Anime',
    'Boss',
    'LowPoly',
    'Medieval',
    'Shooter',
  ];

  final List<String> genders = ['Masculino', 'Femenino', 'Otro'];

  final List<String> styles = [
    'Realista',
    'Estilizado',
    'Pixel Art',
    'Cartoon',
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
    if (_hasWeapon) {
      total += weaponPrice;
    }
    if (_hasAccessory) {
      total += accessoryPrice;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage =
        _selectedCategory != null
            ? categoryBackgrounds[_selectedCategory]
            : 'assets/images/Fondo_main.jpeg';

    return Scaffold(
      backgroundColor: const Color(0xFF3A3C3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A3C3D),
        title: const Text('Constructor de Personajes 3D'),
      ),
      body: Stack(
        children: [
          // Fondo dinámico con efecto de opacidad
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Contenido principal
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 300,
                  child: _buildModelPreview(_selectedCategory),
                ),
                const SizedBox(height: 20),

                // Selectores de características
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

                _buildToggleCard(
                  title: '¿Incluir arma?',
                  value: _hasWeapon,
                  onChanged: (value) {
                    setState(() => _hasWeapon = value!);
                  },
                ),

                _buildToggleCard(
                  title: '¿Incluir accesorio?',
                  value: _hasAccessory,
                  onChanged: (value) {
                    setState(() => _hasAccessory = value!);
                  },
                ),

                _buildTextInputCard(
                  title: 'Otros detalles',
                  hint: 'Especificaciones adicionales',
                  onChanged: (value) {
                    setState(() => _otherDetails = value);
                  },
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 80,
                  ), // Añade este Padding alrededor del ElevatedButton
                  child: ElevatedButton(
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
                      elevation: 8,
                    ),
                    child: const Text(
                      'Generar Cotización',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelPreview(String? category) {
    final modelPath =
        category != null
            ? categoryModels[category] ?? 'assets/camaraman.glb'
            : 'assets/camaraman.glb';

    return FutureBuilder(
      future: DefaultAssetBundle.of(context).load(modelPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ModelViewer(
                src: modelPath,
                alt: 'Modelo 3D de personaje ${category ?? 'genérico'}',
                ar: false,
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        }
        return Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF600DD)),
              ),
            ),
          ),
        );
      },
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
      color: const Color(0xFF3c096c).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF3c096c).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFF600DD),
              activeTrackColor: Colors.purple[200],
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInputCard({
    required String title,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF3c096c).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: onChanged,
              maxLines: 3,
              style: const TextStyle(color: Colors.black87),
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
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3c096c).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cotización de tu personaje',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  _buildQuoteDetailItem(
                    'Arma',
                    _hasWeapon ? 'Sí' : 'No',
                    _hasWeapon ? '\$$weaponPrice' : '\$0',
                  ),

                  _buildQuoteDetailItem(
                    'Accesorio',
                    _hasAccessory ? 'Sí' : 'No',
                    _hasAccessory ? '\$$accessoryPrice' : '\$0',
                  ),

                  if (_otherDetails != null && _otherDetails!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Otros detalles:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _otherDetails!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$$totalPrice',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Atrás',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cotización enviada a tu correo'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF600DD),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Enviar Cotización',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildQuoteDetailItem(String title, String value, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

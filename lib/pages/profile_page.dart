import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/services/auth_provider.dart';
import 'package:servicios_de_modelaje3d/pages/login_page.dart';
import 'package:servicios_de_modelaje3d/services/email_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(
      text: authProvider.user?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showSurveyDialog() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    // Verificar si ya completó la encuesta
    if (user?.hasCompletedSurvey ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ya has completado la encuesta. ¡Gracias por tu feedback!',
          ),
        ),
      );
      return;
    }

    final surveyResponses = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const SurveyDialog3D(),
    );

    if (surveyResponses != null) {
      try {
        await EmailService.sendSurveyResults(
          userName: user?.name ?? user?.email ?? 'Usuario',
          userEmail: user?.email ?? 'No especificado',
          responses: surveyResponses,
        );

        // Actualizar el estado del usuario
        await authProvider.updateSurveyCompletion(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Gracias por tu feedback! Valoramos tu opinión'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar encuesta: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _editProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;
    if (currentUser == null) return;

    final newName = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Editar Perfil'),
            content: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _nameController.text),
                child: const Text('Guardar'),
              ),
            ],
          ),
    );

    if (newName != null && newName != currentUser.name) {
      await authProvider.updateProfile(name: newName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No hay usuario logueado')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF3A3C3D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                // Aquí puedes implementar la lógica para cambiar la foto de perfil
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    user.avatarPath != null
                        ? AssetImage(user.avatarPath!)
                        : const AssetImage('assets/images/FotoPerfil.jpeg'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user.name ?? user.email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (user.name != null) ...[
              const SizedBox(height: 5),
              Text(
                user.email,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
            const SizedBox(height: 30),

            _buildProfileSection(
              title: 'Información del Usuario',
              children: [
                _buildProfileItem(Icons.email, 'Correo:', user.email),
                _buildProfileItem(
                  Icons.date_range,
                  'Miembro desde:',
                  user.memberSince?.year.toString() ?? '2023',
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildProfileSection(
              title: 'Configuración',
              children: [
                _buildActionButton(
                  text: 'Editar Perfil',
                  icon: Icons.edit,
                  onPressed: _editProfile,
                ),
                _buildActionButton(
                  text: 'Cerrar Sesión',
                  icon: Icons.logout,
                  onPressed: () async {
                    await authProvider.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  color: Colors.red,
                ),
                // En el widget _buildActionButton para la encuesta, puedes añadir un indicador visual:
                _buildActionButton(
                  text: 'Responder Encuesta',
                  icon: Icons.assignment,
                  onPressed: _showSurveyDialog,
                  color:
                      (authProvider.user?.hasCompletedSurvey ?? false)
                          ? Colors.grey
                          : Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: const Color(0xFF3c096c).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF600DD)),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    VoidCallback? onPressed,
    Color color = const Color(0xFFF600DD),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class SurveyDialog3D extends StatefulWidget {
  const SurveyDialog3D({super.key});

  @override
  _SurveyDialog3DState createState() => _SurveyDialog3DState();
}

class _SurveyDialog3DState extends State<SurveyDialog3D> {
  int _currentSection = 0;
  final PageController _pageController = PageController();

  String _ageRange = '18-25';
  String _userType = 'Diseñador';

  Map<String, int> _ratings = {
    'usabilidad': 3,
    'modelos': 3,
    'ar': 3,
    'recomendacion': 3,
  };

  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Encuesta de Satisfacción - Modelaje 3D'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildDemographicsPage(),
            _buildEvaluationPage(),
            _buildCommentsPage(),
          ],
        ),
      ),
      actions: [
        if (_currentSection > 0)
          TextButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => _currentSection--);
            },
            child: const Text('Atrás'),
          ),

        ElevatedButton(
          onPressed: () {
            if (_currentSection < 2) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() => _currentSection++);
            } else {
              final responses = {
                'edad': _ageRange,
                'tipo_usuario': _userType,
                ..._ratings,
                'comentarios': _commentsController.text,
              };
              Navigator.pop(context, responses);
            }
          },
          child: Text(_currentSection == 2 ? 'Enviar' : 'Siguiente'),
        ),
      ],
    );
  }

  Widget _buildDemographicsPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Datos demográficos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          const Text(
            'Rango de edad:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _ageRange,
            isExpanded: true,
            items:
                const ['18-25', '26-35', '36-45', '46-55', '56+'].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (value) => setState(() => _ageRange = value!),
          ),

          const SizedBox(height: 20),
          const Text(
            '¿Cómo te describes?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _userType,
            isExpanded: true,
            items:
                const [
                  'Diseñador',
                  'Desarrollador de juegos',
                  'Artista 3D',
                  'Aficionado',
                  'Otro',
                ].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: (value) => setState(() => _userType = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Evaluación de la aplicación',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          _buildQuestion(
            '1. ¿Qué tan fácil es usar la aplicación para crear personajes 3D?',
            _ratings['usabilidad']!,
            (value) => setState(() => _ratings['usabilidad'] = value),
          ),

          _buildQuestion(
            '2. ¿Qué tan satisfecho/a estás con la variedad de modelos 3D disponibles?',
            _ratings['modelos']!,
            (value) => setState(() => _ratings['modelos'] = value),
          ),

          _buildQuestion(
            '3. ¿Qué tan útil te resulta la función de visualización AR de los modelos?',
            _ratings['ar']!,
            (value) => setState(() => _ratings['ar'] = value),
          ),

          _buildQuestion(
            '4. ¿Qué tan probable es que recomiendes esta aplicación a otros?',
            _ratings['recomendacion']!,
            (value) => setState(() => _ratings['recomendacion'] = value),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsPage() {
    return Column(
      children: [
        const Text(
          'Comentarios adicionales',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _commentsController,
          decoration: const InputDecoration(
            labelText: '¿Qué mejorarías o qué te gustó más?',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 20),
        const Text('¡Gracias por tu tiempo!'),
      ],
    );
  }

  Widget _buildQuestion(String question, int value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < value ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
                onPressed: () => onChanged(index + 1),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('1 - Muy malo', style: TextStyle(fontSize: 12)),
              Text('5 - Muy bueno', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

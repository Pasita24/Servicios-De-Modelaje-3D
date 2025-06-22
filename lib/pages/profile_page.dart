import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/services/database_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder(
          future: DatabaseHelper.instance.loginUser(
            'test@modelaje3d.com',
            'password123',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text(
                  'Error al cargar perfil',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final user = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/FotoPerfil.jpeg'),
                ),
                const SizedBox(height: 20),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Sección de información
                _buildProfileSection(
                  title: 'Información del Usuario',
                  children: [
                    _buildProfileItem(Icons.email, 'Correo:', user.email),
                    _buildProfileItem(
                      Icons.date_range,
                      'Miembro desde:',
                      'Junio 2023',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sección de estadísticas
                _buildProfileSection(
                  title: 'Mis Estadísticas',
                  children: [
                    _buildProfileItem(
                      Icons.construction,
                      'Personajes creados:',
                      '5',
                    ),
                    _buildProfileItem(Icons.favorite, 'Favoritos:', '3'),
                    _buildProfileItem(
                      Icons.shopping_cart,
                      'Compras realizadas:',
                      '2',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sección de configuración
                _buildProfileSection(
                  title: 'Configuración',
                  children: [
                    _buildActionButton(
                      text: 'Editar Perfil',
                      icon: Icons.edit,
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      text: 'Cambiar Contraseña',
                      icon: Icons.lock,
                      onPressed: () {},
                    ),
                    _buildActionButton(
                      text: 'Cerrar Sesión',
                      icon: Icons.logout,
                      onPressed: () {},
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            );
          },
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

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3C3D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección Hero con modelo 3D
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/Fondo_main.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: ModelViewer(
                        src: 'assets/Medieval.glb',
                        alt: 'Modelo 3D de caballero',
                        ar: false,
                        autoRotate: true,
                        cameraControls: true,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Título
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Sobre Nosotros',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.purple.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),

            // Tarjeta de información
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: const Color(0xFF2A2D2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Expertos en Modelaje 3D para Videojuegos',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Somos un equipo apasionado por la creación de personajes 3D de alta calidad para videojuegos. Con más de 5 años de experiencia en la industria, hemos trabajado en proyectos para estudios independientes y grandes desarrolladores.',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('500+', 'Modelos creados'),
                          _buildStatItem('50+', 'Clientes satisfechos'),
                          _buildStatItem('10+', 'Proyectos AAA'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Nuestro equipo
            Text(
              'Nuestro Equipo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildTeamMember(
                    'assets/images/FotoPerfil.jpeg',
                    'Líder de Arte 3D',
                    'Experto en modelado de personajes y texturizado',
                  ),
                  const SizedBox(width: 15),
                  _buildTeamMember(
                    'assets/images/FotoPerfil.jpeg',
                    'Animador',
                    'Especialista en rigging y animación',
                  ),
                  const SizedBox(width: 15),
                  _buildTeamMember(
                    'assets/images/FotoPerfil.jpeg',
                    'Diseñador',
                    'Creativo en concept art y diseño',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Nuestros valores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: const Color(0xFF3c096c).withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Nuestros Valores',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildValueItem(
                        Icons.brush,
                        'Creatividad',
                        'Innovamos en cada diseño',
                      ),
                      _buildValueItem(
                        Icons.verified,
                        'Calidad',
                        'Modelos optimizados y detallados',
                      ),
                      _buildValueItem(
                        Icons.handshake,
                        'Compromiso',
                        'Entregas a tiempo y soporte continuo',
                      ),
                      _buildValueItem(
                        Icons.videogame_asset,
                        'Pasión',
                        'Amamos los videojuegos tanto como tú',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Modelos destacados
            Text(
              'Algunos de Nuestros Trabajos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildWorkSample('assets/images/Medieval.png'),
                  const SizedBox(width: 10),
                  _buildWorkSample('assets/images/Shooter.png'),
                  const SizedBox(width: 10),
                  _buildWorkSample('assets/images/Adventura.png'),
                  const SizedBox(width: 10),
                  _buildWorkSample('assets/images/AnimeImage.jpeg'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Contacto
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3c096c).withOpacity(0.8),
                    const Color(0xFF240046).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '¿Listo para crear tu personaje?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Contáctanos y cuéntanos sobre tu proyecto',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF600DD),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Contactar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF600DD),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String image, String role, String description) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF2A2D2E),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFF600DD), size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkSample(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF600DD), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

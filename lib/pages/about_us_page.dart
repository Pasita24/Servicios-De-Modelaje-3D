import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3C3D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 100,
        ), // Añadido más padding inferior
        child: Column(
          children: [
            // Sección Hero con modelo 3D
            SizedBox(
              height: 280, // Reducido ligeramente
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
                      height: 220, // Reducido el tamaño
                      width: 220,
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
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ), // Ajustado padding
              child: Text(
                'Sobre Nosotros',
                style: TextStyle(
                  fontSize: 28, // Reducido tamaño
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
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ), // Reducido padding
              child: Card(
                color: const Color(0xFF2A2D2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(
                    15.0,
                  ), // Reducido padding interno
                  child: Column(
                    children: [
                      Text(
                        'Expertos en Modelaje 3D para Videojuegos',
                        style: TextStyle(
                          fontSize: 20, // Reducido tamaño
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12), // Reducido espacio
                      Text(
                        'Somos un equipo apasionado por la creación de personajes 3D de alta calidad para videojuegos. Con más de 5 años de experiencia en la industria, hemos trabajado en proyectos para estudios independientes y grandes desarrolladores.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ), // Reducido tamaño
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        // Cambiado Row por Wrap para mejor adaptación
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildStatItem('500+', 'Modelos'),
                          _buildStatItem('50+', 'Clientes'),
                          _buildStatItem('10+', 'Proyectos'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // Reducido espacio
            // Nuestro equipo
            Text(
              'Nuestro Equipo',
              style: TextStyle(
                fontSize: 22, // Reducido tamaño
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 160, // Reducido altura
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ), // Reducido padding
                children: [
                  _buildTeamMember(
                    'assets/images/FotoPerfil.jpeg',
                    'Líder de Arte',
                    'Modelado y texturas',
                  ),
                  const SizedBox(width: 12),
                  _buildTeamMember(
                    'assets/images/FotoPerfil2.jpeg',
                    'Animador',
                    'Rigging y animación',
                  ),
                  const SizedBox(width: 12),
                  _buildTeamMember(
                    'assets/images/FotoPerfil3.jpeg',
                    'Diseñador',
                    'Concept art',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Nuestros valores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                color: const Color(0xFF3c096c).withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        'Nuestros Valores',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildValueItem(
                        Icons.brush,
                        'Creatividad',
                        'Innovamos en cada diseño',
                      ),
                      _buildValueItem(
                        Icons.verified,
                        'Calidad',
                        'Modelos optimizados',
                      ),
                      _buildValueItem(
                        Icons.handshake,
                        'Compromiso',
                        'Entregas a tiempo',
                      ),
                      _buildValueItem(
                        Icons.videogame_asset,
                        'Pasión',
                        'Amamos los videojuegos',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Modelos destacados
            Text(
              'Nuestros Trabajos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 130, // Reducido altura
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  _buildWorkSample('assets/images/Medieval.png'),
                  const SizedBox(width: 8),
                  _buildWorkSample('assets/images/Shooter.png'),
                  const SizedBox(width: 8),
                  _buildWorkSample('assets/images/Adventura.png'),
                  const SizedBox(width: 8),
                  _buildWorkSample('assets/images/AnimeImage.jpeg'),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Contacto
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ), // Añadido margen horizontal
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15,
                ), // Añadido bordes redondeados
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contáctanos y cuéntanos sobre tu proyecto',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Acción de contacto
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF600DD),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      minimumSize: const Size(
                        150,
                        50,
                      ), // Tamaño mínimo garantizado
                    ),
                    child: const Text(
                      'Contactar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Espacio adicional al final
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF600DD),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String image, String role, String description) {
    return Container(
      width: 140, // Reducido ancho
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF2A2D2E),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 90, // Reducido altura
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
                    fontSize: 14, // Reducido tamaño
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ), // Reducido tamaño
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFFF600DD),
            size: 24,
          ), // Reducido tamaño
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Reducido tamaño
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ), // Reducido tamaño
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 120, // Reducido ancho
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFF600DD),
            width: 1.5,
          ), // Reducido grosor
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

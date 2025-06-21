import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/pages/plan_detail_page.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final String weapon;
  final String role;
  final VoidCallback onAddFavorite;
  final int index;

  const PlanCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.weapon,
    required this.role,
    required this.onAddFavorite,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final plan = PlanData(
      title: title,
      imagePath: imagePath,
      description: description,
      category: title,
      weapon: weapon,
      role: role,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlanDetailPage(plan: plan)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 320),
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Color(0xFF3c096c), Color(0xFF240046)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 15,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFd3d3d3),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(
                          ' 4.3',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFd3d3d3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFd3d3d3),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '\$25',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFd3d3d3),
                          ),
                        ),
                        FloatingActionButton(
                          mini: true,
                          heroTag: 'fab_${title}_$index',
                          onPressed: onAddFavorite,
                          backgroundColor: const Color(0xFFd3d3d3),
                          foregroundColor: const Color(0xFFF600DD),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(101, 0, 0, 0),
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child:
                        imagePath.isNotEmpty
                            ? Image.asset(imagePath, fit: BoxFit.cover)
                            : const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

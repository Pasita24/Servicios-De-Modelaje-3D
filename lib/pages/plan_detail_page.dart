import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';

class PlanDetailPage extends StatelessWidget {
  final PlanData plan;

  const PlanDetailPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF240046),
      appBar: AppBar(
        backgroundColor: const Color(0xFF240046),
        title: Text(plan.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.5,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE5CFC2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipOval(
                    child:
                        plan.imagePath.isEmpty
                            ? const Icon(Icons.image_not_supported, size: 100)
                            : Image.asset(plan.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFF9F4F1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF600DD),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Categoría: ${plan.category}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1C191C),
                    ),
                  ),
                  Text(
                    'Rol: ${plan.role}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1C191C),
                    ),
                  ),
                  Text(
                    'Arma: ${plan.weapon}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1C191C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    plan.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1C191C),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

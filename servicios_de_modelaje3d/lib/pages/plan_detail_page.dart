import 'package:flutter/material.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';

class PlanDetailPage extends StatelessWidget {
  final PlanData plan;

  const PlanDetailPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF908690), // fondo general
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F35FF),
        title: Text(plan.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.6,
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE5CFC2), // fondo del círculo
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipOval(
                    child: Image.asset(plan.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

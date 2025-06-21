import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicios_de_modelaje3d/models/plan_data.dart';
import 'package:servicios_de_modelaje3d/services/plan_provider.dart';

class PlanFormPage extends StatefulWidget {
  final PlanData? plan;

  const PlanFormPage({super.key, this.plan});

  @override
  State<PlanFormPage> createState() => _PlanFormPageState();
}

class _PlanFormPageState extends State<PlanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _weaponController = TextEditingController();
  final _roleController = TextEditingController();
  String _category = 'Medieval';
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    if (widget.plan != null) {
      _titleController.text = widget.plan!.title;
      _descriptionController.text = widget.plan!.description;
      _category = widget.plan!.category;
      _imagePath = widget.plan!.imagePath;
      _weaponController.text = widget.plan!.weapon;
      _roleController.text = widget.plan!.role;
    }
  }

  Future<void> _savePlan() async {
    if (_formKey.currentState!.validate()) {
      final plan = PlanData(
        id: widget.plan?.id,
        category: _category,
        title: _titleController.text,
        imagePath:
            _imagePath.isEmpty ? 'assets/images/Medieval.png' : _imagePath,
        description: _descriptionController.text,
        weapon:
            _weaponController.text.isEmpty
                ? 'Desconocido'
                : _weaponController.text,
        role:
            _roleController.text.isEmpty ? 'Desconocido' : _roleController.text,
      );
      final provider = Provider.of<PlanProvider>(context, listen: false);
      if (widget.plan == null) {
        await provider.addPlan(plan);
      } else {
        await provider.updatePlan(plan);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF240046),
      appBar: AppBar(
        title: Text(widget.plan == null ? 'Crear Modelo' : 'Editar Modelo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _category,
                  items:
                      ['Medieval', 'Shooter', 'Aventura'].map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                  onChanged: (value) => setState(() => _category = value!),
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator:
                      (value) => value!.isEmpty ? 'Ingrese un título' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Ingrese una descripción' : null,
                ),
                TextFormField(
                  controller: _weaponController,
                  decoration: const InputDecoration(
                    labelText: 'Arma',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Rol',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF600DD),
                  ),
                  child: Text(widget.plan == null ? 'Crear' : 'Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

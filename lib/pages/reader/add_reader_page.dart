import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projects/models/reader.dart';

import '../../database/service.dart';

@RoutePage()
class AddReaderPage extends StatefulWidget {
  const AddReaderPage({super.key});

  @override
  State<AddReaderPage> createState() => _AddReaderPageState();
}

class _AddReaderPageState extends State<AddReaderPage> {
  final _formKey = GlobalKey<FormState>();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _patronymicController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _patronymicController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _addReader() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      int id = await _generateReaderId();
      final reader = Reader(
        id: id,
        lastName: _lastNameController.text,
        firstName: _firstNameController.text,
        patronymic: _patronymicController.text,
        age: int.parse(_ageController.text),
        fine: 0,
      );

      try {
        await addReader(reader);
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (error) {
        _showErrorDialog('Ошибка при добавлении читателя: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<int> _generateReaderId() async {
    List<int> allIds = await getAllIdsReader();
    int id = allIds.isEmpty ? 1 : allIds.reduce((a, b) => a > b ? a : b) + 1;
    return id;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить читателя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Фамилия'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите фамилию';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _patronymicController,
                decoration: const InputDecoration(labelText: 'Отчество'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите отчество';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Возраст'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите возраст';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 120) {
                    return 'Пожалуйста, введите корректный возраст (1-120)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _addReader,
                      child: const Text('Добавить читателя'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

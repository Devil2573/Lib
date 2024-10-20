import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projects/models/book.dart';

import '../../database/service.dart';

@RoutePage()
class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _ageController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _authorController.dispose();
    _titleController.dispose();
    _genreController.dispose();
    _ageController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addBook() async {
    if (_formKey.currentState!.validate()) {
      int id = 0;
      List<int> allIds = await getAllIdsBook();
      if (allIds.isEmpty) {
        id = 1;
      } else {
        for (int i = 1; i <= allIds.length + 1; i++) {
          if (!allIds.contains(i)) {
            id = i;
            break;
          }
        }
      }

      final book = Book(
        id: id,
        author: _authorController.text,
        number: int.parse(_numberController.text),
        title: _titleController.text,
        genre: _genreController.text,
        ageLimit: int.parse(_ageController.text),
        availableCopies: int.parse(_quantityController.text),
      );
      await addBook(book);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить книгу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Номер книги'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите номер';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректое значение';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Автор'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите автора';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Жанр'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите жанр';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration:
                    const InputDecoration(labelText: 'Возраст читателя'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите возраст';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректный возраст';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Количество книг'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество книг';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректное количество';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text('Добавить книгу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projects/design/colors.dart';

import '../../models/book.dart';

@RoutePage()
class BookInfoPage extends StatefulWidget {
  final Book book;

  const BookInfoPage({super.key, required this.book});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о книге'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Автор:', widget.book.author),
        _buildInfoRow('Название:', widget.book.title),
        _buildInfoRow('Жанр:', widget.book.genre),
        _buildInfoRow('Возраст:', '${widget.book.ageLimit} лет'),
        _buildInfoRow('Кол-во книг:', '${widget.book.availableCopies}'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

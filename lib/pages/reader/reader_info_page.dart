import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projects/database/service.dart';
import 'package:projects/models/book.dart';
import 'package:projects/models/reader.dart';

import '../../design/colors.dart';

@RoutePage()
class ReaderInfoPage extends StatefulWidget {
  final Reader reader;

  const ReaderInfoPage({super.key, required this.reader});

  @override
  State<ReaderInfoPage> createState() => _ReaderInfoPageState();
}

class _ReaderInfoPageState extends State<ReaderInfoPage> {
  late Future<List<Book>> _borrowedBooksFuture;
  late Reader _reader;

  @override
  void initState() {
    super.initState();
    _reader = widget.reader;
    _borrowedBooksFuture = _getBorrowedBooks();
  }

  Future<List<Book>> _getBorrowedBooks() async {
    return await getBorrowedBooksByReaderId(_reader.id);
  }

  Future<void> _refreshReaderData() async {
    final updatedReader = await getReaderById(_reader.id);
    setState(() {
      _reader = updatedReader;
      _borrowedBooksFuture = _getBorrowedBooks();
    });
  }

  Future<void> _returnBook(int bookId) async {
    await returnBook(_reader.id, bookId);
    await _refreshReaderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о читателе'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshReaderData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildReaderInfo(),
            const SizedBox(height: 20),
            const Text('Взятые книги:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _borrowedBooksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Нет взятых книг'));
                  } else {
                    final books = snapshot.data!;
                    return ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return FutureBuilder<DateTime?>(
                          future: getDueDate(_reader.id, book.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Ошибка: ${snapshot.error}'));
                            } else if (!snapshot.hasData) {
                              return const Center(
                                  child: Text('Дата возврата не найдена'));
                            } else {
                              final dueDate = snapshot.data!;
                              final isOverdue =
                                  dueDate.isBefore(DateTime.now());
                              return ListTile(
                                leading: const Icon(Icons.book, size: 40),
                                title: Text(book.title,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: secondaryVariantColor)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoBookRow('Автор:', book.author),
                                    _buildInfoBookRow('Жанр:', book.genre),
                                    Row(
                                      children: [
                                        const Text(
                                          'Дата возврата:',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Text(
                                            dueDate.toString(),
                                            style: TextStyle(
                                              color:
                                                  isOverdue ? Colors.red : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Фамилия:', _reader.lastName),
        _buildInfoRow('Имя:', _reader.firstName),
        _buildInfoRow('Отчество:', _reader.patronymic),
        _buildInfoRow('Возраст:', _reader.age.toString()),
        _buildInfoRow('Штраф:', '${_reader.fine} руб.'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 32),
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
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBookRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

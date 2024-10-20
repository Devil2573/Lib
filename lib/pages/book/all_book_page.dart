import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects/database/service.dart';
import 'package:projects/models/book.dart';
import 'package:projects/pages/book/book_list_item.dart';
import 'package:projects/routes/app_router.dart';

import '../../design/colors.dart';
import '../../design/dimensions.dart';

@RoutePage()
class AllBookPage extends StatefulWidget {
  const AllBookPage({super.key});

  @override
  State<AllBookPage> createState() => _AllBookPageState();
}

class _AllBookPageState extends State<AllBookPage> {
  late Future<List<Book>> _booksFuture;
  String _sortOrder = 'author';
  bool _isAuthorAsc = true;
  bool _isTitleAsc = true;

  @override
  void initState() {
    super.initState();
    _booksFuture = _getBooks();
  }

  Future<List<Book>> _getBooks() async {
    return await getBooks();
  }

  Future<void> _showReturnDialog(int state) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: state == 0 ?
          const Text('Удаление книги')
          :const Text('Добавление книги'),
          content: state == 0 ?
          const Text('Книга успешно удалена.')
          :const Text('Книга успешно добавлена.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text(
          'Список книг',
          style: TextStyle(
            color: primaryColor,
            fontSize: fontSize16 + 8,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
        actions: [
          IconButton(
            onPressed: () => AutoRouter.of(context)
                .push(const AddBookRoute())
                .then((result) {
              if (result == true) {
                _showReturnDialog(1);
                setState(() {
                  _booksFuture = _getBooks();
                });
              }
            }),
            icon: const Icon(Icons.add_box_outlined, size: 30),
          )
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSortButton(
                    label: 'по автору',
                    isAsc: _isAuthorAsc,
                    onPressed: () {
                      setState(() {
                        _sortOrder = 'author';
                        _isAuthorAsc = !_isAuthorAsc;
                        _booksFuture = _getBooks();
                      });
                    },
                  ),
                  // Сортировка по названию
                  _buildSortButton(
                    label: 'по названию',
                    isAsc: _isTitleAsc,
                    onPressed: () {
                      setState(() {
                        _sortOrder = 'title';
                        _isTitleAsc = !_isTitleAsc;
                        _booksFuture = _getBooks();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Нет книг'));
                  } else {
                    List<Book> books = snapshot.data!;

                    if (_sortOrder == 'author') {
                      books.sort((a, b) => _isAuthorAsc
                          ? a.author.compareTo(b.author)
                          : b.author.compareTo(a.author));
                    } else if (_sortOrder == 'title') {
                      books.sort((a, b) => _isTitleAsc
                          ? a.title.compareTo(b.title)
                          : b.title.compareTo(a.title));
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        itemCount: books.length,
                        padding: const EdgeInsets.only(top: 10.0),
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return BookListItem(
                            book: books[index],
                            onDeleteSuccess: () {
                              _showReturnDialog(0);
                              setState(() {
                                _booksFuture = _getBooks();
                              });
                            },
                          );
                        },
                      ),
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

  Widget _buildSortButton({
    required String label,
    required bool isAsc,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        backgroundColor: surfaceColor,
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      icon: Icon(
        isAsc ? Icons.arrow_upward : Icons.arrow_downward,
        size: 20,
        color: primaryColor,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: fontSize16,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }
}

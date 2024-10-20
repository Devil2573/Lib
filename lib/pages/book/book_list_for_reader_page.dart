import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects/database/service.dart';
import 'package:projects/models/book.dart';
import 'package:projects/models/reader.dart';

import '../../design/colors.dart';
import '../../design/dimensions.dart';

@RoutePage()
class BookListPageForReader extends StatefulWidget {
  final int currentReader;

  const BookListPageForReader({super.key, required this.currentReader});

  @override
  State<BookListPageForReader> createState() => _BookListPageForReaderState();
}

class _BookListPageForReaderState extends State<BookListPageForReader> {
  late Future<List<Book>> _booksFuture;
  late Future<List<Book>> _readerBooksFuture;
  late Reader _reader;
  List<Reader> _readers = [];
  int? _selectedReaderId = 0;
  String _sortOrder = 'author';
  bool _isAuthorAsc = true;
  bool _isTitleAsc = true;
  bool _isLoading = true;
  List<String> _selectedGenres = [];
  List<String> _selectedAuthors = [];

  @override
  void initState() {
    super.initState();
    _selectedReaderId = widget.currentReader;
    print("before");
    _loadReaders();
    print("after");
    _booksFuture = _getBooks();
    _readerBooksFuture = _getReaderBooks(_selectedReaderId!);
  }

  Future<void> _loadReaders() async {
    try {
      final readers = await getReaders();
      print("method");
      for (var reader in readers) {
        print(reader.toMap());
      }
      setState(() {
        _readers = readers;
        _reader =
            _readers.firstWhere((reader) => reader.id == _selectedReaderId);
        _isLoading = false;
      });
      print("Reader data after setState: ${_reader.toMap()}");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading readers: $e");
    } finally {
      print("i dont know");
      for (var reader in _readers) {
        print(reader.toMap());
      }
      print("FINE FINE");
      print(_reader.fine);
    }
  }

  Future<List<Book>> _getBooks() async {
    if (_selectedReaderId != null) {
      return await getRecommendedBooksForReader(_selectedReaderId!,
          genre: _selectedGenres, author: _selectedAuthors);
    }
    return await getBooks();
  }

  Future<Reader> _getReader() async {
    return await getReaderById(_selectedReaderId!);
  }

  Future<List<Book>> _getReaderBooks(int bookId) async {
    return await getBorrowedBooksByReaderId(_selectedReaderId!);
  }

  Future<bool> isBookBorrowedByReader(int bookId) async {
    final borrowedBooks = await _readerBooksFuture;

    return borrowedBooks.any((book) => book.id == bookId);
  }

  Future<void> _borrowBook(int bookId) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      await borrowBook(_selectedReaderId!, bookId, picked);
      setState(() {
        _booksFuture = _getBooks();
        _readerBooksFuture = _getReaderBooks(_selectedReaderId!);
      });
    }
  }
  Future<void> _returnBook(int selectedReaderId, int book_id) async {
    await returnBook(_selectedReaderId!, book_id);
    setState(() {
      _booksFuture = _getBooks();
      _readerBooksFuture = _getReaderBooks(_selectedReaderId!);
    });
  }

  Future<void> _showErrorDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: const Text('Нет в наличии'),
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

  Future<void> _showReturnDialog(int fine) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Возврат книги'),
          content: fine > 0
              ? Text('Книга успешно возвращена. Штраф: $fine за просрочку.')
              : const Text('Книга успешно возвращена.'),
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

  Future<void> _updateBooks() async {
    setState(() {
      _booksFuture = _getBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
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
        ),
        body: Container(
          color: backgroundColor,
          child: Column(
            children: [
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 150,
                        child: Text(
                          '${_reader.lastName} ${_reader.firstName}\n ${_reader.patronymic}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: fontSize16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Выберите жанры'),
                    FutureBuilder<List<String>>(
                      future: getAvailableGenres(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Ошибка загрузки жанров: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('Нет доступных жанров');
                        } else {
                          final genres = snapshot.data!;
                          return Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: _selectedGenres.isNotEmpty
                                    ? _selectedGenres.first
                                    : null,
                                items: genres.map((genre) {
                                  return DropdownMenuItem<String>(
                                    value: genre,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value:
                                              _selectedGenres.contains(genre),
                                          onChanged: (isSelected) {
                                            setState(() {
                                              if (isSelected!) {
                                                _selectedGenres.add(genre);
                                              } else {
                                                _selectedGenres.remove(genre);
                                              }
                                              _updateBooks();
                                            });
                                          },
                                        ),
                                        Text(genre),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (selectedGenre) {},
                                hint: const Text('Выберите жанр'),
                                isExpanded: true,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Выберите авторов'),
                    FutureBuilder<List<String>>(
                      future: getAvailableAuthors(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Ошибка загрузки авторов: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('Нет доступных авторов');
                        } else {
                          final authors = snapshot.data!;
                          return Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: _selectedAuthors.isNotEmpty
                                    ? _selectedAuthors.first
                                    : null,
                                items: authors.map((author) {
                                  return DropdownMenuItem<String>(
                                    value: author,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value:
                                              _selectedAuthors.contains(author),
                                          onChanged: (isSelected) {
                                            setState(() {
                                              if (isSelected!) {
                                                _selectedAuthors.add(author);
                                              } else {
                                                _selectedAuthors.remove(author);
                                              }
                                              _updateBooks();
                                            });
                                          },
                                        ),
                                        Text(author),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (selectedAuthor) {},
                                hint: const Text('Выберите автора'),
                                isExpanded: true,
                              ),
                              // ElevatedButton(
                              //   onPressed: _updateBooks,
                              //   child: const Text('Обновить книги'),
                              // ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Ошибка: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('Нет доступных книг');
                    } else {
                      final books = snapshot.data!;
                      if (_sortOrder == 'author') {
                        books.sort((a, b) => _isAuthorAsc
                            ? a.author.compareTo(b.author)
                            : b.author.compareTo(a.author));
                      } else if (_sortOrder == 'title') {
                        books.sort((a, b) => _isTitleAsc
                            ? a.title.compareTo(b.title)
                            : b.title.compareTo(a.title));
                      }
                      return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return FutureBuilder<bool>(
                            future: isBookBorrowedByReader(book.id),
                            builder: (context, borrowedSnapshot) {
                              if (borrowedSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (borrowedSnapshot.hasError) {
                                return Text(
                                    'Ошибка: ${borrowedSnapshot.error}');
                              } else {
                                final isBorrowed = borrowedSnapshot.data!;
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: surfaceColor,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 16.0),
                                    title: Text(
                                      book.title,
                                      style: const TextStyle(
                                        fontSize: fontSize16,
                                        fontWeight: FontWeight.bold,
                                        color: secondColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Автор: ${book.author}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: primaryColor,
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () async {
                                        if (isBorrowed) {
                                          int fine = await calculateFine(
                                              _selectedReaderId!, book.id);
                                          await _returnBook(
                                              _selectedReaderId!, book.id);
                                          await updateReaderFine(
                                              _selectedReaderId!, fine);
                                          setState(() {
                                            _booksFuture = _getBooks();
                                            _readerBooksFuture =
                                                _getReaderBooks(
                                                    _selectedReaderId!);
                                          });
                                          _showReturnDialog(fine);
                                        } else {
                                          if (book.availableCopies > 0) {
                                            await _borrowBook(book.id);
                                            setState(() {
                                              _booksFuture = _getBooks();
                                              _readerBooksFuture =
                                                  _getReaderBooks(
                                                      _selectedReaderId!);
                                            });
                                          } else {
                                            _showErrorDialog(context);
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        isBorrowed ? Colors.red : primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        isBorrowed ? 'Вернуть' : 'Выдать',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
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

import 'package:projects/database/init/databaseHelper.dart';
import 'package:projects/models/borrowedbook.dart';

import '../models/book.dart';
import '../models/reader.dart';

Future<void> addBook(Book book) async {
  final db = await DatabaseHelper().database;
  await db.insert('books', book.toMap());
}

Future<void> deleteBook(int bookId) async {
  final db = await DatabaseHelper().database;
  await db.delete('books', where: 'id = ?', whereArgs: [bookId]);
}

Future<void> addReader(Reader reader) async {
  final db = await DatabaseHelper().database;
  await db.insert('readers', reader.toMap());
}

Future<void> deleteReader(int readerId) async {
  final db = await DatabaseHelper().database;
  await db.delete('readers', where: 'id = ?', whereArgs: [readerId]);
}

Future<int> updateReaderFine(int readerId, int fine) async {
  final db = await DatabaseHelper().database;

  List<Map<String, dynamic>> results = await db.query(
    'readers',
    where: 'id = ?',
    whereArgs: [readerId],
  );

  if (results.isEmpty) {
    throw Exception('Читатель с id $readerId не найден');
  }

  Reader reader = Reader.fromMap(results.first);
  reader.fine += fine;
  // print("Текущий штраф читателя: ${reader.fine}");
  // print(reader.toMap());

  int count = await db.rawUpdate(
    'UPDATE readers SET fine = ? WHERE id = ?',
    [reader.fine, readerId],
  );

  if (count == 0) {
    throw Exception('Ошибка при обновлении штрафа для читателя с id $readerId');
  } else {
    print('Штраф успешно обновлен для читателя с id $readerId');
    return 1;
  }
}

Future<int> getReaderFine(int readerId) async {
  final db = await DatabaseHelper().database;

  List<Map<String, dynamic>> results = await db.query(
    'readers',
    where: 'id = ?',
    whereArgs: [readerId],
  );

  if (results.isEmpty) {
    throw Exception('Читатель с id $readerId не найден');
  }

  Reader reader = Reader.fromMap(results.first);
  return reader.fine;
}

Future<void> printReaders() async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> data = await db.query('readers');

  print('Все записи в таблице readers:');
  for (var row in data) {
    final reader = Reader.fromMap(row);
    print(row);
  }
}

Future<List<Reader>> getReaders() async {
  print("get readers");
  final db = await DatabaseHelper().database;
  // final maps = await db.query('readers');
  final List<Map<String, dynamic>> maps = await db.query('readers');
  for (var row in maps) {
    print("reader is");
    print(row);
    final reader = Reader.fromMap(row);
    print(reader.toMap());
    print("end");
  }
  return List.generate(maps.length, (i) {
    return Reader.fromMap(maps[i]);
  });
}

Future<void> printReaderFine(int readerId) async {
  final db = await DatabaseHelper().database;

  final readerMap =
      await db.query('readers', where: 'id = ?', whereArgs: [readerId]);
  if (readerMap.isEmpty) {
    throw Exception('Читатель не найден');
  }

  final Reader reader = Reader.fromMap(readerMap.first);
  print("READER FINE READER FINE");
  print(reader.fine);
}

Future<void> borrowBook(int readerId, int bookId, DateTime dueDate) async {
  final db = await DatabaseHelper().database;
  final bookMaps =
      await db.query('books', where: 'id = ?', whereArgs: [bookId]);

  if (bookMaps.isNotEmpty) {
    final book = Book.fromMap(bookMaps.first);
    if (book.availableCopies > 0) {
      await db.insert('borrowedBook', {
        'readerId': readerId,
        'bookId': bookId,
        'dueDate': dueDate.toIso8601String(),
      });

      await db.update(
          'books',
          {
            'availableCopies': book.availableCopies - 1,
          },
          where: 'id = ?',
          whereArgs: [bookId]);
    } else {
      throw Exception('Book is not available');
    }
  } else {
    throw Exception('Book not found');
  }
}

Future<List<Book>> getBorrowedBooksByReaderId(int readerId) async {
  final db = await DatabaseHelper().database;

  final List<Map<String, dynamic>> borrowedBookMaps = await db.rawQuery('''
    SELECT books.*
    FROM borrowedBook
    JOIN books ON borrowedBook.bookId = books.id
    WHERE borrowedBook.readerId = ?
  ''', [readerId]);

  return List.generate(borrowedBookMaps.length, (i) {
    return Book.fromMap(borrowedBookMaps[i]);
  });
}

Future<DateTime?> getDueDate(int readerId, int bookId) async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> maps = await db.query(
    'borrowedBook',
    columns: ['dueDate'],
    where: 'readerId = ? AND bookId = ?',
    whereArgs: [readerId, bookId],
  );

  if (maps.isNotEmpty) {
    return DateTime.parse(maps.first['dueDate']);
  }

  return null;
}

Future<int> calculateFine(int readerId, int bookId) async {
  final borrowDate = await getDueDate(readerId, bookId);
  final returnDate = DateTime.now();
  // print("DATE DATE DATE");
  // print(borrowDate);

  if (borrowDate != null) {
    final difference = returnDate.difference(borrowDate).inDays;
    if (difference > 0) {
      // print("FINE FINE FINE");
      // print(difference * 20);
      return difference * 20;
    }
  }
  return 0;
}

Future<List<Book>> getBorrowedBooksByBookId(int bookId) async {
  final db = await DatabaseHelper().database;

  final List<Map<String, dynamic>> borrowedBookMaps = await db.rawQuery('''
    SELECT books.*
    FROM borrowedBook
    JOIN books ON borrowedBook.bookId = books.id
    WHERE borrowedBook.bookId = ?
  ''', [bookId]);

  return List.generate(borrowedBookMaps.length, (i) {
    return Book.fromMap(borrowedBookMaps[i]);
  });
}

Future<int> returnBook(int readerId, int bookId) async {
  final db = await DatabaseHelper().database;
  final borrowedMaps = await db.query('borrowedBook',
      where: 'readerId = ? AND bookId = ?', whereArgs: [readerId, bookId]);

  if (borrowedMaps.isNotEmpty) {
    final borrowedBook = BorrowedBook.fromMap(borrowedMaps.first);
    final dueDate = DateTime.parse(borrowedBook.dueDate);
    final DateTime now = DateTime.now();
    final int overdueDays = now.difference(dueDate).inDays;

    int fine = overdueDays > 0 ? overdueDays * 10 : 0; // 1 unit per day overdue

    await db.delete('borrowedBook',
        where: 'readerId = ? AND bookId = ?', whereArgs: [readerId, bookId]);

    final bookMaps =
        await db.query('books', where: 'id = ?', whereArgs: [bookId]);
    if (bookMaps.isNotEmpty) {
      final book = Book.fromMap(bookMaps.first);
      await db.update(
          'books',
          {
            'availableCopies': book.availableCopies + 1,
          },
          where: 'id = ?',
          whereArgs: [bookId]);
    }

    return fine;
  } else {
    throw Exception('Book not borrowed by this reader');
  }
}

Future<List<Book>> getBooks() async {
  final db = await DatabaseHelper().database;
  final maps = await db.query('books');
  return List.generate(maps.length, (i) {
    return Book.fromMap(maps[i]);
  });
}

Future<List<int>> getAllIdsReader() async {
  final db = await DatabaseHelper().database;
  final maps = await db.query('readers', columns: ['id']);
  return List<int>.generate(maps.length, (i) {
    return maps[i]['id'] as int;
  });
}

Future<List<int>> getAllIdsBook() async {
  final db = await DatabaseHelper().database;
  final maps = await db.query('books', columns: ['id']);
  return List<int>.generate(maps.length, (i) {
    return maps[i]['id'] as int;
  });
}

Future<List<Book>> getRecommendedBooksForReader(int readerId,
    {List<String>? genre, List<String>? author}) async {
  final db = await DatabaseHelper().database;

  final readerMap =
      await db.query('readers', where: 'id = ?', whereArgs: [readerId]);
  if (readerMap.isEmpty) {
    throw Exception('Читатель не найден');
  }

  final Reader reader = Reader.fromMap(readerMap.first);

  final whereClause = [];
  final whereArgs = [];

  if (genre != null && genre.isNotEmpty) {
    final genrePlaceholders = List.filled(genre.length, '?').join(', ');
    whereClause.add('genre IN ($genrePlaceholders)');
    whereArgs.addAll(genre);
  }

  if (author != null && author.isNotEmpty) {
    final authorPlaceholders = List.filled(author.length, '?').join(', ');
    whereClause.add('author IN ($authorPlaceholders)');
    whereArgs.addAll(author);
  }

  whereClause.add('ageLimit <= ?');
  whereArgs.add(reader.age);

  final booksMap = await db.query(
    'books',
    where: whereClause.join(' AND '),
    whereArgs: whereArgs,
  );

  return booksMap.map((bookMap) => Book.fromMap(bookMap)).toList();
}

Future<List<String>> getAvailableGenres() async {
  final db = await DatabaseHelper().database;

  final genresMap = await db
      .rawQuery('SELECT DISTINCT genre FROM books WHERE genre IS NOT NULL');
  List<String> genres =
      genresMap.map((row) => row['genre'].toString()).toList();
  genres = ['Автор1', 'Автор2', 'Автор3'];

  return genresMap.map((row) => row['genre'].toString()).toList();
}

Future<List<String>> getAvailableAuthors() async {
  final db = await DatabaseHelper().database;

  final authorsMap = await db
      .rawQuery('SELECT DISTINCT author FROM books WHERE author IS NOT NULL');

  return authorsMap.map((row) => row['author'].toString()).toList();
}

Future<Reader> getReaderById(int readerId) async {
  final db = await DatabaseHelper().database;

  final readerMap =
      await db.query('readers', where: 'id = ?', whereArgs: [readerId]);
  if (readerMap.isEmpty) {
    throw Exception('Читатель не найден');
  }

  final Reader reader = Reader.fromMap(readerMap.first);

  return reader;
}

Future<List<Book>> getBooksSortedByAuthor() async {
  final db = await DatabaseHelper().database;
  final booksMap = await db.query('books', orderBy: 'author ASC');
  return booksMap.map((bookMap) => Book.fromMap(bookMap)).toList();
}

Future<List<Book>> getBooksSortedByTitle() async {
  final db = await DatabaseHelper().database;
  final booksMap = await db.query('books', orderBy: 'title ASC');
  return booksMap.map((bookMap) => Book.fromMap(bookMap)).toList();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddBookPage]
class AddBookRoute extends PageRouteInfo<void> {
  const AddBookRoute({List<PageRouteInfo>? children})
      : super(
          AddBookRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddBookRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddBookPage();
    },
  );
}

/// generated route for
/// [AddReaderPage]
class AddReaderRoute extends PageRouteInfo<void> {
  const AddReaderRoute({List<PageRouteInfo>? children})
      : super(
          AddReaderRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddReaderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddReaderPage();
    },
  );
}

/// generated route for
/// [AllBookPage]
class AllBookRoute extends PageRouteInfo<void> {
  const AllBookRoute({List<PageRouteInfo>? children})
      : super(
          AllBookRoute.name,
          initialChildren: children,
        );

  static const String name = 'AllBookRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AllBookPage();
    },
  );
}

/// generated route for
/// [BookInfoPage]
class BookInfoRoute extends PageRouteInfo<BookInfoRouteArgs> {
  BookInfoRoute({
    Key? key,
    required Book currentBook,
    List<PageRouteInfo>? children,
  }) : super(
          BookInfoRoute.name,
          args: BookInfoRouteArgs(
            key: key,
            book: currentBook,
          ),
          initialChildren: children,
        );

  static const String name = 'BookInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookInfoRouteArgs>();
      return BookInfoPage(
        key: args.key,
        book: args.book,
      );
    },
  );
}

class BookInfoRouteArgs {
  const BookInfoRouteArgs({
    this.key,
    required this.book,
  });

  final Key? key;

  final Book book;

  @override
  String toString() {
    return 'BookInfoRouteArgs{key: $key, book: $book}';
  }
}

/// generated route for
/// [BookListPageForReader]
class BookListRouteForReader extends PageRouteInfo<BookListRouteForReaderArgs> {
  BookListRouteForReader({
    Key? key,
    required int currentReader,
    List<PageRouteInfo>? children,
  }) : super(
          BookListRouteForReader.name,
          args: BookListRouteForReaderArgs(
            key: key,
            currentReader: currentReader,
          ),
          initialChildren: children,
        );

  static const String name = 'BookListRouteForReader';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BookListRouteForReaderArgs>();
      return BookListPageForReader(
        key: args.key,
        currentReader: args.currentReader,
      );
    },
  );
}

class BookListRouteForReaderArgs {
  const BookListRouteForReaderArgs({
    this.key,
    required this.currentReader,
  });

  final Key? key;

  final int currentReader;

  @override
  String toString() {
    return 'BookListRouteForReaderArgs{key: $key, currentReader: $currentReader}';
  }
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [ReaderInfoPage]
class ReaderInfoRoute extends PageRouteInfo<ReaderInfoRouteArgs> {
  ReaderInfoRoute({
    Key? key,
    required Reader currentReader,
    List<PageRouteInfo>? children,
  }) : super(
          ReaderInfoRoute.name,
          args: ReaderInfoRouteArgs(
            key: key,
            reader: currentReader,
          ),
          initialChildren: children,
        );

  static const String name = 'ReaderInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReaderInfoRouteArgs>();
      return ReaderInfoPage(
        key: args.key,
        reader: args.reader,
      );
    },
  );
}

class ReaderInfoRouteArgs {
  const ReaderInfoRouteArgs({
    this.key,
    required this.reader,
  });

  final Key? key;

  final Reader reader;

  @override
  String toString() {
    return 'ReaderInfoRouteArgs{key: $key, reader: $reader}';
  }
}

/// generated route for
/// [ReaderListPage]
class ReaderListRoute extends PageRouteInfo<void> {
  const ReaderListRoute({List<PageRouteInfo>? children})
      : super(
          ReaderListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReaderListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReaderListPage();
    },
  );
}

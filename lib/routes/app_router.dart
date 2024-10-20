import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../models/book.dart';
import '../models/reader.dart';
import '../pages/book/add_book_page.dart';
import '../pages/book/all_book_page.dart';
import '../pages/book/book_info_page.dart';
import '../pages/book/book_list_for_reader_page.dart';
import '../pages/mainScreen/mainScreen.dart';
import '../pages/reader/add_reader_page.dart';
import '../pages/reader/reader_info_page.dart';
import '../pages/reader/reader_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainRoute.page, path: '/', initial: true, children: [
          AutoRoute(
            initial: true,
            page: ReaderListRoute.page,
            path: 'readers',
          ),
          AutoRoute(page: AllBookRoute.page, path: 'books')
        ]),
        AutoRoute(page: ReaderInfoRoute.page, path: '/reader-info'),
        AutoRoute(page: AddReaderRoute.page, path: '/add-reader'),
        AutoRoute(page: BookInfoRoute.page, path: '/book-info'),
        AutoRoute(page: AddBookRoute.page, path: '/add-book'),
        AutoRoute(page: BookListRouteForReader.page, path: '/book-for-reader'),
      ];
}

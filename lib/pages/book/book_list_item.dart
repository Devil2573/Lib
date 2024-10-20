import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects/routes/app_router.dart';

import '../../database/service.dart';
import '../../design/colors.dart';
import '../../design/dimensions.dart';
import '../../design/widgets/double_button.dart';
import '../../models/book.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  final VoidCallback onDeleteSuccess;

  const BookListItem(
      {super.key, required this.book, required this.onDeleteSuccess});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height64 + 10,
        child: Card(
          color: surfaceColor,
          elevation: 0.06,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius8)),
          child: Row(children: <Widget>[
            _title(context),
            _state(book.id, context),
          ]),
        ));
  }

  Future<void> _deleteBook(int bookId, BuildContext context) async {
    try {
      final borrowedBooks = await getBorrowedBooksByBookId(bookId);
      if (borrowedBooks.isNotEmpty) {
        if (context.mounted) {
          _showErrorDialog(context,
              'Невозможно удалить книгу, так как она взята читателем.');
        }
      } else {
        await deleteBook(bookId);
        onDeleteSuccess();
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Ошибка при удалении книги: $e');
      }
    }
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
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

  Widget _title(BuildContext context) {
    return SizedBox(
      width: 175,
      child: InkWell(
        onTap: () =>
            AutoRouter.of(context).push(BookInfoRoute(currentBook: book)),
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: padding6 * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: padding16),
                  child: Text(
                    book.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: secondColor,
                      fontSize: fontSize16 + 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: padding16 * 2),
                  child: RichText(
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(fontSize: fontSize16 + 1),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Автор:',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: book.author,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 200, 0, 0),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _state(int bookId, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            DoubleButton(
              title: "Удалить",
              onTap: () => _deleteBook(bookId, context),
            ),
          ],
        ),
      ],
    );
  }
}

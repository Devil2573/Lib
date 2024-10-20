import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects/database/service.dart';
import 'package:projects/design/colors.dart';
import 'package:projects/design/dimensions.dart';
import 'package:projects/models/reader.dart';
import 'package:projects/routes/app_router.dart';

import '../../design/widgets/double_button.dart';

class ReaderListItem extends StatelessWidget {
  final Reader reader;
  final VoidCallback onGiveSuccess;
  final VoidCallback onDeleteSuccess;

  const ReaderListItem(
      {super.key, required this.reader, required this.onGiveSuccess, required this.onDeleteSuccess});

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
        child: Row(
          children: <Widget>[
            _title(context),
            _state(context),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteReader(int readerId, BuildContext context) async {
    try {
      final borrowedBooks = await getBorrowedBooksByReaderId(readerId);
      if (borrowedBooks.isNotEmpty) {
        if (!context.mounted) return;
        _showErrorDialog(context,
            'Невозможно удалить пользователя, так как он не вернул книги.');
      } else {
        await deleteReader(readerId);
      }
    } catch (e) {
      if (!context.mounted) return;
      _showErrorDialog(context, 'Ошибка при удалении пользователя: $e');
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
        onTap: () => {
          AutoRouter.of(context).push(ReaderInfoRoute(currentReader: reader))
        },
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: padding6 * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: padding16 * 2),
                  child: Text(
                    '${reader.lastName} \n ${reader.firstName}',
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
                          text: 'Штраф:',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '${reader.fine}',
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

  Widget _state(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            DoubleButton(
              title: "Выдать",
              onTap: () {
                AutoRouter.of(context)
                    .push(BookListRouteForReader(currentReader: reader.id))
                    .then((result) {
                  if (result == true) {
                    onGiveSuccess();
                  }
                });
              },
            ),
            DoubleButton(
              title: "Удалить",
              onTap: () => {
                _deleteReader(reader.id, context),
                onDeleteSuccess()
              },
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects/design/colors.dart';
import 'package:projects/design/dimensions.dart';
import 'package:projects/pages/reader/reader_list_item.dart';
import 'package:projects/routes/app_router.dart';

import '../../database/service.dart';
import '../../models/reader.dart';

@RoutePage()
class ReaderListPage extends StatefulWidget {
  const ReaderListPage({super.key});

  @override
  State<ReaderListPage> createState() => _ReaderListPageState();
}

class _ReaderListPageState extends State<ReaderListPage> {
  List<Reader> _readers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReaders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadReaders();
  }

  Future<void> _loadReaders() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final readers = await getReaders();
      setState(() {
        _readers = readers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _refreshReaders() {
    _loadReaders();
  }

  Future<void> _showReturnDialog(int state) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: state == 0 ?
          const Text('Удаление пользователя')
              :const Text('Добавление пользователя'),
          content: state == 0 ?
          const Text('Пользователь успешно удален.')
              :const Text('Пользователь успешно добавлен.'),
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
        title: const Text('Список читателей',
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize16 + 8,
              fontWeight: FontWeight.w700,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceColor,
        actions: [
          IconButton(
            onPressed: () => AutoRouter.of(context)
                .push(const AddReaderRoute())
                .then((result) {
              if (result == true) {
                _showReturnDialog(1);
                _refreshReaders();
              }
            }),
            icon: const Icon(Icons.add_box_outlined),
          )
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _readers.isEmpty
                ? const Center(child: Text('Читатели не найдены'))
                : ListView.separated(
                    itemCount: _readers.length,
                    padding: const EdgeInsets.all(16.0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      print("object");
                      print(_readers[index].fine);
                      return ReaderListItem(
                        reader: _readers[index],
                        onGiveSuccess: () {
                          _refreshReaders();
                        },
                        onDeleteSuccess: () {
                          _showReturnDialog(0);
                          _refreshReaders();
                        },
                      );
                    },
                  ),
      ),
    );
  }
}

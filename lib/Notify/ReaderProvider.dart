import 'package:flutter/material.dart';

import '../database/service.dart';
import '../models/reader.dart';

class ReaderProvider with ChangeNotifier {
  int? selectedReaderId;
  List<Reader> readers = [];

  Future<void> loadReaders() async {
    readers = await getReaders();
    notifyListeners();
  }

  Future<void> addReader(Reader reader) async {
    await addReader(reader);
    await loadReaders();
  }

  void updateReader(int readerId) {
    selectedReaderId = readerId;
    notifyListeners();
  }
}

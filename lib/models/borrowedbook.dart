class BorrowedBook {
  final int readerId;
  final int bookId;
  final String dueDate;

  BorrowedBook({
    required this.readerId,
    required this.bookId,
    required this.dueDate,
  });

  factory BorrowedBook.fromMap(Map<String, dynamic> map) {
    return BorrowedBook(
      readerId: map['readerId'],
      bookId: map['bookId'],
      dueDate: map['dueDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'readerId': readerId,
      'bookId': bookId,
      'dueDate': dueDate,
    };
  }
}

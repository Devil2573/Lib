class Book {
  final int id;
  final String author;
  final String title;
  final int number;
  final String genre;
  final int ageLimit;
  int availableCopies;

  Book({
    required this.id,
    required this.author,
    required this.title,
    required this.number,
    required this.genre,
    required this.ageLimit,
    required this.availableCopies,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      author: map['author'],
      title: map['title'],
      number: map['number'],
      genre: map['genre'],
      ageLimit: map['ageLimit'],
      availableCopies: map['availableCopies'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'number': number,
      'genre': genre,
      'ageLimit': ageLimit,
      'availableCopies': availableCopies,
    };
  }
}

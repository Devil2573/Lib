class Reader {
  final int id;
  final String lastName;
  final String firstName;
  final String patronymic;
  final int age;
  int fine = 0;

  Reader({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.patronymic,
    required this.age,
    required this.fine,
  });

  factory Reader.fromMap(Map<String, dynamic> map) {
    return Reader(
      id: map['id'],
      lastName: map['lastName'],
      firstName: map['firstName'],
      patronymic: map['patronymic'],
      age: map['age'],
      fine: map['fine'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'patronymic': patronymic,
      'age': age,
      'fine': fine,
    };
  }
}

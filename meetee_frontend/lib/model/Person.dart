class Person {
  String name;
  String email;
  int status;
  Person(
    this.name,
    this.email,
    this.status,
  );

  // named constructor
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['username'],
        status = json['status'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'status': status,
    };
  }
}

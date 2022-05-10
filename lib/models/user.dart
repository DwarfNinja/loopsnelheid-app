class User {
  String email;
  String password;
  String dateOfBirth;
  String sex;

  User(this.email, this.password, this.dateOfBirth, this.sex);

  Map toJson() => {
        'email': email,
        'password': password,
        'dateOfBirth': dateOfBirth,
        'sex': sex
      };
}

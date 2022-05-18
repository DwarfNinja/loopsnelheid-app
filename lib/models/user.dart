class User {
  final String _email;
  final String _password;
  String? dateOfBirth;
  int? weight;
  String? sex;
  bool termsAndConditions = false;
  bool privacyStatement = false;
  bool olderThanSixteen = false;

  User(this._email, this._password);

  Map toJson() => {
        'email': _email,
        'password': _password,
        'dateOfBirth': dateOfBirth,
        'weight': weight,
        'sex': sex,
        'termsAndConditions': termsAndConditions,
        'privacyStatement': privacyStatement,
        'olderThanSixteen': olderThanSixteen,
      };

  User.fromJson(Map<String, dynamic> json)
      : _email = json['email'],
        _password = json['password'],
        dateOfBirth = json['dateOfBirth'],
        weight = json['weight'],
        sex = json['sex'],
        termsAndConditions = json['termsAndConditions'],
        privacyStatement = json['privacyStatement'],
        olderThanSixteen = json['olderThanSixteen'];
}

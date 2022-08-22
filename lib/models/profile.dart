class Profile {
  int id;
  String email;
  String dateOfBirth;
  String sex;
  bool isResearchCandidate;
  int height;
  int weight;
  List<dynamic> roles;


  Profile(this.id, this.email, this.dateOfBirth, this.sex, this.isResearchCandidate, this.height, this.weight, this.roles);

  Map toJson() => {
    'id': id,
    'email': email,
    'dateOfBirth': dateOfBirth,
    'sex': sex,
    'isResearchCandidate': isResearchCandidate,
    'length': height,
    'weight': weight,
    'roles': roles
  };

  Profile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        dateOfBirth = json['dateOfBirth'],
        sex = json['sex'],
        isResearchCandidate = json['isResearchCandidate'],
        weight = json['weight'],
        height = json['length'],
        roles = json['roles'];
}

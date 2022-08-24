class Profile {
  int id;
  String email;
  String dateOfBirth;
  String sex;
  bool isResearchCandidate;
  bool hasOpenDeleteRequest;
  int height;
  int weight;
  List<dynamic> roles;


  Profile(this.id, this.email, this.dateOfBirth, this.sex, this.isResearchCandidate, this.hasOpenDeleteRequest, this.height, this.weight, this.roles);

  Map toJson() => {
    'id': id,
    'email': email,
    'dateOfBirth': dateOfBirth,
    'sex': sex,
    'isResearchCandidate': isResearchCandidate,
    'hasOpenDeleteRequest': hasOpenDeleteRequest,
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
        hasOpenDeleteRequest = json['hasOpenDeleteRequest'],
        weight = json['weight'],
        height = json['length'],
        roles = json['roles'];
}

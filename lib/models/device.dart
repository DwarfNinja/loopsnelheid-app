class Device {
  int id;
  String type;
  String session;

  Device(this.id, this.type, this.session) {
    id = id;
    type = type;
    session = session;
  }

  Device.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        session = json['session'];
}
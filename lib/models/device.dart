class Device {
  int id;
  String type;
  String session;
  String os;

  Device(this.id, this.type, this.session, this.os) {
    id = id;
    type = type;
    session = session;
    os = os;
  }

  Device.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        session = json['session'],
        os = json['device_os'];
}
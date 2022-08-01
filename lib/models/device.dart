class Device {
  int id;
  String type;
  String session;
  String model;
  String os;

  Device(this.id, this.type, this.session, this.model, this.os) {
    id = id;
    type = type;
    session = session;
    model = model;
    os = os;
  }

  Device.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        session = json['session'],
        model = json['device_model'],
        os = json['device_os'];
}
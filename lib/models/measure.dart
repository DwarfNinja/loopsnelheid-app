class Measure {
  String registeredAt;
  String speed;

  Measure(this.registeredAt, this.speed) {
    registeredAt = registeredAt;
    speed = speed;
  }

  Map toJson() => {
    'registeredAt': registeredAt,
    'walkingSpeed': speed
  };
}
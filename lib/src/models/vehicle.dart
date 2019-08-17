class Vehicle {
  String id;
  int bearing;
  double latitude;
  double longitude;
  double speed;
  String updatedAt;
  String lineName;
  String directionDestination;
  String nextStop;

  String get updatedAtTime {
    if (this.updatedAt != null) {
      final date = DateTime.parse(this.updatedAt);
      final diff = DateTime.now().difference(date);
      if (diff.inSeconds <= 60) {
        return diff.inSeconds.toString() + " seconds ago";
      }
      var pluralString = '';
      if (diff.inMinutes == 1) {
        pluralString = 's';
      }
      return diff.inMinutes.toString() + " minute$pluralString ago";
    }
    return "N/A";
  }

  static const idKey = "id";
  static const bearingKey = "bearing";
  static const latitudeKey = "latitude";
  static const longitudeKey = "longitude";
  static const speedKey = "speed";
  static const lineNameKey = "lineName";
  static const updatedAtKey = "updatedAt";
  static const directionDestinationKey = "directionDestination";
  static const nextStopKey = "nextStop";

  Vehicle(this.id, this.bearing, this.latitude, this.longitude, this.speed,
      this.updatedAt, this.lineName, this.directionDestination, this.nextStop);

  Vehicle.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson[idKey];
    this.bearing = parsedJson[bearingKey];
    this.latitude = parsedJson[latitudeKey];
    this.longitude = parsedJson[longitudeKey];
    this.directionDestination = parsedJson[directionDestinationKey];
    this.speed = parsedJson[speedKey];
    this.lineName = parsedJson[lineNameKey];
    this.updatedAt = parsedJson[updatedAtKey];
    this.nextStop = parsedJson[nextStopKey];
  }
}

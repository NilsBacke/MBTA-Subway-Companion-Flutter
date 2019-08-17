import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbta_companion/src/models/vehicle.dart';

class VehiclesFetchSuccess {
  final List<Vehicle> vehicles;

  VehiclesFetchSuccess(this.vehicles);
}

class VehiclesFetchPending {}

class VehiclesFetchFailure {
  final String vehiclesErrorMessage;

  VehiclesFetchFailure(this.vehiclesErrorMessage);
}

class VehiclesClearError {}

class BitmapFetchSuccess {
  final BitmapDescriptor bitmap;

  BitmapFetchSuccess(this.bitmap);
}

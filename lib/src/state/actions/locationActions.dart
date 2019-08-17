import 'package:location/location.dart';
import 'package:mbta_companion/src/services/permission_service.dart';

class LocationFetchSuccess {
  final LocationData locationData;

  LocationFetchSuccess(this.locationData);
}

class LocationFetchPending {}

class LocationFetchFailure {
  final LocationStatus locationErrorStatus;

  LocationFetchFailure(this.locationErrorStatus);
}

class LocationClearError {}

import 'package:mbta_companion/src/models/stop.dart';

class NearestStopFetchSuccess {
  final List<Stop> stop; // list of length 2

  NearestStopFetchSuccess(this.stop);
}

class NearestStopFetchPending {}

class NearestStopFetchFailure {
  final String nearestStopErrorMessage;

  NearestStopFetchFailure(this.nearestStopErrorMessage);
}

class NearestStopClearError {}

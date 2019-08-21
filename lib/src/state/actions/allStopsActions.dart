import 'package:mbta_companion/src/models/stop.dart';

class AllStopsFetchSuccess {
  final List<Stop> stops;

  AllStopsFetchSuccess(this.stops);
}

class AllStopsFetchPending {}

class AllStopsFetchFailure {
  final String allStopsErrorMessage;

  AllStopsFetchFailure(this.allStopsErrorMessage);
}

class AllStopsClearError {}

import 'package:mbta_companion/src/models/polyline.dart';

class PolylinesFetchSuccess {
  final List<Polyline> polylines;

  PolylinesFetchSuccess(this.polylines);
}

class PolylinesFetchPending {}

class PolylinesFetchFailure {
  final String polylinesErrorMessage;

  PolylinesFetchFailure(this.polylinesErrorMessage);
}

class AllStopsClearError {}

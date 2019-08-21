import 'package:mbta_companion/src/models/stop.dart';

class SavedStopsFetchSuccess {
  final List<Stop> stops;

  SavedStopsFetchSuccess(this.stops);
}

class SavedStopsFetchPending {}

class SavedStopsFetchFailure {
  final String savedStopsErrorMessage;

  SavedStopsFetchFailure(this.savedStopsErrorMessage);
}

class SavedStopsAddSuccess {
  final Stop stop;

  SavedStopsAddSuccess(this.stop);
}

class SavedStopsAddPending {}

class SavedStopsAddFailure {
  final String savedStopsAddErrorMessage;

  SavedStopsAddFailure(this.savedStopsAddErrorMessage);
}

class SavedStopsRemoveSuccess {
  final Stop stop;

  SavedStopsRemoveSuccess(this.stop);
}

class SavedStopsRemovePending {}

class SavedStopsRemoveFailure {
  final String savedStopsRemoveErrorMessage;

  SavedStopsRemoveFailure(this.savedStopsRemoveErrorMessage);
}

class SavedStopsClearError {}

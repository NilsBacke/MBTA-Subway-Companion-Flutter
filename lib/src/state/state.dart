import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/models/vehicle.dart';
import 'package:mbta_companion/src/services/permission_service.dart';

class AppState {
  final LocationState locationState;
  final NearestStopState nearestStopState;
  final CommuteState commuteState;
  final SavedStopsState savedStopsState;
  final AllStopsState allStopsState;
  final AlertsState alertsState;
  final SelectedStopState selectedStopState;
  final VehiclesState vehiclesState;

  AppState(
      this.locationState,
      this.nearestStopState,
      this.commuteState,
      this.savedStopsState,
      this.allStopsState,
      this.alertsState,
      this.selectedStopState,
      this.vehiclesState);

  factory AppState.initial() => AppState(
      LocationState.initial(),
      NearestStopState.initial(),
      CommuteState.initial(),
      SavedStopsState.initial(),
      AllStopsState.initial(),
      AlertsState.initial(),
      SelectedStopState.initial(),
      VehiclesState.initial());

  @override
  String toString() {
    return "\n{ \nlocationState: ${this.locationState.toString()}, \nnearestStopState: ${this.nearestStopState.toString()} \ncommuteState: ${this.commuteState.toString()}, \nsavedStopsState: ${this.savedStopsState.toString()}, \nallStopsState: ${this.allStopsState.toString()}, \nalertsState: ${this.alertsState.toString()}, \nselectedStopState: ${this.selectedStopState.toString()} \n} vehiclesState: ${this.vehiclesState.toString()}, \n";
  }
}

class LocationState {
  final LocationData locationData;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;

  LocationState(
      this.locationData, this.isLocationLoading, this.locationErrorStatus);

  factory LocationState.initial() => LocationState(null, false, null);

  @override
  String toString() {
    return "{ locationData: ${this.locationData.toString()}, isLocationLoading: ${this.isLocationLoading}, locationErrorStatus: ${this.locationErrorStatus.toString()} }";
  }
}

class NearestStopState {
  final List<Stop> nearestStop;
  final bool isNearestStopLoading;
  final String nearestStopErrorMessage;

  NearestStopState(this.nearestStop, this.isNearestStopLoading,
      this.nearestStopErrorMessage);

  factory NearestStopState.initial() => NearestStopState(null, false, '');

  @override
  String toString() {
    return "{ nearestStop: ${this.nearestStop.toString()}, isNearestStopLoading: ${this.isNearestStopLoading}, nearestStopErrorMessage: ${this.nearestStopErrorMessage} }";
  }
}

class CommuteState {
  final Commute commute;
  final bool isCommuteLoading;
  final String commuteErrorMessage;
  final bool doesCommuteExist;

  CommuteState(this.commute, this.isCommuteLoading, this.commuteErrorMessage,
      this.doesCommuteExist);

  factory CommuteState.initial() => CommuteState(null, false, '', null);

  @override
  String toString() {
    return "{ commute: ${this.commute.toString()}, isCommuteLoading: ${this.isCommuteLoading}, commuteErrorMessage: ${this.commuteErrorMessage}, doesCommuteExist: ${this.doesCommuteExist} }";
  }
}

class SavedStopsState {
  final List<Stop> savedStops;
  final bool isSavedStopsLoading;
  final String savedStopsErrorMessage;

  SavedStopsState(
      this.savedStops, this.isSavedStopsLoading, this.savedStopsErrorMessage);

  factory SavedStopsState.initial() => SavedStopsState(null, false, '');

  @override
  String toString() {
    return "{ savedStops: ${this.savedStops.toString()}, isSavedStopsLoading: ${this.isSavedStopsLoading}, savedStopsErrorMessage: ${this.savedStopsErrorMessage} }";
  }
}

class AllStopsState {
  final List<Stop> allStops;
  final bool isAllStopsLoading;
  final String allStopsErrorMessage;

  AllStopsState(
      this.allStops, this.isAllStopsLoading, this.allStopsErrorMessage);

  factory AllStopsState.initial() =>
      AllStopsState(List.unmodifiable([]), false, '');

  @override
  String toString() {
    return "{ allStops: ${this.allStops.toString()}, isAllStopsLoading: ${this.isAllStopsLoading}, allStopsErrorMessage: ${this.allStopsErrorMessage} }";
  }
}

class AlertsState {
  final List<Alert> alerts;
  final bool isAlertsLoading;
  final String alertsErrorMessage;

  AlertsState(this.alerts, this.isAlertsLoading, this.alertsErrorMessage);

  factory AlertsState.initial() =>
      AlertsState(List.unmodifiable([]), false, '');

  @override
  String toString() {
    return "{ alerts: ${this.alerts.toString()}, isAlertsLoading: ${this.isAlertsLoading}, alertsErrorMessage: ${this.alertsErrorMessage} }";
  }
}

class SelectedStopState {
  final Stop stop;

  SelectedStopState(this.stop);

  factory SelectedStopState.initial() => SelectedStopState(null);

  @override
  String toString() {
    return "{ selectedStop: ${this.stop.toString()} }";
  }
}

class VehiclesState {
  final List<Vehicle> vehicles;
  final bool isVehiclesLoading;
  final String vehiclesErrorMessage;
  final BitmapDescriptor bitmap;

  VehiclesState(this.vehicles, this.isVehiclesLoading,
      this.vehiclesErrorMessage, this.bitmap);

  factory VehiclesState.initial() =>
      VehiclesState(List.unmodifiable([]), false, '', null);

  @override
  String toString() {
    return "{ vehicles: ${this.vehicles.toString()}, isVehiclesLoading: ${this.isVehiclesLoading}, vehiclesErrorMessage: ${this.vehiclesErrorMessage}, bitmap: ${this.bitmap} }";
  }
}

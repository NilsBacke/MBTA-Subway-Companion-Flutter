import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/models/vehicle.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/stop_detail_screen.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/state/operations/allStopsOperations.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';
import 'package:mbta_companion/src/state/operations/polylinesOperations.dart';
import 'package:mbta_companion/src/state/operations/vehiclesOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/utils/stops_list_helpers.dart';
import 'package:mbta_companion/src/widgets/error_text_widget.dart';
import 'package:mbta_companion/src/widgets/map_widget.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';
import 'package:redux/redux.dart';

class NearbyScreen extends StatefulWidget {
  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  void onInit(_NearbyScreenViewModel viewModel) {
    if (viewModel.bitmapmap == null || viewModel.bitmapmap.length == 0) {
      viewModel.getBitmap();
    }

    if (viewModel.location == null &&
        !viewModel.isLocationLoading &&
        viewModel.locationErrorStatus == null) {
      viewModel.getLocation();
    }

    if (viewModel.allStops != null &&
        viewModel.allStops.length == 0 &&
        !viewModel.isAllStopsLoading &&
        viewModel.allStopsErrorMessage.isEmpty &&
        viewModel.location != null) {
      viewModel.getAllStops(viewModel.location);
    }

    if (viewModel.vehicles != null &&
        viewModel.vehicles.length == 0 &&
        !viewModel.isVehiclesLoading &&
        viewModel.vehiclesErrorMessage.isEmpty) {
      viewModel.getVehicles(true);
    }

    if (viewModel.polylines != null &&
        viewModel.polylines.length == 0 &&
        !viewModel.isPolylinesLoading &&
        viewModel.polylinesErrorMessage.isEmpty) {
      viewModel.getPolylines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StoreConnector<AppState, _NearbyScreenViewModel>(
        onInit: (store) =>
            this.onInit(_NearbyScreenViewModel.create(store, context)),
        converter: (store) => _NearbyScreenViewModel.create(store, context),
        builder: (context, _NearbyScreenViewModel viewModel) {
          // error handling
          if (viewModel.locationErrorStatus != null) {
            if (viewModel.locationErrorStatus == LocationStatus.noPermission) {
              return errorTextWidget(context, text: locationPermissionText);
            }

            if (viewModel.locationErrorStatus == LocationStatus.noService) {
              return errorTextWidget(context, text: locationServicesText);
            }
          }

          if (viewModel.allStopsErrorMessage.isNotEmpty) {
            Future.delayed(Duration.zero,
                () => showErrorDialog(context, viewModel.allStopsErrorMessage));
            return errorTextWidget(context,
                text: viewModel.allStopsErrorMessage);
          }

          if (viewModel.vehiclesErrorMessage.isNotEmpty) {
            Future.delayed(Duration.zero,
                () => showErrorDialog(context, viewModel.vehiclesErrorMessage));
            return errorTextWidget(context,
                text: viewModel.vehiclesErrorMessage);
          }

          if (viewModel.polylinesErrorMessage.isNotEmpty) {
            Future.delayed(
                Duration.zero,
                () =>
                    showErrorDialog(context, viewModel.polylinesErrorMessage));
            return errorTextWidget(context,
                text: viewModel.polylinesErrorMessage);
          }

          if (viewModel.isAllStopsLoading ||
              viewModel.allStops.length == 0 ||
              viewModel.isPolylinesLoading ||
              viewModel.polylines.length == 0) {
            return StopsLoadingIndicator();
          }

          return Column(
            children: <Widget>[
              Expanded(
                child: mapWidget(
                    markers: viewModel.markers,
                    latlng: LatLng(viewModel.location.latitude,
                        viewModel.location.longitude),
                    polylines: viewModel.polylines,
                    isVehiclesLoading: viewModel.isVehiclesLoading,
                    getVehicles: viewModel.getVehicles),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NearbyScreenViewModel {
  final LocationData location;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;
  final List<Stop> allStops;
  final bool isAllStopsLoading;
  final String allStopsErrorMessage;
  final List<Vehicle> vehicles;
  final bool isVehiclesLoading;
  final String vehiclesErrorMessage;
  final List<Marker> markers;
  final Map<String, BitmapDescriptor> bitmapmap;
  final List<Polyline> polylines;
  final bool isPolylinesLoading;
  final String polylinesErrorMessage;

  final Function() getLocation;
  final Function(LocationData) getAllStops;
  final Function(bool) getVehicles;
  final Function() getBitmap;
  final Function() getPolylines;

  _NearbyScreenViewModel(
      {this.location,
      this.isLocationLoading,
      this.locationErrorStatus,
      this.allStops,
      this.isAllStopsLoading,
      this.allStopsErrorMessage,
      this.vehicles,
      this.isVehiclesLoading,
      this.vehiclesErrorMessage,
      this.bitmapmap,
      this.getLocation,
      this.getAllStops,
      this.getVehicles,
      this.markers,
      this.getBitmap,
      this.polylines,
      this.isPolylinesLoading,
      this.polylinesErrorMessage,
      this.getPolylines});

  factory _NearbyScreenViewModel.create(
      Store<AppState> store, BuildContext context) {
    final state = store.state;

    return _NearbyScreenViewModel(
        location: state.locationState.locationData,
        isLocationLoading: state.locationState.isLocationLoading,
        locationErrorStatus: state.locationState.locationErrorStatus,
        allStops: state.allStopsState.allStops,
        isAllStopsLoading: state.allStopsState.isAllStopsLoading,
        allStopsErrorMessage: state.allStopsState.allStopsErrorMessage,
        vehicles: state.vehiclesState.vehicles,
        isVehiclesLoading: state.vehiclesState.isVehiclesLoading,
        vehiclesErrorMessage: state.vehiclesState.vehiclesErrorMessage,
        getLocation: () => store.dispatch(fetchLocation()),
        getAllStops: (LocationData locationData) =>
            store.dispatch(fetchAllStops(locationData)),
        getVehicles: (bool activatePending) =>
            store.dispatch(fetchVehicles(activatePending)),
        markers: getMarkersFromState(state, context),
        bitmapmap: state.vehiclesState.bitmapmap,
        getBitmap: () => store.dispatch(fetchBitmap()),
        polylines: getPolylinesFromState(state.polylinesState.polylines),
        isPolylinesLoading: state.polylinesState.isPolylinesLoading,
        polylinesErrorMessage: state.polylinesState.polylinesErrorMessage,
        getPolylines: () => store.dispatch(fetchPolylines()));
  }

  static getMarkersFromState(AppState state, BuildContext context) {
    final List<Marker> markers = [];

    if (state.allStopsState.allStops != null &&
        state.allStopsState.allStops.length != 0 &&
        state.locationState.locationData != null) {
      final consolidatedStops = consolidate(
          state.allStopsState.allStops, state.locationState.locationData);
      for (final Stop stop in consolidatedStops) {
        final double dist = LocationService.getDistanceFromStop(
            stop, state.locationState.locationData);
        markers.add(
          Marker(
            markerId: MarkerId(stop.id),
            position: LatLng(stop.latitude, stop.longitude),
            infoWindow: InfoWindow(
              title: stop.name,
              snippet: '${stop.lineName} - $dist mi away',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StopDetailScreen(stop),
                ),
              ),
            ),
            icon: stop.marker,
          ),
        );
      }
    }

    if (state.vehiclesState.vehicles != null &&
        state.vehiclesState.vehicles.length != 0 &&
        state.vehiclesState.bitmapmap != null) {
      for (final Vehicle vehicle in state.vehiclesState.vehicles) {
        var icon;
        if (vehicle.lineName.contains("Green")) {
          icon = state.vehiclesState.bitmapmap["Green Line"];
        } else {
          icon = state.vehiclesState.bitmapmap[vehicle.lineName];
        }
        var marker = Marker(
          markerId: MarkerId(vehicle.id),
          position: LatLng(vehicle.latitude, vehicle.longitude),
          icon: icon,
          infoWindow: InfoWindow(
              title: "Approaching " + vehicle.nextStop,
              snippet: vehicle.lineName +
                  " - Last Updated: " +
                  vehicle.updatedAtTime),
          rotation: vehicle.bearing.toDouble(),
        );
        markers.add(marker);
      }
    }

    return markers;
  }
}

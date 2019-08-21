import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/models/vehicle.dart';
import 'package:mbta_companion/src/models/polyline.dart' as PolylineModel;
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/alert_card.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/details_widget.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/no_alerts_widget.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/single_timer.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/two_lines_timer_row.dart';
import 'package:mbta_companion/src/services/config.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/polylinesActions.dart';
import 'package:mbta_companion/src/state/actions/vehiclesActions.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';
import 'package:mbta_companion/src/state/operations/polylinesOperations.dart';
import 'package:mbta_companion/src/state/operations/vehiclesOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

class StopDetailScreen extends StatefulWidget {
  final Stop stop;

  StopDetailScreen(this.stop);

  @override
  _StopDetailScreenState createState() => _StopDetailScreenState();
}

class _StopDetailScreenState extends State<StopDetailScreen> {
  List<Alert> alerts = List();
  List<Stop> stopsAtLocation = List();

  @override
  void initState() {
    super.initState();
    getAssociatedStops();
    getAlerts(widget.stop);
  }

  Future<void> getAssociatedStops() async {
    final stops = await MBTAService.fetchAllStopsAtSameLocation(widget.stop);
    if (this.mounted) {
      setState(() {
        this.stopsAtLocation = stops;
      });
    }
  }

  Future<void> getAlerts(Stop stop) async {
    final alerts = await MBTAService.fetchAlertsForStop(stopId: stop.id);
    print('Alerts: $alerts');
    if (this.mounted) {
      setState(() {
        this.alerts = alerts;
      });
    }
  }

  List<List<Stop>> getStopRows(List<Stop> stopsAtLocation) {
    final List<List<Stop>> result = [];
    for (int i = 0; i < stopsAtLocation.length; i++) {
      final stop = stopsAtLocation[i];
      if (i < stopsAtLocation.length - 1) {
        if (stop.lineName != stopsAtLocation[i + 1].lineName) {
          result.add(List.from([stop]));
        } else {
          result.add(List.from([stop, stopsAtLocation[i + 1]]));
          i++;
        }
      } else {
        result.add(List.from([stop]));
      }
    }
    return result;
  }

  Widget buildStopRow(List<Stop> stopsInRow) {
    if (stopsInRow.length == 1) {
      return singleTimer(context, stopsInRow[0]);
    }
    return twoLinesTimerRow(context, stopsInRow[0], stopsInRow[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.stop.name,
        ),
      ),
      body: StoreConnector<AppState, _StopDetailScreenViewModel>(
        converter: (store) =>
            _StopDetailScreenViewModel.create(store, this.stopsAtLocation),
        builder: (context, _StopDetailScreenViewModel viewModel) {
          if (viewModel.location == null) {
            viewModel.getLocation();
          }

          if (viewModel.bitmapmap == null || viewModel.bitmapmap.length == 0) {
            viewModel.getBitmap();
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

          Widget topHalfWidget = topHalf(viewModel);

          if (viewModel.isVehiclesLoading) {
            topHalfWidget = Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print("else");
          }

          return WillPopScope(
            onWillPop: () async {
              viewModel.clearPolylinesError();
              viewModel.clearVehiclesError();
              return true;
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: topHalfWidget,
                  ),
                  Expanded(
                    child: bottomHalf(viewModel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget topHalf(_StopDetailScreenViewModel viewModel) {
    final coords = LatLng(widget.stop.latitude, widget.stop.longitude);
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: coords,
          zoom: 14.4746,
        ),
        myLocationEnabled: true,
        markers: [
          ...[
            Marker(
              markerId: MarkerId(widget.stop.id),
              icon: widget.stop.marker,
              position: coords,
              infoWindow: InfoWindow(
                title: widget.stop.name,
              ),
            )
          ],
          ...viewModel.markers
        ].toSet(),
        polylines: viewModel.polylines.toSet(),
      ),
    );
  }

  Widget bottomHalf(_StopDetailScreenViewModel viewModel) {
    final List<List<Stop>> stopRows = getStopRows(stopsAtLocation);

    return Container(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: <Widget>[
          detailsWidget(context, widget.stop, alerts, viewModel.location),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: stopRows.length,
            itemBuilder: (context, int i) {
              return buildStopRow(stopRows[i]);
            },
          ),
          Container(
            child: Text(
              'Alerts:',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          alerts.length == 0
              ? noAlertsWidget()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: alerts.length,
                  itemBuilder: (context, int i) {
                    return alertCard(alerts[i], context);
                  },
                ),
        ],
      ),
    );
  }
}

class _StopDetailScreenViewModel {
  final LocationData location;
  final List<Vehicle> vehicles;
  final bool isVehiclesLoading;
  final String vehiclesErrorMessage;
  final List<Polyline> polylines;
  final bool isPolylinesLoading;
  final String polylinesErrorMessage;
  final List<Marker> markers;
  final Map<String, BitmapDescriptor> bitmapmap;

  final Function() getLocation;
  final Function() getPolylines;
  final Function(bool) getVehicles;
  final Function() getBitmap;

  final Function() clearPolylinesError;
  final Function() clearVehiclesError;

  _StopDetailScreenViewModel(
      {this.location,
      this.getLocation,
      this.vehicles,
      this.vehiclesErrorMessage,
      this.isVehiclesLoading,
      this.getPolylines,
      this.getVehicles,
      this.polylines,
      this.polylinesErrorMessage,
      this.isPolylinesLoading,
      this.getBitmap,
      this.bitmapmap,
      this.markers,
      this.clearPolylinesError,
      this.clearVehiclesError});

  factory _StopDetailScreenViewModel.create(
      Store<AppState> store, List<Stop> stopsAtLocation) {
    final state = store.state;
    return _StopDetailScreenViewModel(
        location: state.locationState.locationData,
        getLocation: () => store.dispatch(fetchLocation()),
        getVehicles: (bool activatePending) =>
            store.dispatch(fetchVehicles(activatePending)),
        getPolylines: () => store.dispatch(fetchPolylines()),
        vehicles: state.vehiclesState.vehicles,
        isVehiclesLoading: state.vehiclesState.isVehiclesLoading,
        vehiclesErrorMessage: state.vehiclesState.vehiclesErrorMessage,
        polylines:
            filterPolylines(state.polylinesState.polylines, stopsAtLocation),
        isPolylinesLoading: state.polylinesState.isPolylinesLoading,
        polylinesErrorMessage: state.polylinesState.polylinesErrorMessage,
        getBitmap: () => store.dispatch(fetchBitmap()),
        bitmapmap: state.vehiclesState.bitmapmap,
        markers: getMarkers(state, stopsAtLocation),
        clearPolylinesError: () => store.dispatch(PolylinesClearError()),
        clearVehiclesError: () => store.dispatch(VehiclesClearError()));
  }

  static getMarkers(AppState state, List<Stop> stopsAtLocation) {
    final List<Marker> markers = [];
    if (state.vehiclesState.vehicles != null &&
        state.vehiclesState.vehicles.length != 0 &&
        state.vehiclesState.bitmapmap != null) {
      final filteredVehicles =
          filterVehicles(state.vehiclesState.vehicles, stopsAtLocation);
      for (final Vehicle vehicle in filteredVehicles) {
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

  static filterVehicles(List<Vehicle> vehicles, List<Stop> stopsAtLocation) {
    List<String> lineNames =
        stopsAtLocation.map((stop) => stop.lineName).toList();

    return vehicles.where((vehicle) {
      var name = vehicle.lineName;
      // is Green line
      if (vehicle.lineName.indexOf("-") != -1) {
        name = name.substring(0, vehicle.lineName.indexOf("-")) + " Line";
      }
      return lineNames.contains(name);
    }).toList();
  }

  static filterPolylines(
      List<PolylineModel.Polyline> polylines, List<Stop> stopsAtLocation) {
    List<String> lineNames =
        stopsAtLocation.map((stop) => stop.lineName).toList();
    return getPolylinesFromState(polylines
            .where((poly) => lineNames.contains(poly.lineTitle + " Line"))
            .toList())
        .toList();
  }
}

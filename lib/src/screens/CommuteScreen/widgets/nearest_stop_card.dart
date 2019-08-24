import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/CommuteScreen/utils/stop_distance.dart';
import 'package:mbta_companion/src/screens/CommuteScreen/widgets/four_part_card.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';
import 'package:mbta_companion/src/state/operations/nearestStopOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/navigation_utils.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/widgets/stop_details_tile.dart';
import 'package:mbta_companion/src/widgets/time_to_walk_text.dart';
import 'package:redux/redux.dart';

class NearestStopCard extends StatefulWidget {
  @override
  _NearestStopCardState createState() => _NearestStopCardState();
}

class _NearestStopCardState extends State<NearestStopCard> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NearestStopViewModel>(
      converter: (store) => NearestStopViewModel.create(store),
      builder: (context, viewModel) {
        if (viewModel.location == null &&
            !viewModel.isLocationLoading &&
            viewModel.locationErrorStatus == null) {
          viewModel.getLocation();
        }

        if (viewModel.nearestStop == null &&
            !viewModel.isNearestStopLoading &&
            viewModel.nearestStopErrorMessage == '' &&
            viewModel.location != null) {
          viewModel.getNearestStop(viewModel.location);
        }

        if (viewModel.isLocationLoading || viewModel.isNearestStopLoading) {
          return nearestStopLoadingIndicator();
        }
        if (viewModel.nearestStopErrorMessage != null &&
            viewModel.nearestStopErrorMessage.length != 0) {
          Future.delayed(
              Duration.zero,
              () =>
                  showErrorDialog(context, viewModel.nearestStopErrorMessage));
          return errorMessageCard(context, viewModel.nearestStopErrorMessage);
        }

        if (viewModel.locationErrorStatus == LocationStatus.noPermission) {
          return locationPermissionsNotEnabled(context);
        }
        if (viewModel.locationErrorStatus == LocationStatus.noService) {
          return locationServicesNotEnabled(context);
        }
        if (viewModel.nearestStop == null ||
            viewModel.nearestStop.length == 0) {
          return blankNearestStopCard(
            child: Text(
              'No stops within ${MBTAService.rangeInMiles} miles',
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.center,
            ),
          );
        }
        return nearestStopCard(context, viewModel);
      },
    );
  }

  Widget nearestStopLoadingIndicator() {
    return blankNearestStopCard(
      child: CircularProgressIndicator(
        semanticsLabel: "Loading closest stop",
      ),
    );
  }

  Widget errorMessageCard(context, String error) {
    return blankNearestStopCard(
      child: Text(
        error,
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget locationPermissionsNotEnabled(context) {
    return blankNearestStopCard(
      child: Text(
        locationPermissionText,
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget locationServicesNotEnabled(context) {
    return blankNearestStopCard(
      child: Text(
        locationServicesText,
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget blankNearestStopCard({child: Widget}) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.all(2.0),
      child: Card(
        child: Center(child: child == null ? Container() : child),
      ),
    );
  }

  nearestStopCard(context, NearestStopViewModel viewModel) {
    return FourPartCard(
      'Nearest Stop',
      GestureDetector(
        onTap: () {
          showDetailForStop(context, viewModel.nearestStop[0]);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            viewModel.nearestStop[0].id,
            title: viewModel.nearestStop[0].name,
            subtitle1: viewModel.nearestStop[0].lineName,
            otherInfo: [viewModel.nearestStop[0].directionDescription],
            lineInitials: viewModel.nearestStop[0].lineInitials,
            lineColor: viewModel.nearestStop[0].lineColor,
            onTap: () {
              showDetailForStop(context, viewModel.nearestStop[0]);
            },
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          showDetailForStop(context, viewModel.nearestStop[1]);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            viewModel.nearestStop[1].id,
            title: viewModel.nearestStop[1].name,
            subtitle1: viewModel.nearestStop[1].lineName,
            otherInfo: [viewModel.nearestStop[1].directionDescription],
            lineInitials: viewModel.nearestStop[1].lineInitials,
            lineColor: viewModel.nearestStop[1].lineColor,
            onTap: () {
              showDetailForStop(context, viewModel.nearestStop[1]);
            },
          ),
        ),
      ),
      timeToWalkText(context, viewModel.nearestStop[0], viewModel.location),
      trailing: FutureBuilder(
          future: getDistanceFromNearestStop(
              viewModel.location, viewModel.nearestStop),
          builder: (context, snapshot) {
            return Text(
              snapshot.hasData ? '${snapshot.data} mi' : '---',
              style: Theme.of(context).textTheme.body2,
            );
          }),
    );
  }
}

class NearestStopViewModel {
  final LocationData location;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;
  final List<Stop> nearestStop;
  final bool isNearestStopLoading;
  final String nearestStopErrorMessage;

  final Function() getLocation;
  final Function(LocationData) getNearestStop;

  NearestStopViewModel({
    this.location,
    this.isLocationLoading,
    this.locationErrorStatus,
    this.nearestStop,
    this.isNearestStopLoading,
    this.nearestStopErrorMessage,
    this.getLocation,
    this.getNearestStop,
  });

  factory NearestStopViewModel.create(Store<AppState> store) {
    final state = store.state;
    return NearestStopViewModel(
      location: state.locationState.locationData,
      isLocationLoading: state.locationState.isLocationLoading,
      locationErrorStatus: state.locationState.locationErrorStatus,
      nearestStop: state.nearestStopState.nearestStop,
      isNearestStopLoading: state.nearestStopState.isNearestStopLoading,
      nearestStopErrorMessage: state.nearestStopState.nearestStopErrorMessage,
      getLocation: () => store.dispatch(fetchLocation()),
      getNearestStop: (LocationData locationData) =>
          store.dispatch(fetchNearestStop(locationData)),
    );
  }
}

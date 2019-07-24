import 'package:mbta_companion/src/state/reducers/nearestStopReducer.dart';
import 'package:mbta_companion/src/state/reducers/selectedStopReducer.dart';
import '../state.dart';
import 'alertsReducer.dart';
import 'allStopsReducer.dart';
import 'commuteReducer.dart';
import 'locationReducer.dart';
import 'savedStopsReducer.dart';
import 'nearbyStopsReducer.dart';

AppState appReducer(AppState state, action) => AppState(
    locationDataReducer(state.locationState, action),
    nearestStopReducer(state.nearestStopState, action),
    commuteReducer(state.commuteState, action),
    savedStopsReducer(state.savedStopsState, action),
    allStopsReducer(state.allStopsState, action),
    nearbyStopsReducer(state.nearbyStopsState, action),
    alertsReducer(state.alertsState, action),
    selectedStopReducer(state.selectedStopState, action));

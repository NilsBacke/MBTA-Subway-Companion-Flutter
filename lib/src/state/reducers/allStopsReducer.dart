import 'package:mbta_companion/src/state/actions/allStopsActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<AllStopsState> allStopsReducer = combineReducers([
  TypedReducer(allStopsFetchSuccess),
  TypedReducer(allStopsFetchPending),
  TypedReducer(allStopsFetchFailure),
  TypedReducer(allStopsClearError),
]);

AllStopsState allStopsFetchSuccess(
    AllStopsState allStopsState, AllStopsFetchSuccess action) {
  return AllStopsState(action.stops, false, '');
}

AllStopsState allStopsFetchPending(
    AllStopsState allStopsState, AllStopsFetchPending action) {
  return AllStopsState(List.unmodifiable([]), true, '');
}

AllStopsState allStopsFetchFailure(
    AllStopsState allStopsState, AllStopsFetchFailure action) {
  return AllStopsState(
      List.unmodifiable([]), false, action.allStopsErrorMessage);
}

AllStopsState allStopsClearError(
    AllStopsState allStopsState, AllStopsClearError action) {
  return AllStopsState(List.unmodifiable([]), false, '');
}

import 'package:mbta_companion/src/state/actions/polylinesActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<PolylinesState> polylinesReducer = combineReducers([
  TypedReducer(polylinesFetchSuccess),
  TypedReducer(polylinesFetchPending),
  TypedReducer(polylinesFetchFailure),
]);

PolylinesState polylinesFetchSuccess(
    PolylinesState polylinesState, PolylinesFetchSuccess action) {
  return PolylinesState(action.polylines, false, '');
}

PolylinesState polylinesFetchPending(
    PolylinesState polylinesState, PolylinesFetchPending action) {
  return PolylinesState(List.unmodifiable([]), true, '');
}

PolylinesState polylinesFetchFailure(
    PolylinesState polylinesState, PolylinesFetchFailure action) {
  return PolylinesState(
      List.unmodifiable([]), false, action.polylinesErrorMessage);
}

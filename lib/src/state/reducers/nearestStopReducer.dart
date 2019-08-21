import 'package:mbta_companion/src/state/actions/nearestStopActions.dart';
import 'package:redux/redux.dart';
import '../state.dart';

final Reducer<NearestStopState> nearestStopReducer = combineReducers([
  TypedReducer(nearestStopFetchSuccess),
  TypedReducer(nearestStopFetchPending),
  TypedReducer(nearestStopFetchFailure),
  TypedReducer(nearestStopClearError)
]);

NearestStopState nearestStopFetchSuccess(
    NearestStopState nearestStopState, NearestStopFetchSuccess action) {
  return NearestStopState(action.stop, false, '');
}

NearestStopState nearestStopFetchPending(
    NearestStopState nearestStopState, NearestStopFetchPending action) {
  return NearestStopState(
      nearestStopState.nearestStop == null
          ? null
          : List.unmodifiable(nearestStopState.nearestStop),
      true,
      '');
}

NearestStopState nearestStopFetchFailure(
    NearestStopState nearestStopState, NearestStopFetchFailure action) {
  return NearestStopState(
      nearestStopState.nearestStop == null
          ? null
          : List.unmodifiable(nearestStopState.nearestStop),
      false,
      action.nearestStopErrorMessage);
}

NearestStopState nearestStopClearError(
    NearestStopState nearestStopState, NearestStopClearError action) {
  return NearestStopState(
      nearestStopState.nearestStop == null
          ? null
          : List.unmodifiable(nearestStopState.nearestStop),
      false,
      '');
}

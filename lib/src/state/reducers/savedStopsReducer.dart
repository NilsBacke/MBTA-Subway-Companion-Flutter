import 'package:mbta_companion/src/state/actions/savedStopsActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<SavedStopsState> savedStopsReducer = combineReducers([
  TypedReducer(savedStopsFetchSuccess),
  TypedReducer(savedStopsFetchPending),
  TypedReducer(savedStopsFetchFailure),
  TypedReducer(savedStopsAddSuccess),
  TypedReducer(savedStopsAddPending),
  TypedReducer(savedStopsAddFailure),
  TypedReducer(savedStopsRemoveSuccess),
  TypedReducer(savedStopsRemovePending),
  TypedReducer(savedStopsRemoveFailure),
  TypedReducer(clearSavedStopsError),
]);

SavedStopsState savedStopsFetchSuccess(
    SavedStopsState savedStopsState, SavedStopsFetchSuccess action) {
  return SavedStopsState(action.stops, false, '');
}

SavedStopsState savedStopsFetchPending(
    SavedStopsState savedStopsState, SavedStopsFetchPending action) {
  return SavedStopsState(
      savedStopsState.savedStops == null
          ? null
          : List.unmodifiable(savedStopsState.savedStops),
      true,
      '');
}

SavedStopsState savedStopsFetchFailure(
    SavedStopsState savedStopsState, SavedStopsFetchFailure action) {
  return SavedStopsState(List.unmodifiable(savedStopsState.savedStops), false,
      action.savedStopsErrorMessage);
}

SavedStopsState savedStopsAddSuccess(
    SavedStopsState savedStopsState, SavedStopsAddSuccess action) {
  return SavedStopsState(
      List.unmodifiable(
          List.from(savedStopsState.savedStops)..add(action.stop)),
      false,
      '');
}

SavedStopsState savedStopsAddPending(
    SavedStopsState savedStopsState, SavedStopsAddPending action) {
  return SavedStopsState(
      List.unmodifiable(savedStopsState.savedStops), true, '');
}

SavedStopsState savedStopsAddFailure(
    SavedStopsState savedStopsState, SavedStopsAddFailure action) {
  return SavedStopsState(List.unmodifiable(savedStopsState.savedStops), false,
      action.savedStopsAddErrorMessage);
}

SavedStopsState savedStopsRemoveSuccess(
    SavedStopsState savedStopsState, SavedStopsRemoveSuccess action) {
  return SavedStopsState(
      List.unmodifiable(
          List.from(savedStopsState.savedStops)..remove(action.stop)),
      false,
      '');
}

SavedStopsState savedStopsRemovePending(
    SavedStopsState savedStopsState, SavedStopsRemovePending action) {
  return SavedStopsState(
      List.unmodifiable(savedStopsState.savedStops), true, '');
}

SavedStopsState savedStopsRemoveFailure(
    SavedStopsState savedStopsState, SavedStopsRemoveFailure action) {
  return SavedStopsState(List.unmodifiable(savedStopsState.savedStops), false,
      action.savedStopsRemoveErrorMessage);
}

SavedStopsState clearSavedStopsError(
    SavedStopsState savedStopsState, SavedStopsClearError action) {
  return SavedStopsState(List.unmodifiable(savedStopsState.savedStops),
      savedStopsState.isSavedStopsLoading, '');
}

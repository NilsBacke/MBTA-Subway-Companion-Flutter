import 'package:mbta_companion/src/state/actions/alertsActions.dart';
import 'package:redux/redux.dart';
import '../state.dart';

final Reducer<AlertsState> alertsReducer = combineReducers([
  TypedReducer(alertsFetchSuccess),
  TypedReducer(alertsFetchPending),
  TypedReducer(alertsFetchFailure),
]);

AlertsState alertsFetchSuccess(
    AlertsState alertsState, AlertsFetchSuccess action) {
  return AlertsState(action.alerts, false, '');
}

AlertsState alertsFetchPending(
    AlertsState alertsState, AlertsFetchPending action) {
  return AlertsState(null, true, '');
}

AlertsState alertsFetchFailure(
    AlertsState alertsState, AlertsFetchFailure action) {
  return AlertsState(null, false, action.alertErrorMessage);
}

AlertsState alertsClearError(AlertsState alertsState, AlertsClearError action) {
  return AlertsState(null, false, '');
}

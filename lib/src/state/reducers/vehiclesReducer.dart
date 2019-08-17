import 'package:mbta_companion/src/state/actions/vehiclesActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<VehiclesState> vehiclesReducer = combineReducers([
  TypedReducer(vehicleFetchSuccess),
  TypedReducer(vehicleFetchPending),
  TypedReducer(vehicleFetchFailure),
  TypedReducer(vehicleBitmapSuccess)
]);

VehiclesState vehicleFetchSuccess(
    VehiclesState vehiclesState, VehiclesFetchSuccess action) {
  return VehiclesState(action.vehicles, false, '', vehiclesState.bitmap);
}

VehiclesState vehicleFetchPending(
    VehiclesState vehiclesState, VehiclesFetchPending action) {
  return VehiclesState(vehiclesState.vehicles, true, '', vehiclesState.bitmap);
}

VehiclesState vehicleFetchFailure(
    VehiclesState vehiclesState, VehiclesFetchFailure action) {
  return VehiclesState(List.unmodifiable([]), false,
      action.vehiclesErrorMessage, vehiclesState.bitmap);
}

VehiclesState vehicleBitmapSuccess(
    VehiclesState vehiclesState, BitmapFetchSuccess action) {
  return VehiclesState(vehiclesState.vehicles, vehiclesState.isVehiclesLoading,
      vehiclesState.vehiclesErrorMessage, action.bitmap);
}

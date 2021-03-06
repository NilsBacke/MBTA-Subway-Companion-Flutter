import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/allStopsActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchAllStops(LocationData locationData) {
  return (Store store) async {
    Future(() async {
      store.dispatch(AllStopsFetchPending());
      try {
        var allStops = await MBTAService.fetchAllStops(locationData);
        store.dispatch(AllStopsFetchSuccess(allStops));
      } catch (e, stackTrace) {
        print("$e");
        store
            .dispatch(AllStopsFetchFailure(allStopsAtSameLocationErrorMessage));
        reportError(e, stackTrace);
      }
    });
  };
}

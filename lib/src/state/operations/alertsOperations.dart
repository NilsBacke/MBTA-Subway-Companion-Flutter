import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/alertsActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchAlertsForStop(Stop stop) {
  return (Store store) async {
    Future(() async {
      store.dispatch(AlertsFetchPending());
      try {
        var alerts = await MBTAService.fetchAlertsForStop(stopId: stop.id);
        store.dispatch(AlertsFetchSuccess(alerts));
      } catch (e, stackTrace) {
        print("$e");
        store.dispatch(AlertsFetchFailure(alertsErrorMessage));
        reportError(e, stackTrace);
      }
    });
  };
}

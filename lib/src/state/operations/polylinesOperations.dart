import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/polylinesActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchPolylines() {
  return (Store store) async {
    Future(() async {
      store.dispatch(PolylinesFetchPending());
      try {
        var polylines = await MBTAService.fetchPolylines();
        store.dispatch(PolylinesFetchSuccess(polylines));
      } catch (e, stackTrace) {
        print("$e");
        store.dispatch(PolylinesFetchFailure(e.toString()));
        reportError(e, stackTrace);
      }
    });
  };
}

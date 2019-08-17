import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/AddSavedScreen/add_saved_screen.dart';
import 'package:mbta_companion/src/screens/SavedStopsScreen/widgets/empty_saved_list.dart';
import 'package:mbta_companion/src/screens/SavedStopsScreen/widgets/error_list.dart';
import 'package:mbta_companion/src/state/actions/savedStopsActions.dart';
import 'package:mbta_companion/src/state/operations/savedStopsOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';
import 'package:redux/redux.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  Function(Stop) addStopFullFunction(Function(Stop) addStop) {
    return (Stop stop) {
      addStop(stop);
      Navigator.of(context).pop();
    };
  }

  void goToAddStop(Function(Stop) addStop) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AddSavedScreen(this.addStopFullFunction(addStop))));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SavedViewModel>(
      converter: (store) => _SavedViewModel.create(store),
      builder: (context, _SavedViewModel viewModel) {
        if (viewModel.savedStops == null &&
            !viewModel.isSavedStopsLoading &&
            viewModel.savedStopsError.length == 0) {
          viewModel.getSavedStops();
        }

        var bodyWidget;
        if (viewModel.isSavedStopsLoading) {
          bodyWidget = StopsLoadingIndicator();
        } else if (viewModel.savedStopsError.isNotEmpty) {
          Future.delayed(Duration.zero,
              () => showErrorDialog(context, viewModel.savedStopsError));
          bodyWidget = errorSavedList(context, viewModel.savedStopsError);
        } else if (viewModel.savedStops == null ||
            viewModel.savedStops.length == 0) {
          bodyWidget = emptySavedList(context);
        } else {
          bodyWidget = StopsListView(
            viewModel.savedStops,
            dismissable: true,
            onDismiss: viewModel.removeStop,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final viewModel = _SavedViewModel.create(StoreProvider.of(context));
            viewModel.getSavedStops();
            await Future.delayed(Duration(seconds: 1));
          },
          child: WillPopScope(
            onWillPop: () async {
              viewModel.clearError();
              return true;
            },
            child: Scaffold(
              body: SafeArea(
                child: bodyWidget,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => goToAddStop(viewModel.addStop),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SavedViewModel {
  final List<Stop> savedStops;
  final bool isSavedStopsLoading;
  final String savedStopsError;

  final Function() getSavedStops;
  final Function(Stop) addStop;
  final Function(Stop) removeStop;
  final Function() clearError;

  _SavedViewModel(
      {this.savedStops,
      this.isSavedStopsLoading,
      this.savedStopsError,
      this.getSavedStops,
      this.addStop,
      this.removeStop,
      this.clearError});

  factory _SavedViewModel.create(Store<AppState> store) {
    final state = store.state;

    return _SavedViewModel(
        savedStops: state.savedStopsState.savedStops,
        isSavedStopsLoading: state.savedStopsState.isSavedStopsLoading,
        savedStopsError: state.savedStopsState.savedStopsErrorMessage,
        getSavedStops: () => store.dispatch(fetchSavedStops()),
        addStop: (Stop stop) => store.dispatch(addSavedStop(stop)),
        removeStop: (Stop stop) => store.dispatch(removeSavedStop(stop)),
        clearError: () => store.dispatch(ClearSavedStopsError()));
  }
}

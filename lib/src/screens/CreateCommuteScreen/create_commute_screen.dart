import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/utils/choose_stop.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/utils/showUnableDialog.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/widgets/create_button.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/widgets/info_text.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/widgets/stop_container.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/widgets/time_selection_row.dart';
import 'package:mbta_companion/src/services/google_api_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/operations/commuteOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/utils/stops_list_helpers.dart';
import 'package:redux/redux.dart';

class CreateCommuteScreen extends StatefulWidget {
  @override
  _CreateCommuteScreenState createState() => _CreateCommuteScreenState();
}

class _CreateCommuteScreenState extends State<CreateCommuteScreen> {
  String appBarText;
  Stop stop1, stop2;
  TimeOfDay arrivalTime, departureTime;
  bool isLoading;

  initVariables(Commute commute) {
    isLoading = false;
    if (commute != null) {
      if (isCommuteSwapped(commute)) {
        this.stop1 = commute.stop2;
        this.stop2 = commute.stop1;
        this.arrivalTime = commute.departureTime;
        this.departureTime = commute.arrivalTime;
      } else {
        this.stop1 = commute.stop1;
        this.stop2 = commute.stop2;
        this.arrivalTime = commute.arrivalTime;
        this.departureTime = commute.departureTime;
      }
      this.appBarText = "Update Commute";
    } else {
      this.arrivalTime = TimeOfDay(hour: 9, minute: 0);
      this.departureTime = TimeOfDay(hour: 17, minute: 0);
      this.appBarText = "Create Commute";
    }
  }

  bool isCommuteSwapped(Commute commute) {
    return !(commute.stop1.id == commute.homeStopId);
  }

  handleChosenStop(
      bool homeStop, BuildContext context, Stop currentStop) async {
    Stop stop = await chooseStop(context, homeStop);

    if (!this.mounted) {
      return;
    }

    // nothing was tapped
    if (stop == null) {
      stop = currentStop;
    }

    if (homeStop) {
      setState(() {
        this.stop1 = stop;
      });
    } else {
      setState(() {
        this.stop2 = stop;
      });
    }
  }

  void pickTime(bool arrival) {
    showTimePicker(
      context: context,
      initialTime: arrival
          ? TimeOfDay(hour: 9, minute: 0)
          : TimeOfDay(hour: 17, minute: 0),
    ).then((time) {
      if (time != null) {
        if (arrival) {
          setState(() {
            this.arrivalTime = time;
          });
        } else {
          setState(() {
            this.departureTime = time;
          });
        }
      }
    });
  }

  Future<void> createCommute(
      BuildContext context,
      CreateCommuteViewModel viewModel,
      Stop stop1,
      Stop stop2,
      TimeOfDay arrivalTime,
      TimeOfDay departureTime) async {
    if (stop1 == null || stop2 == null) {
      showUnableToCreateDialog(context);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final direction1 =
          await GoogleAPIService.getDirectionFromRoute(stop1, stop2);
      final direction2 =
          await GoogleAPIService.getDirectionFromRoute(stop2, stop1);

      var changedStop1, changedStop2;

      if (direction1 != null &&
          !stop1.directionDestination.contains(direction1)) {
        changedStop1 = await MBTAService.getAssociatedStop(stopId: stop1.id);
      } else {
        changedStop1 = stop1;
      }

      if (direction2 != null &&
          !stop2.directionDestination.contains(direction2)) {
        changedStop2 = await MBTAService.getAssociatedStop(stopId: stop2.id);
      } else {
        changedStop2 = stop2;
      }

      final newCommute =
          Commute(changedStop1, changedStop2, arrivalTime, departureTime);

      viewModel.saveCommute(newCommute);
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      showErrorDialog(context, saveCommuteError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateCommuteViewModel>(
      onInit: (store) => initVariables(store.state.commuteState.commute),
      converter: (store) => CreateCommuteViewModel.create(store),
      builder: (context, CreateCommuteViewModel viewModel) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(appBarText),
          ),
          body: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        stopContainer(
                            context,
                            true,
                            "Home",
                            "Tap to add home stop",
                            this.stop1,
                            this.handleChosenStop),
                        stopContainer(
                            context,
                            false,
                            "Work",
                            "Tap to add work stop",
                            this.stop2,
                            this.handleChosenStop),
                        timeSelectionRow(context, this.arrivalTime,
                            this.departureTime, pickTime),
                        isLoading
                            ? Container(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  infoText(context),
                  createButton(
                    appBarText,
                    () => createCommute(context, viewModel, stop1, stop2,
                        arrivalTime, departureTime),
                  ),
                  Container(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreateCommuteViewModel {
  final Commute commute;
  final Function(Commute) saveCommute;

  CreateCommuteViewModel({this.commute, this.saveCommute});

  factory CreateCommuteViewModel.create(Store<AppState> store) {
    final state = store.state;
    return CreateCommuteViewModel(
      commute: state.commuteState.commute,
      saveCommute: (Commute commute) => store.dispatch(saveCommuteOp(commute)),
    );
  }
}

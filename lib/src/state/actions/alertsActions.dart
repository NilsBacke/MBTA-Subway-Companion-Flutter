import 'package:mbta_companion/src/models/alert.dart';

class AlertsFetchSuccess {
  final List<Alert> alerts;

  AlertsFetchSuccess(this.alerts);
}

class AlertsFetchPending {}

class AlertsFetchFailure {
  final String alertErrorMessage;

  AlertsFetchFailure(this.alertErrorMessage);
}

class AlertsClearError {}

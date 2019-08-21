import 'package:mbta_companion/src/models/commute.dart';

class CommuteFetchSuccess {
  final Commute commute;

  CommuteFetchSuccess(this.commute);
}

class CommuteFetchPending {}

class CommuteFetchFailure {
  final String commuteErrorMessage;

  CommuteFetchFailure(this.commuteErrorMessage);
}

class CommuteSavePending {}

class CommuteSaveSuccess {
  final Commute commute;

  CommuteSaveSuccess(this.commute);
}

class CommuteSaveFailure {
  final String commuteSaveErrorMessage;

  CommuteSaveFailure(this.commuteSaveErrorMessage);
}

class CommuteDeletePending {}

class CommuteDeleteSuccess {
  final Commute commute;

  CommuteDeleteSuccess(this.commute);
}

class CommuteDeleteFailure {
  final String commuteDeleteErrorMessage;

  CommuteDeleteFailure(this.commuteDeleteErrorMessage);
}

class CommuteSetExists {
  final bool exists;

  CommuteSetExists(this.exists);
}

class CommuteClearError {}

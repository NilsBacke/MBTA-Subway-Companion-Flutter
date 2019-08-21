import 'package:mbta_companion/src/state/actions/commuteActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<CommuteState> commuteReducer = combineReducers([
  TypedReducer(commuteFetchSuccess),
  TypedReducer(commuteFetchPending),
  TypedReducer(commuteFetchFailure),
  TypedReducer(commuteSaveSuccess),
  TypedReducer(commuteSavePending),
  TypedReducer(commuteSaveFailure),
  TypedReducer(commuteDeleteSuccess),
  TypedReducer(commuteDeletePending),
  TypedReducer(commuteDeleteFailure),
  TypedReducer(commuteSetExists),
  TypedReducer(commuteClearError)
]);

CommuteState commuteFetchSuccess(
    CommuteState commuteState, CommuteFetchSuccess action) {
  return CommuteState(action.commute, false, '', commuteState.doesCommuteExist);
}

CommuteState commuteFetchPending(
    CommuteState commuteState, CommuteFetchPending action) {
  return CommuteState(null, true, '', commuteState.doesCommuteExist);
}

CommuteState commuteFetchFailure(
    CommuteState commuteState, CommuteFetchFailure action) {
  return CommuteState(
      null, false, action.commuteErrorMessage, commuteState.doesCommuteExist);
}

CommuteState commuteSaveSuccess(
    CommuteState commuteState, CommuteSaveSuccess action) {
  return CommuteState(action.commute, false, '', true);
}

CommuteState commuteSavePending(
    CommuteState commuteState, CommuteSavePending action) {
  return CommuteState(null, true, '', commuteState.doesCommuteExist);
}

CommuteState commuteSaveFailure(
    CommuteState commuteState, CommuteSaveFailure action) {
  return CommuteState(null, false, action.commuteSaveErrorMessage,
      commuteState.doesCommuteExist);
}

CommuteState commuteDeleteSuccess(
    CommuteState commuteState, CommuteDeleteSuccess action) {
  return CommuteState(null, false, '', false);
}

CommuteState commuteDeletePending(
    CommuteState commuteState, CommuteDeletePending action) {
  return CommuteState(null, true, '', commuteState.doesCommuteExist);
}

CommuteState commuteDeleteFailure(
    CommuteState commuteState, CommuteDeleteFailure action) {
  return CommuteState(null, false, action.commuteDeleteErrorMessage,
      commuteState.doesCommuteExist);
}

CommuteState commuteSetExists(
    CommuteState commuteState, CommuteSetExists action) {
  return CommuteState(commuteState.commute, false,
      commuteState.commuteErrorMessage, action.exists);
}

CommuteState commuteClearError(
    CommuteState commuteState, CommuteClearError action) {
  return CommuteState(
      commuteState.commute, false, '', commuteState.doesCommuteExist);
}

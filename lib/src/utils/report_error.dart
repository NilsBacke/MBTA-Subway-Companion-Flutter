import 'package:sentry/sentry.dart';

final SentryClient _sentry = SentryClient(
    dsn:
        "https://ef56f72a2bb447328e296072ac4c97fd:278954e86dad4552ab2851109f4db774@sentry.io/1532149");

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  print(stackTrace);
  try {
    _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  } catch (e) {
    print("No Internet connection to upload sentry logs");
  }
}

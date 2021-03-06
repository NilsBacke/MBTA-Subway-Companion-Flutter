import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'src/app.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  // Crashlytics.instance.enableInDevMode = true;

  // // Pass all uncaught errors to Crashlytics.
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   Crashlytics.instance.onError(details);
  // };
  runZoned<Future<Null>>(() async {
    runApp(new App());
  }, onError: (error, stackTrace) async {
    await reportError(error, stackTrace);
  });
}

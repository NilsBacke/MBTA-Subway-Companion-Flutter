import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/config.dart';
import 'package:mbta_companion/src/services/utils/executeCall.dart';
import 'package:mbta_companion/src/services/utils/makeRequest.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

class GoogleAPIService {
  static final newAPIURL = AWS_API_URL;
  static final awsAPIKey = AWS_API_KEY;
  static final directionRoute = "/stops/direction";
  static final distanceMatrixRoute = "/stops/timebetween";
  static final timeToWalkRoute = "/stops/timebetweenwalk";

  // returns time in minutes
  static Future<int> getTimeBetweenStops(Stop stop1, Stop stop2) async {
    final result = await makeRequest(Method.GET,
        "$newAPIURL$distanceMatrixRoute?stop1Name=${stop1.name.replaceAll(" ", "%20")}&stop2Name=${stop2.name.replaceAll(" ", "%20")}",
        headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(timeBetweenStopsErrorMessage);
      }
    }

    return int.parse(result.payload['minutes']);
  }

  static Future<String> getTimeToWalk(Stop stop, LocationData location) async {
    final result = await makeRequest(Method.GET,
        "$newAPIURL$timeToWalkRoute?stopName=${stop.name.replaceAll(" ", "%20")}&latitude=${location.latitude}&longitude=${location.longitude}",
        headers: {"x-api-key": awsAPIKey});

    if (result.payload != null && result.payload['minutes'] != null) {
      return result.payload['minutes'];
    }
    return null;
  }

  static String getArrivalTime(DateTime time, int minutes) {
    final dateTime = time.add(Duration(minutes: minutes));
    return TimeOfDayHelper.convertToString(TimeOfDay.fromDateTime(dateTime),
        accountForTimeZone: true, includeAMPM: false);
  }

  /**
   * Returns the end stop that the train is going towards
   * Returns null if nothing is found
   */
  static Future<String> getDirectionFromRoute(Stop stop1, Stop stop2) async {
    final result = await makeRequest(Method.GET,
        "$newAPIURL$directionRoute?stop1Name=${stop1.name.replaceAll(" ", "%20")}&stop2Name=${stop2.name.replaceAll(" ", "%20")}",
        headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(directionErrorMessage);
      }
    }

    return result.payload['direction'];
  }
}

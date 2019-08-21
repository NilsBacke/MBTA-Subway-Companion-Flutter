import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/polyline.dart';
import 'package:mbta_companion/src/models/polylineData.dart';
import 'package:mbta_companion/src/models/vehicle.dart';
import 'package:mbta_companion/src/services/config.dart';
import 'package:mbta_companion/src/services/utils/makeRequest.dart';
import '../models/stop.dart';
import 'dart:convert';
import 'utils/executeCall.dart';

class MBTAService {
  static final newAPIURL = AWS_API_URL;
  static final awsAPIKey = AWS_API_KEY;
  static final nearestStopRoute = "/stops/nearest";
  static final nearbyStopsRoute = "/stops/allnearby";
  static final stopsAtSameLocationRoute = "/stops/location";
  static final alertsRoute = "/stops/alerts";
  static final neighborStopRoute = "/stops/neighbor";
  static final vehiclesRoute = "/vehicles";
  static final polylinesRoute = "/polylines";
  static final rangeInMiles = 100;
  static final apiKey = MBTA_API_KEY;
  static final baseURL = MBTA_API_URL;

  // returns a list of the 2 stops that is closest to the given location data
  // will be the same stop, but both directions
  static Future<List<Stop>> fetchNearestStop(LocationData locationData) async {
    final route =
        "$newAPIURL$nearestStopRoute?latitude=${locationData.latitude}&longitude=${locationData.longitude}";
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(nearestStopErrorMessage);
      }
    }

    return _jsonToListOfStops(result.payload);
  }

  // range in miles
  static Future<List<Stop>> fetchNearbyStops(LocationData locationData,
      {int range}) async {
    final route =
        "$newAPIURL$nearbyStopsRoute?latitude=${locationData.latitude}&longitude=${locationData.longitude}" +
            (range != null ? "&range=" + range.toString() : "");
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(nearbyStopsErrorMessage);
      }
    }

    return _jsonToListOfStops(result.payload);
  }

  static Future<List<Stop>> fetchAllStops(LocationData locationData) async {
    return await fetchNearbyStops(locationData, range: 200000);
  }

  static Future<List<Stop>> fetchAllStopsAtSameLocation(Stop stop) async {
    final route = "$newAPIURL$stopsAtSameLocationRoute";
    final result = await makeRequest(Method.POST, route,
        headers: {"x-api-key": awsAPIKey}, body: json.encode(stop));

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(allStopsAtSameLocationErrorMessage);
      }
    }

    return _jsonToListOfStops(result.payload);
  }

  static Future<List<Alert>> fetchAlertsForStop(
      {@required String stopId}) async {
    final route = "$newAPIURL$alertsRoute?stopId=$stopId";
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(alertsErrorMessage);
      }
    }

    List<Alert> alerts = List();
    for (final alert in result.payload) {
      alerts.add(Alert.fromJson(alert));
    }
    return alerts;
  }

  static Future<Stop> getAssociatedStop({@required String stopId}) async {
    final route = "$newAPIURL$neighborStopRoute?stopId=$stopId";
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(associatedStopErrorMessage);
      }
    }

    return Stop.from(result.payload);
  }

  static Future<List<Vehicle>> fetchVehicles() async {
    final route = "$newAPIURL$vehiclesRoute";
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      if (result.payload['error'] != null) {
        print(result.payload['error']);
        throw new Exception(result.payload['userError']);
      } else {
        print(result.error);
        throw new Exception(vehiclesErrorMessage);
      }
    }

    List<Vehicle> vehicles = List();
    for (final vehicle in result.payload) {
      vehicles.add(Vehicle.fromJson(vehicle));
    }
    return vehicles;
  }

  static Future<List<Polyline>> fetchPolylines() async {
    // final route = "$newAPIURL$polylinesRoute";
    // final result =
    //     await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    // if (result.hasError) {
    //   if (result.payload['error'] != null) {
    //     print(result.payload['error']);
    //     throw new Exception(result.payload['userError']);
    //   } else {
    //     print(result.error);
    //     throw new Exception(polylinesErrorMessage);
    //   }
    // }

    List<Polyline> polylines = List();
    for (final polyline in allPolylinesJson) {
      polylines.add(Polyline.fromJson(polyline));
    }
    return polylines;
  }

  static List<Stop> _jsonToListOfStops(dynamic jsonData) {
    List<Stop> list = List<Stop>();
    for (final obj in jsonData) {
      list.add(Stop.from(obj));
    }
    return list;
  }
}

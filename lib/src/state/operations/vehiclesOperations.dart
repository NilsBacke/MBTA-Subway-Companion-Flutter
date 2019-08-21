import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/vehiclesActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'dart:io' show Platform;

ThunkAction fetchVehicles(bool activatePending) {
  return (Store store) async {
    Future(() async {
      if (activatePending) {
        store.dispatch(VehiclesFetchPending());
      }
      try {
        var vehicles = await MBTAService.fetchVehicles();
        store.dispatch(VehiclesFetchSuccess(vehicles));
      } catch (e, stackTrace) {
        print("$e");
        store.dispatch(VehiclesFetchFailure(e.toString()));
        reportError(e, stackTrace);
      }
    });
  };
}

ThunkAction fetchBitmap() {
  return (Store store) async {
    Future(() async {
      final bitmapmap = Map<String, BitmapDescriptor>();
      String sizeString = Platform.isIOS ? "48" : "96";
      bitmapmap['Red Line'] = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), "assets/red-arrow-$sizeString.png");
      bitmapmap['Mattapan Line'] = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), "assets/red-arrow-$sizeString.png");
      bitmapmap['Orange Line'] = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), "assets/orange-arrow-$sizeString.png");
      bitmapmap['Green Line'] = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), "assets/green-arrow-$sizeString.png");
      bitmapmap['Blue Line'] = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(), "assets/blue-arrow-$sizeString.png");
      store.dispatch(BitmapFetchSuccess(bitmapmap));
    });
  };
}

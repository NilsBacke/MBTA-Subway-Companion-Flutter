import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget mapWidget(
    {@required List<Marker> markers,
    @required LatLng latlng,
    @required List<Polyline> polylines,
    @required bool isVehiclesLoading,
    @required Function(bool) getVehicles}) {
  return Container(
    child: Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: latlng,
            zoom: 15,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: markers.toSet(),
          polylines: polylines.toSet(),
        ),
        Positioned(
          bottom: Platform.isIOS ? 75.0 : 12.0,
          right: 12.0,
          child: FloatingActionButton(
            child: Icon(
              Icons.refresh,
              color: Colors.grey[800],
            ),
            onPressed: () => getVehicles(true),
            elevation: 2.0,
          ),
        ),
        isVehiclesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    ),
  );
}

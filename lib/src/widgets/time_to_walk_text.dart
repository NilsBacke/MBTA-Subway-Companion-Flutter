import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/google_api_service.dart';
import 'package:mbta_companion/src/services/location_service.dart';

Widget timeToWalkText(BuildContext context, Stop stop, LocationData location) {
  const threeDashes = "---";
  const MAX_WALKING_DISTANCE = 1.5;

  if (location == null ||
      LocationService.getDistanceFromStop(stop, location) >
          MAX_WALKING_DISTANCE) {
    return Container();
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Divider(),
      Center(
        child: Container(
          padding: EdgeInsets.all(4.0),
          child: FutureBuilder(
            future: GoogleAPIService.getTimeToWalk(stop, location),
            builder: (context, snapshot) {
              var minutes;
              if (snapshot.hasData && snapshot.data != null) {
                minutes = snapshot.data;
              } else {
                minutes = threeDashes;
              }

              return Text(
                "It will take $minutes minutes to walk to ${stop.name}",
                style: Theme.of(context).textTheme.caption,
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
    ],
  );
}

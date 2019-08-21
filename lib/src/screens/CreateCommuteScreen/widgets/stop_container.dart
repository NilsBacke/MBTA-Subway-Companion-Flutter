import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/widgets/empty_card.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';

Widget stopContainer(BuildContext context, bool homeStop, String title,
    String body, Stop stop, Function(bool, BuildContext, Stop) onSelectStop) {
  return Container(
    padding: EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.body2,
          ),
        ),
        stop == null
            ? emptyCard(context, homeStop, body, stop, onSelectStop)
            : StopCard(
                stop: stop,
                timeCircles: false,
                onTap: (_) {
                  onSelectStop(homeStop, context, stop);
                },
                includeOtherInfo: false,
              ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';

Widget emptyCard(BuildContext context, bool homeStop, String text,
    Stop currentStop, Function(bool, BuildContext, Stop) onSelectStop) {
  return GestureDetector(
    onTap: () {
      onSelectStop(homeStop, context, currentStop);
    },
    child: Container(
      height: 75.0,
      child: Card(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ),
    ),
  );
}

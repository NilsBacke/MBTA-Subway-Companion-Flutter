import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/prediction.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/google_api_service.dart';
import 'package:mbta_companion/src/services/mbta_stream_service.dart';

class CommuteTimeCircleCombo extends StatefulWidget {
  final Stop startStop;
  final Stop endStop;

  CommuteTimeCircleCombo(this.startStop, this.endStop);

  @override
  _CommuteTimeCircleComboState createState() => _CommuteTimeCircleComboState();
}

class _CommuteTimeCircleComboState extends State<CommuteTimeCircleCombo> {
  List<Prediction> predictions = [null, null];
  StreamSubscription subscription;
  int minutes;

  @override
  void initState() {
    getStream();
    super.initState();
  }

  Future<void> getStream() async {
    final stream =
        await MBTAStreamService.streamPredictionsForStopId(widget.startStop.id);
    try {
      this.minutes = await GoogleAPIService.getTimeBetweenStops(
          widget.startStop, widget.endStop);
    } catch (e) {
      this.minutes = null;
    }

    this.subscription = stream.listen((PredictionEvent event) {
      if (!this.mounted) {
        return;
      }

      print("event type: ${event.event}");
      print("event predictions[0]: ${event.predictions[0]}");

      switch (event.event) {
        case "reset":
          setState(() {
            this.predictions = event.predictions;
          });
          break;
        case "update":
          _updatePredictions(event.predictions[0]);
          break;
        case "add":
          _addPrediction(event.predictions[0]);
      }
    });

    final singlePred =
        await MBTAStreamService.getSinglePrediction(widget.startStop.id);
    if (this.mounted) {
      setState(() {
        this.predictions = singlePred.predictions;
      });
    }
  }

  void _updatePredictions(Prediction pred) {
    if (this.predictions[0].id == pred.id) {
      setState(() {
        this.predictions = [pred, this.predictions[1]];
      });
    } else if (this.predictions[1].id == pred.id) {
      setState(() {
        this.predictions = [this.predictions[0], pred];
      });
    }
  }

  void _addPrediction(Prediction pred) {
    setState(() {
      this.predictions[0] = this.predictions[1];
      this.predictions[1] = pred;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        arrivalTimeCircle(
          pred: predictions[0],
        ),
        arrivalTimeCircle(
          pred: predictions[1],
          height: 40.0,
          width: 40.0,
        ),
      ],
    );
  }

  Widget arrivalTimeCircle(
      {@required Prediction pred, double height = 55.0, double width = 55.0}) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: height,
            width: width,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 2.0,
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            child: Center(
              child: Text(
                (pred == null || this.minutes == null)
                    ? "---"
                    : GoogleAPIService.getArrivalTime(pred.time, this.minutes),
                style: TextStyle(fontSize: width / 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

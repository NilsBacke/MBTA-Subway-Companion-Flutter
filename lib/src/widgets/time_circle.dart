import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/prediction.dart';
import 'package:mbta_companion/src/services/mbta_stream_service.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

class TimeCircleCombo extends StatefulWidget {
  final String stopId;

  TimeCircleCombo(this.stopId);

  @override
  _TimeCircleComboState createState() => _TimeCircleComboState();
}

class _TimeCircleComboState extends State<TimeCircleCombo> {
  List<Prediction> predictions = [null, null];
  StreamSubscription subscription;
  String manualPredictionTextOverride = "---";

  @override
  void initState() {
    getStream();
    super.initState();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    predictions = [null, null];
    if (subscription != null) {
      subscription.cancel();
    }
    manualPredictionTextOverride = "---";
    getStream();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> getStream() async {
    final stream =
        await MBTAStreamService.streamPredictionsForStopId(widget.stopId);

    if (stream == null) {
      return;
    }

    subscription = stream.listen((PredictionEvent event) {
      if (!this.mounted) {
        return;
      }

      setState(() {
        manualPredictionTextOverride = '';
      });

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
    return SizedBox(
      width: 95.0,
      child: rowWidget(this.predictions),
    );
  }

  Widget rowWidget(List<Prediction> predictions) {
    assert(predictions != null);
    assert(predictions.length == 2);

    return Row(
      children: <Widget>[
        TimeCircle(predictions[0], manualPredictionTextOverride),
        TimeCircle(
          predictions[1],
          manualPredictionTextOverride,
          height: 40.0,
          width: 40.0,
        ),
      ],
    );
  }
}

class TimeCircle extends StatelessWidget {
  final Prediction prediction;
  final String overrideText;
  final double height;
  final double width;

  TimeCircle(this.prediction, this.overrideText,
      {this.height = 55.0, this.width = 55.0});

  Widget emptyTimeCircle() {
    final double fontSize = this.width / 2.75;
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: height,
            width: width,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 2.0,
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            child: Center(
              child: Text(
                overrideText,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeCircle() {
    return SizedBox(
      height: height,
      width: width,
      child: StreamBuilder<int>(
        // in seconds
        stream: Stream.periodic(
          Duration(seconds: 1),
          compute,
        ),
        builder: (context, snapshot) {
          Color color = Colors.white;
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data < 60) {
              color = Colors.red;
            } else if (snapshot.data < 180) {
              color = Colors.yellow;
            }
          }

          String timeText = "---";
          double fontSize = this.width / 2.75;
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data <= 0) {
              timeText = "BOARD";
              fontSize = this.width / 4;
            } else {
              timeText = TimeOfDayHelper.formatSeconds(snapshot.data);
            }
          }

          double value = 1.0;
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data < 60) {
              value = (1 - snapshot.data / 60);
            }
          }
          return Stack(
            children: <Widget>[
              SizedBox(
                height: height,
                width: width,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 2.0,
                ),
              ),
              Positioned.directional(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: Text(
                    timeText,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (overrideText == '') {
      return timeCircle();
    }
    return emptyTimeCircle();
  }

  int compute(int countdown) {
    if (this.prediction == null) {
      return null;
    }
    return this.prediction.time.difference(DateTime.now()).inSeconds;
  }
}

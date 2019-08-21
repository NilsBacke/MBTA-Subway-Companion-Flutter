import 'package:flutter/material.dart';

Widget errorTextWidget(BuildContext context, {String text}) {
  return Container(
    child: Center(
      child: Text(
        text ?? "Error loading data. Please try again.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body2,
      ),
    ),
  );
}

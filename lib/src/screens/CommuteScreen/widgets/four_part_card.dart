import 'package:flutter/material.dart';

class FourPartCard extends StatelessWidget {
  final String cardTitleText;
  final Widget stopWidget1;
  final Widget stopWidget2;
  final Widget trailing;
  final Widget bottomWidget;

  const FourPartCard(
      this.cardTitleText, this.stopWidget1, this.stopWidget2, this.bottomWidget,
      {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  cardTitleText,
                  style: Theme.of(context).textTheme.title,
                ),
                trailing,
              ],
            ),
            Divider(),
            stopWidget1,
            Divider(),
            stopWidget2,
            bottomWidget
          ],
        ),
      ),
    );
  }
}

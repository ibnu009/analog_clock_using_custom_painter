import 'package:bibit_technical_test/utils/stockbit_theme.dart';
import 'package:flutter/material.dart';

import 'component/hour_hand.dart';
import 'component/minute_hand.dart';
import 'component/wheel_circle_painter.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  ClockState createState() => ClockState();
}

class ClockState extends State<Clock> with TickerProviderStateMixin {
  double wheelSize = 300;
  final double longNeedleHeight = 40;
  final double shortNeedleHeight = 25;

  @override
  Widget build(BuildContext context) {
    WheelCircle wheelCircle = WheelCircle(
        wheelSize: wheelSize,
        longNeedleHeight: longNeedleHeight,
        shortNeedleHeight: shortNeedleHeight,
        context: context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: wheelSize,
              height: wheelSize,
              child: Container(
                  color: Colors.transparent,
                  child: Center(child: CustomPaint(painter: wheelCircle))),
            ),
            Container(
              width: wheelSize,
              height: wheelSize,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: StockbitTheme.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const MinuteHand(),
            const HourHand(),
          ],
        )
      ],
    );
  }
}

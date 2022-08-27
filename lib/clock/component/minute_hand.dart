import 'dart:math';

import 'package:bibit_technical_test/bloc/minute/minute_bloc.dart';
import 'package:bibit_technical_test/utils/stockbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MinuteHand extends StatefulWidget {
  const MinuteHand({Key? key}) : super(key: key);

  @override
  MinuteHandState createState() => MinuteHandState();
}

class MinuteHandState extends State<MinuteHand>
    with SingleTickerProviderStateMixin {
  late double wheelSize;
  double degree = 0;
  int chosenValue = 0;
  late double radius;
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    wheelSize = 300;
    radius = wheelSize / 2;
    animationController = AnimationController.unbounded(vsync: this);
    degree = 0;
    animationController.value = degree;
  }

  double degreeToRadians(double degrees) => degrees * (pi / 180);

  double roundToBase(double number, int base) {
    double reminder = number % base;
    double result = number;
    if (reminder < (base / 2)) {
      result = number - reminder;
    } else {
      result = number + (base - reminder);
    }
    return result;
  }

  _panUpdateHandler(DragUpdateDetails d) {
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange = verticalRotation + horizontalRotation;

    double value = degree + (rotationalChange / 5);

    setState(() {
      degree = value > 0 ? value : 0;
      animationController.value = degree;
      var a = degree < 360 ? degree.roundToDouble() : degree - 360;
      var degrees = roundToBase(a.roundToDouble(), 10);
      chosenValue = degrees ~/ 6 == 60 ? 0 : degrees ~/ 6;
      BlocProvider.of<MinuteBloc>(context).add(SetMinute(chosenValue));
    });
  }

  _panEndHandler(DragEndDetails d) {
    var a = degree < 360 ? degree.roundToDouble() : degree - 360;
    animationController
        .animateTo(roundToBase(a.roundToDouble(), 10),
            duration: const Duration(milliseconds: 551), curve: Curves.easeOutBack)
        .whenComplete(() {
      setState(() {
        degree = roundToBase(a.roundToDouble(), 10);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GestureDetector draggableMinute = GestureDetector(
      onPanUpdate: _panUpdateHandler,
      onPanEnd: _panEndHandler,
      child: Container(
        height: radius * 2,
        width: radius * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
        ),
        child: Align(
          alignment: const Alignment(0, 0),
          child: AnimatedBuilder(
            animation: animationController,
            builder: (ctx, w) {
              return Transform.rotate(
                angle: degreeToRadians(animationController.value),
                child: Container(
                  width: 6,
                  height: 196,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.transparent,
                            StockbitTheme.primaryColor,
                            StockbitTheme.primaryColor,
                          ]),
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ),
      ),
    );
    return draggableMinute;
  }
}

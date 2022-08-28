import 'dart:async';

import 'package:bibit_technical_test/bloc/hour/hour_bloc.dart';
import 'package:bibit_technical_test/bloc/minute/minute_bloc.dart';
import 'package:bibit_technical_test/clock/clock.dart';
import 'package:bibit_technical_test/utils/bar_chart.dart';
import 'package:bibit_technical_test/utils/date_ext.dart';
import 'package:bibit_technical_test/utils/notification_helper.dart';
import 'package:bibit_technical_test/utils/stockbit_theme.dart';
import 'package:bibit_technical_test/utils/string_ext.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String hour = '0';
  String minute = '0';
  bool isActivated = false;
  bool isAm = true;
  List<bool> isSelected = List.generate(2, (index) => false);

  @override
  void initState() {
    super.initState();
    NotificationHelper.init();
    listenNotification();
    isSelected[0] = true;
  }

  void listenNotification() =>
      NotificationHelper.onNotification.stream.listen(onClickNotification);

  void onClickNotification(String? payload) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: BarChart(
            data: [
              TimeOpen(
                payload.toDateFormat('yyyy-MM-dd  hh:mm a'),
                DateTime.now().difference(DateTime.parse(payload!)).inSeconds,
                charts.ColorUtil.fromDartColor(
                  StockbitTheme.primaryColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showSnackBar() {
    String formattedDate = setDateTime().formatDate('yyyy-MM-dd  hh:mm a');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm active for $formattedDate'),
      ),
    );
  }

  DateTime setDateTime() {
    DateTime now = DateTime.now();
    return DateTime(
        now.year,
        now.month,
        now.hour > (isAm ? int.parse(hour) : int.parse(hour) + 12)
            ? now.day + 1
            : now.hour == (isAm ? int.parse(hour) : int.parse(hour) + 12) &&
            now.minute >= int.parse(minute) &&
            now.second > 0
            ? now.day + 1
            : now.day,
        isAm ? int.parse(hour) : int.parse(hour) + 12,
        int.parse(minute));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stockbit Technical Test',
          style: TextStyle(
            color: StockbitTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Align(
            alignment: Alignment.center,
            child: Text(
              isActivated ? 'Active' : 'Off',
              style: TextStyle(
                color: isActivated ? StockbitTheme.primaryColor : Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Switch(
              value: isActivated,
              activeColor: StockbitTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  isActivated = value;
                  if (isActivated) {
                    print('payload is ${setDateTime().formatDate('yyyy-MM-dd  hh:mm a')}');
                    NotificationHelper.showNotificationSchedule(
                        title: 'Alarm',
                        body: 'Your alarm is active',
                        payload: setDateTime().toString(),
                        scheduleDate: setDateTime());
                    Future.delayed(
                        Duration(
                            seconds: setDateTime()
                                .difference(DateTime.now())
                                .inSeconds), () {
                      isActivated = false;
                    });
                    showSnackBar();
                  } else {
                    NotificationHelper.cancel();
                  }
                });
              })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<HourBloc, HourState>(
                  builder: (context, state) {
                    Future.delayed(Duration.zero, () {
                      if (state is LoadedHour) {
                        setState(() {
                          hour = state.hour;
                        });
                      }
                    });
                    return Text(state is LoadedHour ? state.hour : '00',
                        style: const TextStyle(
                            fontSize: 54, fontWeight: FontWeight.bold));
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(':',
                    style:
                    TextStyle(fontSize: 54, fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 5,
                ),
                BlocBuilder<MinuteBloc, MinuteState>(
                  builder: (context, state) {
                    Future.delayed(Duration.zero, () {
                      if (state is LoadedMinute) {
                        setState(() {
                          minute = state.minute;
                        });
                      }
                    });
                    return Text(state is LoadedMinute ? state.minute : '00',
                        style: const TextStyle(
                            fontSize: 54, fontWeight: FontWeight.bold));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ToggleButtons(
                    selectedColor: StockbitTheme.primaryColor,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                          if (buttonIndex == index) {
                            isAm = index == 0 ? true : false;
                            isActivated = false;
                            isSelected[buttonIndex] = true;
                            NotificationHelper.cancel();
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                    children: const [
                      Text(
                        'AM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'PM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Clock(),
        ],
      ),
    );
  }
}

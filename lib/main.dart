import 'package:bibit_technical_test/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'bloc/hour/hour_bloc.dart';
import 'bloc/minute/minute_bloc.dart';

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HourBloc>(
          create: (context) => HourBloc(),
        ),
        BlocProvider<MinuteBloc>(
          create: (context) => MinuteBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Bibit Technical',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

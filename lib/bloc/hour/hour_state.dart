part of 'hour_bloc.dart';

@immutable
abstract class HourState {}

class InitiateHourState extends HourState {}

class LoadedHour extends HourState {
  final String hour;

  LoadedHour({required this.hour});
}
